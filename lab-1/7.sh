#! /bin/bash
# Создать файл emails.lst, в который вывести через запятую все адреса электронной почты,
# встречающиеся во всех файлах директории /etc.

regex="[[:alnum:]._]+@[[:alnum:]._]+\.[[:alnum:]]{2,}"
grep -rIEoh "$regex" /etc | sort -u | tr '\n' ',' > email.lst

# -r for recursive search in /etc
# -E extended regex syntax
#
# sed goes line by line and tr reads char by char
#
# s/../.. - sed substitution ($ stand for end of the line)
