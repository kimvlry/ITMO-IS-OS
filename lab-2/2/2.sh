# Вывести в файл список PID всех процессов, которые были запущены 
# командами, расположенными в /sbin/
#
#! /bin/bash

ps -eo pid,cmd --no-headers | awk '$2 ~ "^/sbin/" {print $1}' > output.txt
#
# ^ start  of the string
# -e select all processes.  Identical to -A
# -o output format
