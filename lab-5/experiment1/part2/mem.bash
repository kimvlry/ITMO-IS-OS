# !/bin/bash

report="report.log"
> $report

counter=0
declare -a arr

trap "kill $top_pid" EXIT SIGINT SIGTERM 

while true;  do
    arr+=(1 2 3 4 5 6 7 8 9 10)
    counter=$((counter + 1))
    if ((counter % 10000 == 0)); then 
        echo "step: $counter, arr size: ${#arr[@]}" >> $report
    fi
done 

