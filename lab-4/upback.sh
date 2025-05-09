# Скрипт должен скопировать в каталог /home/user/restore/ все файлы из актуального на
# данный момент каталога резервного копирования (имеющего в имени наиболее свежую дату), 
# за исключением файлов с предыдущими версиями.
#
#!/bin/bash

restore_dir="$HOME/restore/"
latest_backup=$(ls -d "$HOME"/Backup-* | sort -V | tail -n 1)

if [[ ! -d "$latest_backup" ]]; then
    echo "no backups available"
    exit 0
fi

mkdir -p "$restore_dir"
find "$latest_backup" -type f ! -name "*.[0-9]*" -exec cp -n "{}" "$restore_dir" \;

echo "all non-versioned files from $latest_backup have been restored into $restore_dir. supercool."
