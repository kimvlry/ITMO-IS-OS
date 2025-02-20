# Вывести в файл список PID всех процессов, которые были запущены 
# командами, расположенными в /sbin/
#
#! /bin/bash

ps a -o pid,cmd --no-headers | awk '$2 ~ "^/sbin/" {print $1}' > output.txt
