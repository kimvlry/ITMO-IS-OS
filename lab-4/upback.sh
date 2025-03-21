# Скрипт должен скопировать в каталог /home/user/restore/ все файлы из актуального на
# данный момент каталога резервного копирования (имеющего в имени наиболее свежую дату), 
# за исключением файлов с предыдущими версиями.
#
#!/bin/bash

restore_dir="$HOME/restore/"
latest_backup=$(ls -d "$HOME"/Backup-* | sort -V | tail -n 1)

