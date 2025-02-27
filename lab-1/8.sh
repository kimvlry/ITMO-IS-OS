#! /bin/bash
# Вывести список пользователей системы с указанием их UID, отсортировав по UID. 
# Сведения о пользователей хранятся в файле /etc/passwd. В каждой строке этого файла 
# первое поле – имя пользователя, третье поле – UID. Разделитель – двоеточие.

cut -d ':' -f1,3 --output-delimiter=' ' /etc/passwd | sort -k2 -n 

# -d delimiter to cut on
# -f1,3 field 1 and 3
# -k2 sorting field
# -n numerical sort
