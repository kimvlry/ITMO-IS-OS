# Написать скрипт, определяющий три процесса, которые за 1 минуту, прошедшую с момента 
# запуска скрипта, считали максимальное количество байт из устройства хранения данных. 
# Скрипт должен выводить PID, строки запуска и объем считанных данных, разделенные двоеточием.
#
#! /bin/bash

# declaring associative arrays (PID:bytes)
declare -A before after diff 

collect_io() {
    # declaring a link to the array passed to the function (copying array would be: declare n=("${!1[@]}"))
    declare -n arr=$1 
    while read -r filename bytes; do
        # delete non-numeric symbols
        pid=${filename//[^0-9]/} 
        if [[ -d "/proc/$pid" ]]; then
            arr[$pid]=$bytes
        fi 
    # NF is the last value in string (read_bytes) 
    done < <(awk '/read_bytes/ {print FILENAME, $NF}' /proc/[0-9]*/io 2>/dev/null)
}

collect_io before
sleep 60
collect_io after

for pid in "${!before[@]}"; do
    # if process was terminated between checks, the after value is 0 (:-0)
    diff["$pid"]=$(( ${after[$pid]:-0} - ${before[$pid]} ))
done

if [[ ${#diff[@]} -eq 0 ]]; then
    echo "No processes with disk read activity detected!"
    exit 0
fi

# {map[@]} - gets all values
# {!map[@]} - gets all keys

# inner: for all keys (PIDs): echo values (bytes) and sort 'em, increasing
# outer: takes top 3 PIDs (`cut -d' '-f1`) of inner loop
for pid in $(for p in "${!diff[@]}"; do echo $p "${diff[$p]}"; done | sort -rn -k2 | head -n 3 | cut -d' ' -f1); do
    cmd=$(ps -o cmd= -p "$pid" 2>/dev/null);
    [[ -z $cmd ]] && cmd="[terminated]"
    echo "$pid : $cmd : ${diff[$pid]}";
done
