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
while true; do
    cpu_usage=$(ps -p "$first" -o %cpu --no-headers | awk '{print $1}')
    usage_check=$(echo "$cpu_usage > $percent_limit" | bc)
    if [[ "$usage_check" -eq 1 ]]; then
        echo "current cpu usage = $cpu_usage , lowering priority"
        sudo renice -n 19 -p "$first" > /dev/null
        sleep 3
    else 
        echo "current CPU usage = $cpu_usage , all good"
        break
    fi
done
echo "resulting CPU usage = $cpu_usage"

kill -9 "$third"
echo "killed 3"

