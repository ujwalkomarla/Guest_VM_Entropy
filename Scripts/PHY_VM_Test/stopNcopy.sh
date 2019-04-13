#!/usr/bin/expect
set gPass ""
set gUser ujwal
set IP [lindex $argv 0]
set testID [lindex $argv 1]
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
set prompt "~#"
expect {
	"$prompt" {
		send_user "Logged in!\n"	
	}
	"password for $gUser: " {
		send "$gPass\n"
		exp_continue
	}	
}
send "pkill iNotify_1.sh\n"
expect "$prompt"
send "pkill iNotify_2.sh\n"
expect "$prompt"
send "pkill sar\n"
expect "$prompt"
send "cat /proc/interrupts >IRQ_1.log 2>/dev/null\n"
expect "$prompt"
#send "rmmod randTap.ko\n"
#expect "$prompt"
if {$testID == "1"} {
send "pkill ping\n"
expect "$prompt"
}
if {$testID == "2"} {
send "pkill randAcc\n"
expect "$prompt"
}
if {$testID == "3"} {
send "pkill randAcc\n"
expect "$prompt"
send "pkill ping\n"
expect "$prompt"
}
send "exit\n"
send_user "\n"

