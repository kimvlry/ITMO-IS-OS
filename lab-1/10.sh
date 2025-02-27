#! /bin/bash
# Вывести три наиболее часто встречающихся слова из man 
# по команде bash длиной не менее четырех символов.

man -T ascii bash | tr -cs '[:alpha:]' '\n' | tr '[:upper:]' '[:lower:]' | grep -E '^[a-zA-Z]{4,}$' | sort | uniq -c | sort -rn | head -3

# -c compliment set
# -s squeeze (to skip empty strings)
#
# uniq - removes the duplications of a line BUT duplicated lines must be adjacent
# -c count (adds counter before every unique word)
#
# -r reverse 
# -n numeric
