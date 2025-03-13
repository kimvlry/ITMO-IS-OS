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

if ! ps -p "$first" >/dev/null; then
    echo "first proccess not found"
    exit 1
fi

if ! ps -p "$third" >/dev/null; then
    echo "third proccess not found"
    exit 1
fi

percent_limit=10
{
    while true; do
        cpu_usage=$(top -bn1 -p $first | tail +8 | awk '{print $9}')
        cpu_usage=${cpu_usage%.*}
        current_nice=$(top -bn1 -p $first | tail -n +8 | awk '{print $4}')

        if [[ $cpu_usage -gt 10 ]] && [[ $current_nice -lt 19 ]]; then
            echo "first proccess CPU usgae: ${cpu_usage} -> increasing nice by 1 from $current_nice..."
            renice -n $((current_nice + 1)) -p $first
        else
            echo "current CPU usage: $cpu_usage"
            break;
        fi
        sleep 2
    done
}


kill -9 "$third"
echo "killed proccess 3"

sleep 2
echo "current CPU usage of proccess 1:"
top -bn1 -p $first | tail -n + 8 | awk '{printf "PID: %s\nNI": %s\nCPU: %s%%\n", $1, $4, $9}'

