# В полученном на предыдущем шаге файле после каждой группы записей 
# с одинаковым идентификатором родительского процесса вставить строку вида
# Average_Running_Children_of_ParentID=N is M, где N = PPID, а M – среднее, 
# посчитанное из ART для всех процессов этого родителя.
#
#! /bin/bash

prev_task_output_file="/4/output.txt"
if [ ! -f "$prev_task_output_file" ]; then
    echo "output.txt not found"
    exit 
fi

awk -v Pid_index=1 \
    -v PPid_index=3 \
    -v ART_index=5 '
{
    split($ART_index, splitted, "=")
    ART = splitted[2] + 0
    
    parentID = $PPid_index
    PPid[parentID] += ART
    count[parentID]++

    print $0
}

END {
    for (parent in PPid) {
        average = PPid[parent] / count[parent];
        printf "Average_Running_Children_of_ParentID=%d is %.4f\n", parent, average;
    }
}' 
"$prev_task_output_file" > "tmp.txt"

echo hereeee

if [ -s "tmp.txt" ]; then
    mv "tmp.txt" "$prev_task_output_file"
else
    echo "tmp.txt is empty"
fi
