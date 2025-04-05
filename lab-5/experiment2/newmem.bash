# !/bin/bash

N=$1
if [ -z "$1" ]; then
    echo "pass N"
    exit
fi

report="report.log"
> $report

counter=0
declare -a arr

while true;  do
    if [[ ${#arr[@]} > $N ]]; then
        echo "arr size reached $N"
        exit
    fi
    arr+=(1 2 3 4 5 6 7 8 9 10)
    counter=$((counter + 1))
    if ((counter % 10000 == 0)); then 
        echo "step: $counter, arr size: ${#arr[@]}" >> $report
    fi
done 

