# !/bin/bash

N="$1"
K="$2"
report="$3"

if [ -z "$N" ] || [ -z "$K" ] || [ -z "$report" ]; then
    echo "pass N, K, report file name"
    exit 
fi

dmesg -C
for ((i=1; i<=$K; ++i)); do
    ./newmem.bash $N & 
    pid=$!
    wait $pid
done

>$report
echo -e "N = $N, K = $K\n" > $report
dmesg | grep -iE "oom|out of memory" >> $report

