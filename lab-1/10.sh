#! /bin/bash
# Вывести три наиболее часто встречающихся слова из man 
# по команде bash длиной не менее четырех символов.

man -T ascii bash | tr -cs '[:alpha:]' '\n' | tr '[:upper:]' '[:lower:]' | grep -E '^[a-zA-Z]{4,}$' | sort | uniq -c | sort -rn | head -3
