#!/usr/bin/expect
#NEED VMTOOLS to work
set hPass ""
set IP [lindex $argv 0];
set Name [lindex $argv 1];
set From [lindex $argv 2];
set To [lindex $argv 3];
set prompt "~ #"
spawn ssh -l root $IP
expect {
	"$prompt" {
		send_user "Logged in!\n"	
	}
	"(yes/no)" {
		sleep 1
		send "yes\n"
		exp_continue
	}
	"Password: " {
		send "$hPass\n"
		exp_continue
	}	
}
send "rm -f ipAddress.txt\n"
expect "$prompt"
set i $From;
while {$i <= $To } {
send "vim-cmd vmsvc/getallvms | grep -i $Name$i | cut -d \" \" -f 1 | xargs vim-cmd vmsvc/get.guest | grep ipAddress | sed -n 1p | cut -d \"\\\"\" -f 2 1>>ipAddress.txt\n"
expect "$prompt"
set i [expr $i+1];
}
send "exit\n"
send_user "\n"


set prompt "sftp> "
spawn sftp -C root@$IP
expect {
	"$prompt" {
		send_user "Logged in!\n"	
	}
	"Password: " {
		send "$hPass\n"
		exp_continue
	}	
}
send "get ipAddress.txt temp/ipAddress.txt\n"
expect "$prompt"
send "bye\n"
send_user "\n"
