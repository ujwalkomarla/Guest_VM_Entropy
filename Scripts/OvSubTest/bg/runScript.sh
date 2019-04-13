#!/usr/bin/expect
set gPass ""
set gUser ujwal
set IP [lindex $argv 0]
set testID [lindex $argv 1]
set pingTo [lindex $argv 2]
# grab the TEST ID
#send_user "TEST 1-N,2-D,3-N+D\n"
#expect_user -re "(\[1-3]+)\n"
#set test $expect_out(1,string)

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
send "rm -f iNotifyData_1.log\n"
expect "$prompt"
send "rm -f iNotifyData_2.log\n"
expect "$prompt"
send "rm -f randStapData.log\n"
expect "$prompt"
send "nohup staprun randTap.ko -D -o randStapData.log -w 2>/dev/null\n"
expect "$prompt"
send "nohup ./iNotify_1.sh 2>/dev/null &\n"
expect "$prompt"
send "nohup ./iNotify_2.sh 2>/dev/null &\n"
expect "$prompt"
send "cat /proc/interrupts >IRQ.log 2>/dev/null\n"
expect "$prompt"
send "nohup sar -u 60 > CPU.log 2>/dev/null &\n"
expect "$prompt"
send "nohup sar -n DEV 60 > NW.log 2>/dev/null &\n"
expect "$prompt"
send "nohup sar -r 60 > Mem.log 2>/dev/null &\n"
expect "$prompt"
send "nohup sar -d -p 60 > Disk.log 2>/dev/null &\n"
expect "$prompt"

if {$testID == "1"} {
send "nohup sudo ping -q -s 65000 -i .001 $pingTo  >/dev/null 2>&1 &\n"
expect "$prompt"
}
if {$testID == "2"} {
send "nohup ./randAcc /dev/sda 2>/dev/null &\n"
expect "$prompt"
}
if {$testID == "3"} {
send "nohup ./randAcc /dev/sda 2>/dev/null &\n"
expect "$prompt"
send "nohup sudo ping -q -s 65000 -i .001 $pingTo  >/dev/null 2>&1 &\n"
expect "$prompt"
}

send "exit\n"
send_user "\n"
