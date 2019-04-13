#!/usr/bin/expect
set gPass ""
set gUser ujwal
set IP [lindex $argv 0]

set prompt "sftp> "
spawn sftp -C $gUser@$IP
expect {
	"$prompt" {
		send_user "Logged in!\n"	
	}
	"(yes/no)" {
		sleep 1
		send "yes\n"
		exp_continue
	}
	"password: " {
		send "$gPass\n"
		exp_continue
	}	
}
send "put ./bg/iNotify_1.sh iNotify_1.sh\n"
expect "$prompt"
send "put ./bg/iNotify_2.sh iNotify_2.sh\n"
expect "$prompt"
send "put ./bg/randStap_U.ko randTap.ko\n"
expect "$prompt"
send "put ./bg/randAcc.c randAcc.c\n"
expect "$prompt"
send "put ./bg/seqAcc.c seqAcc.c\n"
expect "$prompt"
send "bye\n"
send_user "\n"


set prompt "~$"
spawn ssh -l $gUser $IP
expect {
	"$prompt" {
		send_user "Logged in!\n"	
	}
	"(yes/no)" {
		sleep 1
		send "yes\n"
		exp_continue
	}
	"password: " {
		send "$gPass\n"
		exp_continue
	}	
}
send "sudo bash\n"
expect {
	"$prompt" {
		send_user "Logged in!\n"	
	}
	"password for $gUser: " {
		send "$gPass\n"
		exp_continue
	}	
}

#send "apt-get install inotify-tools sysstat systemtap-runtime\n"
#expect {
#	"$prompt" {
#		send_user "Logged in!\n"	
#	}
#	"Y/n] " {
#		send "Y\n"
#		exp_continue
#	}	
#}
send "chmod 755 iNotify_1.sh\n"
expect "$prompt"
send "chmod 755 iNotify_2.sh\n"
expect "$prompt"
send "chmod 755 randTap.ko\n"
expect "$prompt"
send "gcc randAcc.c -o randAcc\n"
expect "$prompt"
send "chmod 755 randAcc\n"
expect "$prompt"
send "gcc seqAcc.c -o seqAcc\n"
expect "$prompt"
send "chmod 755 seqAcc\n"
expect "$prompt"
send "exit\n"
send_user "\n"
