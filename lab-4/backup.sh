# a. Скрипт создаст в /home/user/ каталог с именем Backup-YYYY-MM-DD, где YYYY-MM-DD –
#    дата запуска скрипта, если в /home/user/ нет каталога с именем, соответствующим дате,
#    отстоящей от текущей менее чем на 7 дней. Если в /home/user/ уже есть «действующий»
#    каталог резервного копирования (созданный не ранее 7 дней от даты запуска скрипта), то новый
#    каталог не создается. Для определения текущей даты можно воспользоваться командой date.
#
# b. Если новый каталог был создан, то скрипт скопирует в этот каталог все файлы из каталога
#    /home/user/source/ (для тестирования скрипта создайте такую директорию и набор файлов
#    в ней). После этого скрипт выведет в режиме дополнения в файл /home/user/backup-report
#    следующую информацию: строка со сведениями о создании нового каталога с резервными
#    копиями с указанием его имени и даты создания; список файлов из /home/user/source/,
#    которые были скопированы в этот каталог.
#
# c. Если каталог не был создан (есть «действующий» каталог резервного копирования), то скрипт
#    должен скопировать в него все файлы из /home/user/source/ по следующим правилам: если
#    файла с таким именем в каталоге резервного копирования нет, то он копируется из
#    /home/user/source. 
#    Если файл с таким именем есть, то его размер сравнивается с размером
#    одноименного файла в действующем каталоге резервного копирования. 
#    Если размеры совпадают, файл не копируется. 
#    Если размеры отличаются, то файл копируется c автоматическим созданием
#    версионной копии, таким образом, в действующем каталоге резервного копирования появляются
#    обе версии файла (уже имеющийся файл переименовывается путем добавления дополнительного
#    расширения «.YYYY-MM-DD» (дата запуска скрипта), а скопированный сохраняет имя). 
#
#    После окончания копирования в файл /home/user/backup-report выводится строка о внесении
#    изменений в действующий каталог резервного копирования с указанием 
#    - его имени и даты внесения изменений
#    - строки, содержащие имена добавленных файлов с новыми именами
#    - строки с именами добавленных файлов с существовавшими в действующем каталоге
#    резервного копирования именами с указанием через пробел нового имени, присвоенного
#    предыдущей версии этого файла
#
#!/bin/bash

echo -n "input source folder absolute path: "
read source

source_path=$(realpath "$source")
if [ ! -d "$source_path" ]; then
    echo "error: directory $source_path doesn't exist."
    exit 1
fi

today=$(date +"%Y-%m-%d")
backup_directory=""

for i in {0..6}; do
    check_date=$(date -I -d "$today - $i days")
    current="$HOME/Backup-$check_date"
    if [ -d "$current" ]; then
        backup_directory="$current"
        break
    fi
done

backup_report="$HOME/backup-report"
tmp=$(mktemp)

if [ -z "$backup_directory" ]; then
    backup_directory="$HOME/Backup-$today"
    mkdir -p "$backup_directory" || { echo "error: could not create directory $backup_directory"; exit 1; }
    {
        printf "%s : created backup directory %s\nCOPIED:\n" "$today" "$backup_directory"
    } >> "$backup_report"

    cp -rp "$source_path/"* "$backup_directory/"
    find "$backup_directory" -type -f >> "$backup_report"
    printf "\n" >> "$backup_report"

    echo "backup directory created $backup_directory. backup successfully completed"
    exit 0
fi

cd "$source_path" || { echo "error: couldn't change directory to ${source_path}"; exit 1; }

find . -type f | while read -r file; do
    relative_file="${file#./}"
    destination_file="$backup_directory/$relative_file"

    mkdir -p "$(dirname "$destination_file")"
    
    if [ ! -e "$destination_file" ]; then
        cp -p "$file" "$destination_file"
        echo "ADD: $relative_file" >> "$tmp"
    else
        source_file_size=$(stat -c %s "$file")
        backup_file_size=$(stat -c %s "$destination_file")

        if [ "$source_file_size" -ne "$backup_file_size" ]; then
            mv "$destination_file" "$destination_file.$today"
            cp -p "$file" "$destination_file"
            echo "UPD: $relative_file $relative_file.$today" >> "$tmp"
        fi
    fi
done

if [ -s "$tmp" ]; then
    {
        printf "%s : changes in %s:\n" "$today" "$backup_directory"
        cat "$tmp"
        printf "\n"
    } >> "$backup_report"
fi

rm -f "$tmp"

echo "backup completed."
