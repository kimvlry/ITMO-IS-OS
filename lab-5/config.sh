# Зафиксируйте в отчете данные о текущей конфигурации операционной системы в аспекте управления памятью:
# Общий объем оперативной памяти.
# Объем раздела подкачки.
# Размер страницы виртуальной памяти.
# Объем свободной физической памяти в ненагруженной системе.
# Объем свободного пространства в разделе подкачки в ненагруженной системе.
#
# !/bin/bash

config="config.txt"
> "$config"

free -h | grep "Mem" >> "$config" 
free -h | grep "Swap" >> "$config" 
getconf PAGE_SIZE >>  "$config" 
grep MemAviable /proc/meminfo >>  "$config" 
grep SwapFree /proc/meminfo >>  "$config" 

echo "configuration info written to $config"
