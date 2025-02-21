# Для всех зарегистрированных в данный момент в системе процессов определить среднее время
# непрерывного использования процессора (CPU_burst) и вывести в один файл строки
# ProcessID=PID : Parent_ProcessID=PPID : Average_Running_Time=ART.
#
# Значения PPid взять из файлов status, которые находятся в директориях с названиями,
# соответствующими PID процессов в /proc.
#
# Значения ART получить, разделив значение sum_exec_runtime на nr_switches, 
# взятые из файлов sched в этих же директориях.
#
# Отсортировать эти строки по идентификаторам родительских процессов.
#
#! /bin/bash

> output.txt
for pid in /proc/[0-9]*; do
    pid=${basename pid}

    if [[ -f "/proc/$pid/status" && -f "/proc/$pid/sched" ]]; then
        status=/proc/$pid/status
        sched=/proc/$pid/sched

        # parent process id
        ppid=$(grep "^PPid:" $status | awk '{print $2}')
        # summed execution time
        sum_exec_runtime=$(grep "se.sum_exec_runtime" $sched | awk -F":" '{print $2}')
        # number of switches
        nr_switches=$(grep "nr_switches" $sched | awk -F":" '{print $2}')
        
        ART=$sum_exec_runtime
        if [[ -n $sum_exec_runtime && -n $nr_switches && $nr_switches -ne 0 ]]; then
            art_value=$(echo "scale=4; $sum_exec_runtime / $nr_switches" | bc)
            ART=$(printf "%.4f ms" "$art_value")
        fi

        echo "ProcessID=$pid : Parent_ProcessID=$ppid : Average_Running_Time=$ART" >> output.txt
    fi

done

sort -t "=" -k3,3n output.txt > tmp.txt && mv tmp.txt output.txt
