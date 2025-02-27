# Используя псевдофайловую систему /proc найти процесс, которому выделено 
# больше всего оперативной памяти. Сравнить результат с выводом команды top.
#
#! /bin/bash

max_memo=-1
max_memo_process_name=""
max_memo_processID=-1

for pid in /proc/[0-9]*; do
    pid=${pid#/proc/}

    if [[ -f "/proc/$pid/status" ]]; then
        status=/proc/$pid/status
        name=$(grep "^Name:" $status | awk '{print $2}')
        memo=$(grep "^VmRSS:" $status | awk '{print $2}')

        if [[ -n $memo && $memo -gt $max_memo ]]; then
            max_memo=$memo
            max_memo_process_name=$name
            max_memo_processID=$pid
        fi
    fi
done

echo "according to /proc:"
echo -e "$max_memo_processID $max_memo_process_name $max_memo kB\n"

echo "according to top command:"
top -b -o %MEM | head -n 8 | tail -n 2
#
# -b batch mode (no interactive display)

