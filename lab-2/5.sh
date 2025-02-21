# В полученном на предыдущем шаге файле после каждой группы записей 
# с одинаковым идентификатором родительского процесса вставить строку вида
# Average_Running_Children_of_ParentID=N is M, где N = PPID, а M – среднее, 
# посчитанное из ART для всех процессов этого родителя.
#
#! /bin/bash

prev_task_output_file="4/output.txt"
if [ ! -f "$prev_task_output_file" ]; then
    echo "output.txt not found"
    exit 
fi

awk -v Pid_column_index=1 \
    -v PPid_column_index=3 \
    -v ART_column_index=5 '
{
    split($(ART_column_index), splitted, "=")
    ART = splitted[2] + 0
    
    parentID = $(PPid_column_index)

    if (prev_parentID != "" && prev_parentID != parentID) {
        average = PPid[prev_parentID] / count[prev_parentID]
        print "Average_Running_Children_of_ParentID=" prev_parentID, "is", average "\n"
    }

    PPid[parentID] += ART
    count[parentID]++

    print $0
    prev_parentID = parentID
}

END {
    if (prev_parentID != "") {
        average = PPid[prev_parentID] / count[prev_parentID];
        print "Average_Running_Children_of_ParentID=" prev_parentID, "is", average "\n"
    }
}' "$prev_task_output_file" > "tmp.txt"

if [ -s "tmp.txt" ]; then
    mv "tmp.txt" "$prev_task_output_file"
else
    echo "tmp.txt is empty"
fi
