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

log() {
    {
        timestamp=$(date +%s)
        echo $(date)
        echo "removed $1"
        echo -e "created hard link: $2\n"
    } >> "$logfile"
}

restore_file() {
    local trash_filename=$1
    local original_dest=$2
    local original_filename=$3

    if [[ ! -f "$trash_filename" ]]; then 
        echo "file $(basename "$trash_filename") couldn't be found in .trash!"
        return
    fi

    if [[ ! -d "$original_dest" ]]; then
        ln "$trash_filename" "$HOME"
        log "$trash_filename" "$HOME/$original_filename"
        rm "$trash_filename"
        echo "folder $original_dest doesn't exist. restored $original_filename into home directory instead."
        return
    fi

    if [[ -f "$original_dest/$original_filename" ]]; then
        while true; do
            echo "file named '$original_filename' already exists in $original_dest."
            echo -n "input different name: "
            read newname
            if [[ ! -f "$original_dest/$newname" ]]; then
                ln "$trash_filename" "$original_dest/$newname"
                rm "$trash_filename"
                log "$trash_filename" "$original_dest/$newname"
                echo "restored $original_filename into $original_dest/$newname"
                return
            fi
        done
    fi

    ln "$trash_filename" "$original_dest/$original_filename"
    rm "$trash_filename"
    log "$trash_filename" "$original_dest/$original_filename"
    echo "restored $original_filename into $original_dest"
}

#####

if [[ ! -f "$logfile" ]]; then
    echo "there's no trash log."
    exit 1
fi

if [ -z "$1" ]; then
    echo "error: no file name provided. please specify a name (name only, excluding path) of file to restore."
    exit 1
fi
original_filename="$1"

found_files=()
while read -r line; do
    # format: removed /path/<ORIGINAL>
    #         created hard link: /path/<ORIGINAL>_HARDLINK_<TIMESTAMP>
    if [[ "$line" =~ ^removed\ (.+)$ ]]; then
        original_path="${BASH_REMATCH[1]}"
        echo "FOUND ORIG: $original_path"
        read -r nextline
        if [[ "$nextline" =~ created\ hard\ link:\ (.+)$ ]]; then
            trash_filename="${BASH_REMATCH[1]}"
            echo "FOUND TRASH: $trash_filename"
            found_files+=("$original_path|$trash_filename")
        fi
    fi
done < "$logfile"

if [[ ${#found_files[@]} -eq 0 ]]; then
    echo "no entries found for '$original_filename'."
    exit 0
fi

for file_info in "${found_files[@]}"; do
    IFS="|" read -r original_filename trash_filename <<< "$file_info" 

    echo "Restore $original_filename from $trash_filename? (y/n)"
    read -r option

    if [[ "$option" == "y" ]]; then
        original_dest=$(dirname "$original_path")
        original_filename=$(basename "$original_path")

        restore_file "$trash_filename" "$original_dest" "$original_filename"
    fi
done

echo "completed successfully"
