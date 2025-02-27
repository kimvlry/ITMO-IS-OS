#! /bin/bash
# Создать файл emails.lst, в который вывести через запятую все адреса электронной почты,
# встречающиеся во всех файлах директории /etc.

regex="[a-zA-Z0-9._-]+@[a-z0-9_-]+\.[a-z]{2,}"
grep -roE "$regex" /etc | uniq | tr '\n' ',' | sed 's/,$/\n/' > email.lst

# -r for recursive search in /etc
# -o return only occurrences and not the whole line
# -E extended regex syntax
#
# sed goes line by line and tr reads char by char
#
# s/../.. - sed substitution ($ stand for end of the line)
