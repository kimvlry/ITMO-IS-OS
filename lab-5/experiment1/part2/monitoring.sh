# !/bin/bash

report="monitoring.log"
> $report

counter=0

monitor() {
    while true; do
        top -b -n 1 | head -n 12 >> "$report"
        sleep 5
    done
}

monitor &
monitor_pid=$!

trap "kill $monitor_pid 2>/dev/null" EXIT

./mem.bash &
pid1=$!
./mem2.bash &
pid2=$!

wait $pid1 $pid2
kill $monitor_pid 2>/dev/null
