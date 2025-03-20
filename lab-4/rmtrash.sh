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

#!/bin/bash

trash="$HOME/.trash"

echo "Input file name. File must be located in current directory"
read file

if [[ "$(dirname "$file")" != "." ]]; then 
    echo "$file" not found in current dir
    exit 1
fi

if [ ! -d "$trash" ]; then
    mkdir "$trash"
    echo "Created ${trash}"
fi

links_count=$(stat -c %h "$file")
new_link_name="${trash}/${file}_$(( links_count - 1 ))"
ln "$file" "$new_link_name" && echo "created hard link: $new_link_name"


