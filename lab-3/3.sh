# Задайте запуск скрипта из пункта 1 в каждую пятую минут каждого часа в день недели, 
# в который вы будете выполнять работу.

( crontab -l; echo "5 * * * SUN /home/valerie/ITMO-IS-OS/lab-3/1.sh" ) | crontab
