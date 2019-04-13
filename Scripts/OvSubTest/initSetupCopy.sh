#!/bin/bash
ServerIP=$1
TestVMname=$2
datastore=$3
From=$4
To=$5
./bg/getAllIP.sh $ServerIP $TestVMname $From $To
for vm in $(<./temp/ipAddress.txt);
do 
./bg/SetupCopy.sh $vm &
done
wait
