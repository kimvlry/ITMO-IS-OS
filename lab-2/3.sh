# Вывести на экран PID процесса, запущенного последним (с последним временем запуска).
#
#! /bin/bash

ps e -o pid,lstart --no-headers | grep -v "$$" | sort -k6 -k3,4 -k5 | tail -n1 | awk '{print $1}'
# -v = invert match
