#!/bin/bash

timestamp=$(date +"%Y-%m-%d_%H:%M:%S")

mkdir $HOME/test 2>/dev/null && {
    echo 'catalog test was created successfully' >> ~/report;
    touch "$HOME/test/$timestamp";
    echo "$timestamp"
};

ping -c 1 www.net_nikogo.ru >/dev/null 2>&1 || echo "$timestamp host is unreachable" >> ~/report

# >2/dev/null: 2 stands for stderr
# 2>&1: redirect stderr contents to stdout (1)
