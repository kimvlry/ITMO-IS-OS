# !/bin/bash

report="monitoring.log"
> $report

counter=0

monitor() {
    while true; do
        top -b -n 1 | head -n 12 >> "$report"
        sleep 1
    done
}

monitor &
monitor_pid=$!

trap "kill $monitor_pid" EXIT

./mem.bash &
pid1=$!
./mem2.bash &
pid2=$!

