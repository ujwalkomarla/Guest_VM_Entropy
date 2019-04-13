#!/usr/bin/expect
#./clone.sh ServerIP datastore1 templateFolder cloneFolder CountFrom CountTo
set hPass ""
set timeout -1
#set gPass ""
set prompt " # "
set IP [lindex $argv 0];
set datastore [lindex $argv 1];
set template2clone [lindex $argv 2];
set clone2folder [lindex $argv 3];
set iFrom [lindex $argv 4];
set iTo [lindex $argv 5];
spawn ssh -l root $IP
expect {
	"$prompt" {
		send_user "Logged in!\n"	
	}
	"Password: " {
		send "$hPass\n"
		exp_continue
	}	
}
send "cd /vmfs/volumes/$datastore/\n"
expect "$prompt"
send "./clone.sh $template2clone $clone2folder $iFrom $iTo\n"
expect "$prompt"
interact
