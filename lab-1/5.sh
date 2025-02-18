#! /bin/bash
# Создать файл info.log, в который поместить все строки из файла /var/log/anaconda/syslog
# или, если таковой отсутствует, /var/log/installer/syslog второе поле в которых равно INFO

dir1="/var/log/anaconda/syslog"
dir2="/var/log/installer/syslog"

if [ -f "$dir1" ]; then
    awk '$2 == "INFO"' "$dir1" > info.log
elif [ -f "$dir2" ]; then
    awk '$2 == "INFO"' "$dir2" > info.log
else 
    echo "none of needed directories were found"
fi
