#!/bin/bash

timestamp=$(date +"%Y-%m-%d_%H:%M:%S")

mkdir /home/valerie/test 2>/dev/null && {
    echo 'catalog test was created successfully' >> /home/valerie/report;
    touch /home/valerie/test/$timestamp;
}

ping -c 1 www.net_nikogo.ru >/dev/null 2>&1 || echo "$timestamp host is unreachable" >> /home/valerie/report

# >2/dev/null: 2 stands for stderr
# 2>&1: redirect stderr contents to the stdout
