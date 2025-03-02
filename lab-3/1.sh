#!/bin/bash

timestamp=$(date +"%Y-%m-%d_%H:%M:%S")

mkdir $HOME/test 2>/dev/null && {
    echo 'catalog test was created successfully' >> $HOME/report;
    touch "$HOME/test/$timestamp";
};

ping -c 1 www.net_nikogo.ru >/dev/null 2>&1 echo "ping" || echo "write" echo "$timestamp host is unreachable" >> $HOME/report

# >2/dev/null: 2 stands for stderr
# 2>&1: redirect stderr contents to the stdout
