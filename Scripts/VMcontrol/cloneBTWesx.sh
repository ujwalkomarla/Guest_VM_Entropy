#!/usr/bin/expect
set timeout -1
set Server1 [lindex $argv 0]
set Server2 [lindex $argv 1]
send "scp -r root@$Server1:/vmfs/volumes/datastore1/Template Template_Ubuntu"
expect "Password:"
send "ca\$hcow"
expect "$"
send "scp -r Template_Ubuntu root@$Server2:/vmfs/volumes/datastore1/Template "
expect "Password:"
send "ca\$hcow"
expect "$"
send "scp -r UbuntuScripts/clone.sh root@$Server2:/vmfs/volumes/datastore1/Template "
expect "Password:"
send "ca\$hcow"
expect "$"

