# a. Скрипту передается один параметр – имя файла в текущем каталоге вызова скрипта.
#
# b. Скрипт проверяет, создан ли скрытый каталог trash в домашнем каталоге пользователя. 
#    Если он не создан – создает его.
#
# c. После этого скрипт создает в этом каталоге жесткую ссылку на переданный файл 
#    с уникальным именем (например, присваивает каждой новой ссылке имя, соответствующее 
#    следующему натуральному числу) и удаляет файл в текущем каталоге.
#
# d. Затем в скрытый файл trash.log в домашнем каталоге пользователя помещается запись,
#    содержащая полный исходный путь к удаленному файлу и имя созданной жесткой ссылки.
#
#!/bin/bash

trash="$HOME/.trash"
log="$HOME/.trash.log"

if [ -z "$1" ]; then
    echo "error: no file name provided. please specify a file name."
    exit 1
fi

file="$1"

if [ ! -e "$file" ]; then
    echo "error: file '$file' not found in the current directory."
    exit 1
fi

original=$(realpath "$file")
if [ $? -ne 0 ]; then
    echo "error: could not resolve the absolute path for '$file'."
    exit 1
fi

if [ ! -d "$trash" ]; then
    if ! mkdir "$trash"; then
        echo "error: could not create directory '$trash'."
        exit 1
    fi
    echo "created directory: $trash"
fi

timestamp=$(date +%s)
new_link_name="${trash}/$(basename "$file")_HARDLINK_${timestamp}"

if ln "$original" "$new_link_name"; then
    echo "created hard link: $new_link_name"
else
    echo "error: failed to create hard link for '$original'."
    exit 1
fi

if rm -- "$original"; then
    echo "removed file: $original"
else
    echo "error: failed to remove file '$original'."
    exit 1
fi

if [ ! -e "$log" ]; then
    touch "$log" || { echo "error: could not create log file '$log'."; exit 1; }
fi

{
    echo "$(date)"
    echo "removed '$original'"
    echo "created hard link: $new_link_name"
    echo
} >> "$log"

echo "completed successfully."
