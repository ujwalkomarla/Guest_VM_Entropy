#!/bin/sh
#"USAGE: ${0##*/} [From Template Folder] [Clone To] [Start] [End]"
if [ $# -eq 4 ]
then
	workDir="$(pwd)"
	for i in `seq $3 $4`;
	do
		cp -r $1 $2$i
	done
	for i in `seq $3 $4`;
	do
		vID="$(vim-cmd solo/registervm $workDir/$2$i/*vmx)"
		sleep 3
		vim-cmd vmsvc/power.on $vID &
		sleep 10
		returnStats="$(vim-cmd vmsvc/message $vID)"
		msgID="$(echo $returnStats| awk '{print $4}')"
		response=2
		vim-cmd vmsvc/message $vID ${msgID%?} $response	
	done
fi
																					
