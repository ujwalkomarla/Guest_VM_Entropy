#!/bin/bash
ServerIP=$1
Datastore=$2
Virtual=$3
Start=$4
End=$5
i=$Start
while [ $i -le $End ]
do
vmrun -T esx -h https://$ServerIP:443/sdk -u root -p p12345 start "[$Datastore] $Virtual$i/$Virtual.vmx"
i=$[$i+1]
done
