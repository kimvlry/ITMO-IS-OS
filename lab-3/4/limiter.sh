# Создайте скрипт, который будет в автоматическом режиме обеспечивать, чтобы тот процесс, который был запущен первым, 
# использовал ресурс процессора не более чем на 10%. Послав сигнал, завершите работу процесса, запущенного третьим. 
# Проверьте, что созданный скрипт по-прежнему удерживает потребление ресурсов процессора первым процессом 
# в заданном диапазоне

#!/bin/bash

if [ ! -f "PIDs.txt" ]; then
    echo "no PIDs.txt"
    exit 1
fi

first=$(head -n 1 "PIDs.txt")
third=$(sed -n '3p' "PIDs.txt")

ps -p "$first" || { echo "first process not found"; exit 1; }
ps -p "$third" || { echo "third process not found"; exit 1; }

percent_limit=10
{
    while true; do
        cpu_usage=$(top -bn1 -p $first | tail -n +8 | awk '{print $9}')
        cpu_usage=${cpu_usage%.*}
        current_nice=$(top -bn1 -p $first | tail -n +8 | awk '{print $4}')

        if [[ $cpu_usage -gt $percent_limit ]] && [[ $current_nice -lt 19 ]]; then
            renice -n $((current_nice + 1)) -p $first
        fi 
        echo "current CPU usage: $cpu_usage%"
        sleep 5
    done
} & 

kill "$third" >/dev/null
echo "killed process 3"
