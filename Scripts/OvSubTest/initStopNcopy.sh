#!/bin/bash


#run with sudo



ServerIP=$1
TestVMname=$2
datastore=$3
From=$4
To=$5
Test=$6 #1-N,2-D,3-N+D
Directory=$7
gPass=""
./bg/getAllIP.sh $ServerIP $TestVMname $From $To
for vm in $(<./temp/ipAddress.txt);
do 
	./bg/stopNcopy.sh $vm $Test &
	
done
wait
if [ $Test -eq 1 -o $Test -eq 3 ]; then
		pkill ping
fi
i=0
for vm in $(<./temp/ipAddress.txt);
do 
	mkdir ../../Logs/$Directory$i
	#/usr/bin/expect -c "
	#	set timeout 0
	#	spawn scp -r ujwal@$vm:*.log ../../LogFiles/$Directory$i
	#	expect \"password: \"
	#	send \"$gPass\n\"
	#	expect \"$ \"
	#"
	#scp -r ujwal@$vm:*.log ../../Logs/$Directory$i
	./bg/copyLogs.sh $vm $Directory $i &
	i=`expr $i + 1` 
done

