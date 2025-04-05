#!/bin/bash

output="parsed_logs.txt"
> "$output"

extract_values() {
    log_file=$1
    tag=$2
    echo "# $tag" >> "$output"

    mem_total=()
    mem_free=()
    mem_used=()
    mem_buff=()
    swap_total=()
    swap_free=()
    swap_used=()
    proc_cpu=()
    proc_mem=()
    proc_virt=()
    proc_res=()
    proc_names=()
    top_proc_names=()

    while IFS= read -r line; do
        # common
        if [[ "$line" =~ ^MiB\ Mem ]]; then
            read _ _ total _ free _ used _ buff <<<"$line"
            mem_total+=("${total/,/.}")
            mem_free+=("${free/,/.}")
            mem_used+=("${used/,/.}")
            mem_buff+=("${buff/,/.}")
        fi
        if [[ "$line" =~ ^MiB\ Swap ]]; then
            read _ _ total _ free _ used <<<"$line"
            swap_total+=("${total/,/.}")
            swap_free+=("${free/,/.}")
            swap_used+=("${used/,/.}")
        fi

        # procs
        if [[ "$line" =~ bash ]]; then
            read -a parts <<< "$line"
            proc_cpu+=("${parts[8]}")
            proc_mem+=("${parts[9]}")
            proc_virt+=("${parts[4]}")
            proc_res+=("${parts[5]}")
            proc_names+=("\"${parts[11]}\"")
        fi

        if [[ "$line" =~ ^[[:space:]]*[0-9]+ ]]; then
            read -a p <<< "$line"
            top_proc_names+=("\"${p[11]}\"")
        fi
    done < "$log_file"

    echo "mem_total_$tag = [${mem_total[*]}]" >> "$output"
    echo "mem_free_$tag = [${mem_free[*]}]" >> "$output"
    echo "mem_used_$tag = [${mem_used[*]}]" >> "$output"
    echo "mem_buff_$tag = [${mem_buff[*]}]" >> "$output"
    echo "swap_total_$tag = [${swap_total[*]}]" >> "$output"
    echo "swap_free_$tag = [${swap_free[*]}]" >> "$output"
    echo "swap_used_$tag = [${swap_used[*]}]" >> "$output"
    echo "proc_virt_$tag = [${proc_virt[*]}]" >> "$output"
    echo "proc_res_$tag = [${proc_res[*]}]" >> "$output"
    echo "proc_cpu_$tag = [${proc_cpu[*]}]" >> "$output"
    echo "proc_mem_$tag = [${proc_mem[*]}]" >> "$output"
    echo "proc_names_$tag = [${proc_names[*]}]" >> "$output"
    echo "top_proc_names_$tag = [${top_proc_names[*]}]" >> "$output"
    echo "" >> "$output"
}

extract_values "part1/top.log" "part1"
extract_values "part2/monitoring.log" "part2"
