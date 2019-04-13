#!/usr/bin/expect -f
set gPass ""
set gUser ujwal
set IP [lindex $argv 0]
set DIR [lindex $argv 1]
set i [lindex $argv 2]
spawn scp -r "$gUser@$IP:*.log" ../../Logs/$DIR$i
#######################
expect {
  -re ".*es.*o.*" {
    exp_send "yes\n"
    exp_continue
  }
  -re ".*sword.*" {
    exp_send "$gPass\n"
  }
}

interact
