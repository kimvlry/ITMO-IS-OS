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
#
#!/bin/bash

trash="$HOME/.trash"
logfile="$HOME/.trash.log"

restore_file() {
    local trash_path="$1"
    local original_path="$2"

    if [[ ! -f "$trash_path" ]]; then
        echo "file '$trash_path' not found in .trash!"
        return 1
    fi

    local original_dir=$(dirname "$original_path")
    local original_name=$(basename "$original_path")

    if [[ ! -d "$original_dir" ]]; then
        echo "original directory '$original_dir' not found."
        read -p "restore to home directory? [y/n] " answer
        [[ "$answer" =~ ^[Nn] ]] && return 1
        original_dir="$HOME"
    fi

    local target_path="$original_dir/$original_name"
    if [[ -e "$target_path" ]]; then
        echo "name conflict: '$target_path' already exists"
        read -p "enter new name (or leave empty to skip): " new_name
        [[ -z "$new_name" ]] && return 1
        target_path="$original_dir/$new_name"
    fi

    if ln -- "$trash_path" "$target_path" 2>/dev/null; then
        rm -- "$trash_path"
        echo "successfully restored to: $target_path"
    else
        echo "failed to restore file"
    fi
}

###

if [[ ! -f "$logfile" ]]; then
    echo "error: $logfile not found"
    exit 1
fi

if [[ -z "$1" ]]; then
    echo "usage: $0 <filename>"
    exit 1
fi
search_pattern="$1"

exec 3<"$logfile"
while true; do
    IFS= read -u3 -r date_line || break
    IFS= read -u3 -r removed_line || break
    IFS= read -u3 -r created_line || break
    IFS= read -u3 -r empty_line || break

    [[ "$removed_line" =~ ^removed[[:space:]]+(.+)$ ]] || continue
    original_path="${BASH_REMATCH[1]}"
    
    [[ "$created_line" =~ ^created[[:space:]]+hard[[:space:]]+link:[[:space:]]+(.+)$ ]] || continue
    trash_path="${BASH_REMATCH[1]}"

    original_name=$(basename "$original_path")
    if [[ "$original_name" == *"$search_pattern"* ]]; then
        echo -e "\nfound candidate:"
        echo "original name:  $original_name"
        echo "original path:  $original_path"
        echo "trash path:     $trash_path"
        echo "deleted at:     $date_line"
        
        read -p "restore this file? [y/n] " answer
        if [[ "$answer" =~ ^[Yy] ]]; then
            restore_file "$trash_path" "$original_path"
        fi
    fi
done
exec 3<&-
