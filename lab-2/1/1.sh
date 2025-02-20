# Посчитать количество процессов, запущенных пользователем user, и вывести 
# в файл получившееся число, а затем пары PID:команда для таких процессов.
#
#! /bin/bash

echo "enter user name"
read user
ps u $user --no-headers | wc -l > output.txt && \
ps u $user -o pid,cmd --no-headers | awk '{print $1 ":" $2}' >> output.txt
