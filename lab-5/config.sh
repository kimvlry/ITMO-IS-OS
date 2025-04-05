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

total_mem=$(free -h | awk '/^Mem/ {print $2}')
total_swap=$(free -h | awk '/^Swap/ {print $2}')
page_size=$(getconf PAGE_SIZE)
free_mem=$(free -h | awk '/^Mem/ {print $4}')
free_swap=$(free -h | awk '/^Swap/ {print $4}')

echo "total_mem : $total_mem" > $config
echo "total_swap : $total_swap" >> $config
echo "page_size : $page_size" >> $config
echo "free_mem : $free_mem" >> $config
echo "free_swap : $free_swap" >> $config

echo "configuration info written to $config"
