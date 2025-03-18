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

#!/bin/bash

user=$(logname)
echo "Input source folder path (relative to home directory, e.g., ITMO/lab-4/test):"
read source

source_path="$HOME/${source}"
if [ ! -d "$source_path" ]; then
    echo "Ошибка: Директория $source_path не существует."
    exit 1
fi

today=$(date +"%Y-%m-%d")
backup_dir=""

for i in {0..6}; do
    check_date=$(date -I -d "$today - $i days")
    candidate="$HOME/Backup-$check_date"
    if [ -d "$candidate" ]; then
        backup_dir="$candidate"
        break
    fi
done

backup_report="$HOME/backup-report"
tmp=$(mktemp)

cd "$source_path" || exit 1

if [ -z "$backup_dir" ]; then
    backup_dir="$HOME/Backup-$today"
    mkdir -p "$backup_dir"
    {
        printf "%s : Created backup directory %s\nCOPIED:\n" "$today" "$backup_dir"
        rsync -av ./ "$backup_dir/"
        printf "\n"
    } >> "$backup_report"
    exit 0
fi

rsync -av --ignore-existing ./ "$backup_dir/" --out-format="ADD: %f" > "$tmp"

find . -type f | while read -r file; do
    rel_file="${file#./}"
    dest="$backup_dir/$rel_file"
    if [ -f "$dest" ]; then
        src_size=$(stat -c %s "$file")
        dest_size=$(stat -c %s "$dest")
        if [ "$src_size" -ne "$dest_size" ]; then
            mv "$dest" "$dest.$today"
            cp -p "$file" "$dest"
            echo "UPD: $rel_file $rel_file.$today" >> "$tmp"
        fi
    fi
done

if [ -s "$tmp" ]; then
    {
        printf "%s : Changes in %s:\n" "$today" "$backup_dir"
        cat "$tmp"
        printf "\n"
    } >> "$backup_report"
fi

rm -f "$tmp"
