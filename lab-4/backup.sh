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
echo "input source folder name (relative to root folder)"
read source

today=$(date +"%Y-%m-%d")
expired_date=$(date -I -d "$today - 7 days")

current=$today
while [ $current != $expired_date ]; do
    dir="/home/$user/Backup-${current}"
    if [ -d "$dir" ]; then
        backup_dir=$dir
        break
    fi
    current=$(date -I -d "$current - 1 day")
done;

source_path="/home/$user/${source}"
backup_report="/home/$user/backup-report"

if [ ! -f "$backup_report" ]; then
    touch "$backup_report"
fi

if [ -z $backup_dir ]; then
    backup_dir="/home/$user/Backup-${today}"
    mkdir "$backup_dir"
    echo -e "${today} : Created backup file $(basename "${backup_dir}") \n COPIED:" > "$backup_report"
    cp -rv "$source_path" "${backup_dir}" | awk -F"'" '{print $2}' >> "$backup_report"
    echo -e "\n" >> "$backup_report"
    exit 0
fi

touch tmp
find "$source_path" -type f -print0 | while IFS= read -r -d $'/0' file; do
    filename=$(basename "$file")
    if [ ! -e "$backup_dir/${filename}" ]; then
        cp "${source_path}/${filename}" "$backup_dir"
        echo "ADD: ${file}" >> tmp
    else
        old_size=$(stat -c %s "${backup_dir}/${file}")
        new_size=$(stat -c %s "${source_path}/${file}")
        if [[ $old_size != $new_size ]]; then
            old_name="${filename}"
            new_name="${filename}.${today}"
            mv "${backup_dir}/${old_name}" "${backup_dir}/${new_name}"
            cp "${source_path}/${old_name}" "${backup_dir}/${old_name}"
            echo "UPD: ${old_name} ${new_name}" >> tmp
        fi
    fi
done

{
    echo "${today} : ${source_path} was modified:"
    grep "ADD:" tmp
    grep "UPD:" tmp 
    echo -e "\n" 
} >> "$backup_report"

rm -rf tmp

