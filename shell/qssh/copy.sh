#!/usr/bin/expect -f

set scp_command [lindex $argv 0]
set password [lindex $argv 1]

set timeout -1

spawn bash -c "$scp_command"
expect {
    timeout {
        exit
    }
    eof {
        exit
    }
    -re "Are you sure you want to continue connecting (yes/no)?" {
        send "yes\r"
        exp_continue
    }
    -re "password:" {
        send "$password\r"
    }
}
expect eof
