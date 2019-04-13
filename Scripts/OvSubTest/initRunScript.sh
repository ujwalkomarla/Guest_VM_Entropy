#!/bin/bash



####run with sudo


ServerIP=$1
TestVMname=$2
datastore=$3
From=$4
To=$5
Test=$6 #1-N,2-D,3-N+D
pingTo=10.20.68.78
#$(ifconfig eth0 | grep "inet\ addr" | cut -d: -f2 | cut -d" " -f1)
./bg/getAllIP.sh $ServerIP $TestVMname $From $To
for vm in $(<./temp/ipAddress.txt);
do 
	./bg/runScript.sh $vm $Test $pingTo &
done

for vm in $(<./temp/ipAddress.txt);
do 
	if [ $Test -eq 1 -o $Test -eq 3 ]; then
	sudo ping -q -s 64000 -i .001 $vm  >/dev/null 2>&1 &
	fi
done
