#!/bin/bash
while true;
do
	echo -n `date +%s` "#" >>iNotifyData_1.log
	cat /proc/sys/kernel/random/entropy_avail 1>>iNotifyData_1.log
	if [ "$(</proc/sys/kernel/random/entropy_avail)" -gt "2048" ];then
		dd if=/dev/random of=/dev/null bs=1 count=32c
	fi
	sleep 1
done
