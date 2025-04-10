import re
from collections import defaultdict
import matplotlib.pyplot as plt

pid1 = "4025"
pid2 = "3203"
pid3 = "3205"

def parse_part1(filename):
    mem_total = []
    mem_free = []
    mem_used = []
    mem_buff_cache = []

    swap_total = []
    swap_free = []
    swap_used = []
    swap_avail_mem = []

    bash_pid = []
    bash_user = []
    bash_pr = []
    bash_ni = []
    bash_virt = []
    bash_res = []
    bash_shr = []
    bash_state = []
    bash_cpu_percent = []
    bash_mem_percent = []
    bash_time = []
    bash_command = []

    with open(filename, "r") as file:
        lines = file.readlines()

    for line in lines:
        line = line.strip()

        if line.startswith("MiB Mem"):
            values = [float(x) for x in re.findall(r"\d+(?:\.\d+)?", line)]
            mem_total.append(values[0])
            mem_free.append(values[1])
            mem_used.append(values[2])
            mem_buff_cache.append(values[3])

        elif line.startswith("MiB Swap"):
            values = [float(x) for x in re.findall(r"\d+(?:\.\d+)?", line)]
            swap_total.append(values[0])
            swap_free.append(values[1])
            swap_used.append(values[2])
            swap_avail_mem.append(values[3])

        elif re.match(fr"\s*{pid1}\s+\w+", line):
            fields = line.split()
            if len(fields) >= 12 and fields[10] and fields[11] == "bash":
                bash_pid.append(int(fields[0]))
                bash_user.append(fields[1])
                bash_pr.append(fields[2])
                bash_ni.append(fields[3])
                bash_virt.append(fields[4])
                bash_res.append(fields[5])
                bash_shr.append(fields[6])
                bash_state.append(fields[7])
                bash_cpu_percent.append(float(fields[8]))
                bash_mem_percent.append(float(fields[9]))
                bash_time.append(fields[10])
                bash_command.append(fields[11])

    return {
        "mem_total": mem_total,
        "mem_free": mem_free,
        "mem_used": mem_used,
        "mem_buff_cache": mem_buff_cache,
        "swap_total": swap_total,
        "swap_free": swap_free,
        "swap_used": swap_used,
        "swap_avail_mem": swap_avail_mem,
        "bash_pid": bash_pid,
        "bash_user": bash_user,
        "bash_pr": bash_pr,
        "bash_ni": bash_ni,
        "bash_virt": bash_virt,
        "bash_res": bash_res,
        "bash_shr": bash_shr,
        "bash_state": bash_state,
        "bash_cpu_percent": bash_cpu_percent,
        "bash_mem_percent": bash_mem_percent,
        "bash_time": bash_time,
        "bash_command": bash_command,
    }


def parse_part2(filename):
    mem_total, mem_free, mem_used, mem_buff_cache = [], [], [], []
    swap_total, swap_free, swap_used, swap_avail_mem = [], [], [], []

    processes = {
        f"{pid2}": defaultdict(list),
        f"{pid3}": defaultdict(list),
    }

    with open(filename, "r") as file:
        lines = file.readlines()

    for line in lines:
        line = line.strip()

        if line.startswith("MiB Mem"):
            values = [float(x) for x in re.findall(r"\d+(?:\.\d+)?", line)]
            mem_total.append(values[0])
            mem_free.append(values[1])
            mem_used.append(values[2])
            mem_buff_cache.append(values[3])

        elif line.startswith("MiB Swap"):
            values = [float(x) for x in re.findall(r"\d+(?:\.\d+)?", line)]
            swap_total.append(values[0])
            swap_free.append(values[1])
            swap_used.append(values[2])
            swap_avail_mem.append(values[3])

        match = re.match(fr"\s*({pid2}|{pid3})\s+(\w+)", line)
        if match:
            pid = match.group(1)
            fields = line.split()
            if len(fields) >= 12 and fields[11] == "bash":
                p = processes[pid]
                p["pid"].append(int(fields[0]))
                p["user"].append(fields[1])
                p["pr"].append(fields[2])
                p["ni"].append(fields[3])
                p["virt"].append(fields[4])
                p["res"].append(fields[5])
                p["shr"].append(fields[6])
                p["state"].append(fields[7])
                p["cpu_percent"].append(float(fields[8]))
                p["mem_percent"].append(float(fields[9]))
                p["time"].append(fields[10])
                p["command"].append(fields[11])

    return {
        "mem_total": mem_total,
        "mem_free": mem_free,
        "mem_used": mem_used,
        "mem_buff_cache": mem_buff_cache,
        "swap_total": swap_total,
        "swap_free": swap_free,
        "swap_used": swap_used,
        "swap_avail_mem": swap_avail_mem,
        f"bash_{pid2}": processes[f"{pid2}"],
        f"bash_{pid3}": processes[f"{pid3}"]
    }


def plot_memory_swap(data, title):
    timestamps = list(range(len(data["mem_total"])))

    mem_colors = {
        "mem_total": "#1f77b4",
        "mem_free": "#4fa3d1",
        "mem_used": "#8ec4e6",
        "mem_buff_cache": "#c6e2f5"
    }

    swap_colors = {
        "swap_total": "#d62728",
        "swap_free": "#e57373",
        "swap_used": "#ef9a9a",
        "swap_avail_mem": "#f4cccc"
    }

    plt.figure(figsize=(14, 6))

    for key, color in mem_colors.items():
        plt.plot(timestamps, data[key], label=key, color=color)

    for key, color in swap_colors.items():
        plt.plot(timestamps, data[key], label=key, color=color)

    plt.title(f"{title} - MiB Mem & MiB Swap Usage")
    plt.xlabel("Time (samples)")
    plt.ylabel("Memory (MiB)")
    plt.legend(loc="upper right")
    plt.grid(True)
    plt.tight_layout()
    plt.savefig(f"plots/{title}_common.png")


def parse_kb(value: str) -> int:
    value = value.lower()
    if value.endswith('g'):
        return int(float(value[:-1]) * 1024 * 1024)
    elif value.endswith('m'):
        return int(float(value[:-1]) * 1024)
    elif value.endswith('k'):
        return int(float(value[:-1]))
    else:
        return int(float(value))


def plot_process_metrics_part1(data):
    time_points = list(range(len(data["bash_cpu_percent"])))

    # --- Chart 1: Memory usage in KB ---
    plt.figure(figsize=(10, 5))
    plt.plot(time_points, [parse_kb(x) for x in data["bash_virt"]], label="VIRT (KB)", color="navy")
    plt.plot(time_points, [parse_kb(x) for x in data["bash_res"]], label="RES (KB)", color="darkgreen")
    plt.plot(time_points, [parse_kb(x) for x in data["bash_shr"]], label="SHR (KB)", color="teal")
    plt.title("Memory usage of process (PID 4025)")
    plt.xlabel("Time points")
    plt.ylabel("Memory (KB)")
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.savefig("plots/part1_memo.png")

    # --- Chart 2: CPU and MEM usage (%) + PR and NI values ---
    plt.figure(figsize=(10, 5))
    plt.plot(time_points, data["bash_cpu_percent"], label="CPU (%)", color="red")
    plt.plot(time_points, data["bash_mem_percent"], label="MEM (%)", color="orange")
    plt.plot(time_points, [int(x) for x in data["bash_pr"]], label="PR (priority)", linestyle="--", color="blue")
    plt.plot(time_points, [int(x) for x in data["bash_ni"]], label="NI (nice)", linestyle="--", color="purple")
    plt.title("CPU, memory usage and priority of process (PID 4025)")
    plt.xlabel("Time (s)")
    plt.ylabel("Percentage / Priority")
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.savefig("plots/part1_pr_ni_common.png")


def safe_plot(x, y, *args, **kwargs):
    n = min(len(x), len(y))
    return plt.plot(x[:n], y[:n], *args, **kwargs)

def parse_time_string(t):
    try:
        parts = t.split(":")
        minutes = int(parts[0])
        seconds = float(parts[1])
        return round(minutes * 60 + seconds, 2)
    except Exception:
        return 0


def plot_process_metrics_part2(data):
    time_points2 = [parse_time_string(t) for t in data[f"bash_{pid2}"]["time"]]
    time_points3 = [parse_time_string(t) for t in data[f"bash_{pid3}"]["time"]]

    # --- CPU & MEM Usage (%)
    plt.figure(figsize=(12, 6))
    safe_plot(time_points2, data[f"bash_{pid2}"]["cpu_percent"], label=f"{pid2} CPU%", color="blue")
    safe_plot(time_points2, data[f"bash_{pid2}"]["mem_percent"], label=f"{pid2} MEM%", linestyle="--", color="blue")

    safe_plot(time_points3, data[f"bash_{pid3}"]["cpu_percent"], label=f"{pid3} CPU%", color="red")
    safe_plot(time_points3, data[f"bash_{pid3}"]["mem_percent"], label=f"{pid3} MEM%", linestyle="--", color="red")

    plt.title(f"CPU% and MEM% usage for bash (PID {pid2} vs {pid3})")
    plt.xlabel("Time")
    plt.ylabel("Percentage")
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.savefig("plots/part2_common.png")

    # --- Memory usage: VIRT / RES / SHR
    plt.figure(figsize=(12, 6))
    for pid, color, time_points_pid in [(f"{pid2}", "blue", time_points2), (f"{pid3}", "red", time_points3)]:
        safe_plot(time_points_pid, [parse_kb(v) for v in data[f"bash_{pid}"]["virt"]],
                  label=f"{pid} VIRT", color=color, linestyle="-")
        safe_plot(time_points_pid, [parse_kb(v) for v in data[f"bash_{pid}"]["res"]],
                  label=f"{pid} RES", color=color, linestyle="--")
        safe_plot(time_points_pid, [parse_kb(v) for v in data[f"bash_{pid}"]["shr"]],
                  label=f"{pid} SHR", color=color, linestyle=":")

    plt.title(f"Memory usage (VIRT / RES / SHR) for bash (PID {pid2} vs {pid3})")
    plt.xlabel("Time (s)")
    plt.ylabel("Memory (KB)")
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.savefig("plots/part2_memo.png")

    # --- Priority: PR and NI
    plt.figure(figsize=(12, 4))
    for pid, color, time_points_pid in [(f"{pid2}", "blue", time_points2), (f"{pid3}", "red", time_points3)]:
        pr_values = [int(p) if p != "?" else 0 for p in data[f"bash_{pid}"]["pr"]]
        ni_values = [int(n) if n != "?" else 0 for n in data[f"bash_{pid}"]["ni"]]

        safe_plot(time_points_pid, pr_values, label=f"{pid} PR", color=color, linestyle="-")
        safe_plot(time_points_pid, ni_values, label=f"{pid} NI", color=color, linestyle="--")

    plt.title(f"Process priority (PR and NI) for bash (PID {pid2} vs {pid3})")
    plt.xlabel("Time")
    plt.ylabel("Value")
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.savefig("plots/part2_pr_ni.png")




data1 = parse_part1("../part1/top.log")
data2 = parse_part2("monitoring.log")

plot_memory_swap(data1, "part1")
plot_memory_swap(data2, "part2")
plot_process_metrics_part1(data1)
plot_process_metrics_part2(data2)