# Написать скрипт, определяющий три процесса, которые за 1 минуту, прошедшую с момента 
# запуска скрипта, считали максимальное количество байт из устройства хранения данных. 
# Скрипт должен выводить PID, строки запуска и объем считанных данных, разделенные двоеточием.
#
#! /bin/bash

declare -A before after diff #maps

collect_io() {
    declare -n arr=$1
    while read -r filename bytes; do
        pid=${filename//[^0-9]/}
        arr[$pid]=$bytes
    done < <(awk '/read_bytes/ {print FILENAME, $NF}' /proc/[0-9]*/io 2>/dev/null)
}

collect_io before
sleep 60
collect_io after

# for all keys
for pid in ${!before[@]}; do
    if [[ -n ${after[$pid]} ]]; then
        diff[$pid]=$(( after[$pid] - before[$pid] ))
    fi
done

for pid in $(for p in "${!diff[@]}"; do echo $p "${diff[$p]}"; done | sort -nr -k2 | head -n 3 | cut -d' ' -f1); do
    cmd=$(ps -o cmd= -p "$pid" 2>/dev/null);
    [[ -z $cmd ]] && cmd="[terminated]"
    echo "$pid : $cmd : ${diff[$pid]}";
done
