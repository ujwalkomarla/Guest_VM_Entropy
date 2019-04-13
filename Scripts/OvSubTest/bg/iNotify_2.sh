#!/bin/bash
while true;
do
echo "->" >>iNotifyData_2.log
inotifywait --format '%w %T' -e access --timefmt '%s' /dev/random /dev/urandom 1>>iNotifyData_2.log 2>/dev/null;
sudo lsof /dev/random /dev/urandom 2>/dev/null|grep random 1>>iNotifyData_2.log;
done;
