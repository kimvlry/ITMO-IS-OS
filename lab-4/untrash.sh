# a. Скрипту передается один параметр – имя файла, который нужно восстановить 
#    (без полного пути – только имя).
#
# b. Скрипт по файлу trash.log должен найти все записи, содержащие в качестве имени файла
#    переданный параметр, и выводить по одному на экран полные имена таких файлов с запросом
#    подтверждения.
#
# c. Если пользователь отвечает на подтверждение положительно, то предпринимается попытка
#    восстановить файл по указанному полному пути (создать в соответствующем каталоге жесткую
#    ссылку на файл из trash и удалить соответствующий файл из trash). Если каталога, указанного
#    в полном пути к файлу, уже не существует, то файл восстанавливается в домашний каталог
#    пользователя с выводом соответствующего сообщения. При невозможности создать жесткую
#    ссылку, например, из-за конфликта имен, пользователю предлагается изменить имя
#    восстанавливаемого файла.

#!/bin/bash

log="$HOME/.trash.log"
if [[ ! -f "$log" ]]; then
    echo "there's no trash log"
    exit 1
fi

echo "input name of file to restore"
read filename

while IFS= read -r line; do
    # format: removed /path/ORIGINAL
    #         created hard link: /path/LINK
    if [[ "$line" == *"removed"*"$filename"* ]]; then
        echo "$line"
        if IFS= read -r nextline && [[ "$nextline" == *"created hard link:"* ]]; then 
            link_name=$(echo "$line" | awk -F': ' '{print $2}')
            echo "restore $link_name? y/n"
            dir=$(dirname "$link_name")
            original_name=$(basename "$link_name" | sed -E 's/_[0-9]+//')

            read input 
            if [[ "$input" == "y" ]]; then
                echo "$original_name"
                echo "$dir"
            fi
        fi
    fi
done < "$log"

