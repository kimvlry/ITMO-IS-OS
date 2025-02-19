#! /bin/bash
# Подсчитать общее количество строк в файлах, находящихся 
# в директории /var/log/ и имеющих расширение log.

find /var/log/ -type f -name "*.log" -exec wc -l {} + | awk '{count+=$1} END {print count}'
