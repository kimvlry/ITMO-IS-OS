#!/bin/bash
# Создать full.log, в который вывести строки файла /var/log/anaconda/X.log или,
# если таковой отсутствует, /var/log/installer/X.0.log содержащие предупреждения
# и информационные сообщения, заменив маркеры предупреждений и информационных сообщений
# на слова Warning: и Information:, чтобы в получившемся файле сначала шли все предупреждения,
# а потом все информационные сообщения. Вывести этот файл на экран.

if [ -d /var/log/anaconda ]; then
    dir="/var/log/anaconda"
elif [ -d /var/log/installer ]; then
    dir="/var/log/installer"
else
    echo "none of needed directories were found"
    exit
fi

echo "input log file name"
read filename
log_file="$dir/$filename"

if [ ! -f "$log_file" ]; then
    echo "log file not found"
    exit
fi

grep "WARNING" $log_file | sed 's/WARNING/Warning:/' > warnings.log
grep "INFO" $log_file | sed 's/INFO/Info:/' > infos.log

cat warnings.log infos.log > full.log
cat full.log

rm warnings.log infos.log
