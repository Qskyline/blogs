#!/usr/bin/expect -f

set loginstyle [lindex $argv 0]
set ipaddr [lindex $argv 1]
set port [lindex $argv 2]
set loginuser [lindex $argv 3]
set loginpass [lindex $argv 4]
set cmd [lindex $argv 5]
set active_sudoRoot [lindex $argv 6]
set active_suRoot [lindex $argv 7]
set rootpass [lindex $argv 8]
set root_cmd [lindex $argv 9]

set active_jump [lindex $argv 10]

set jump_loginstyle [lindex $argv 11]
set jump_ipaddr [lindex $argv 12]
set jump_port [lindex $argv 13]
set jump_loginuser [lindex $argv 14]
set jump_loginpass [lindex $argv 15]
set jump_cmd [lindex $argv 16]
set jump_active_sudoRoot [lindex $argv 17]
set jump_active_suRoot [lindex $argv 18]
set jump_rootpass [lindex $argv 19]
set jump_root_cmd [lindex $argv 20]

if {$argc < 5} {
   send_user "usage: $argv0 <param1> <param2> <param3> <param4> <param5> ...\n"
   exit
}

set timeout 3600
set root_flag "false"
set cmd_prompt "]#|~]|]\\$"

if { $loginstyle == "password" } {
   spawn ssh -p $port $loginuser@$ipaddr
} elseif { $loginstyle == "privatekey" } {
   spawn ssh -p $port -i $loginpass $loginuser@$ipaddr
} else {
   send_user "Error:Unknow logintype: $loginstyle\n"
   exit
}

expect {
   -re "Permission denied, please try again." {
      send_user "Error:Permission denied.\n"
      exit
   }
   -re "Connection refused" {
      send_user "Error:Connection refused.\n"
      exit
   }
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
      send "$loginpass\r"
      exp_continue
   }
   -re $cmd_prompt {
      if { $cmd != "---" } {
         send "$cmd\r"
      } else {
         send "\r"
      }
   }
}

if { $active_sudoRoot == "true" } {
   expect {
      -re $cmd_prompt {
         send "sudo su -\r"
      }
   }
   expect {
      -re "password for" {
         send "$loginpass\r"
         set root_flag "true"
         exp_continue
      }
      -re "]#" {
         if { $root_cmd != "---" } {
            send "$root_cmd\r"
         }
      }
      -re "is not in the sudoers file." {
         set root_flag "false"
      }
   }
}

if { ($active_suRoot == "true") && ($root_flag == "false") } {
   expect {
      -re $cmd_prompt {
         send "su - root\r"
      }
   }
   expect {
      -re "assword" {
         send "$rootpass\r"
         set root_flag "true"
         exp_continue
      }
      -re "]#" {
         if { $root_cmd != "---" } {
            send "$root_cmd\r"
         }
      }
      -re "Authentication failure" {
         set root_flag "false"
      }
   }
}

if { $active_jump == "true" } {
   if { $jump_loginstyle == "password" } {
      set ssh_cmd "ssh -p $jump_port $jump_loginuser@$jump_ipaddr\r"
   } elseif { $jump_loginstyle == "privatekey" } {
      set ssh_cmd "ssh -p $jump_port -i $jump_loginpass $jump_loginuser@$jump_ipaddr\r"
   } else {
      send_user "Error:Unknow logintype: $jump_loginstyle\n"
      exit
   }

   expect {
      -re $cmd_prompt {
         send $ssh_cmd
      }
   }
   expect {
      -re "Permission denied, please try again." {
         send_user "Error:Permission denied.\n"
         exit
      }
      -re "Connection refused" {
         send_user "Error:Connection refused.\n"
         exit
      }
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
         send "$jump_loginpass\r"
         exp_continue
      }
      -re $cmd_prompt {
         if { $jump_cmd != "---" } {
            send "$jump_cmd\r"
         } else {
            send "\r"
         }
      }
   }

   set root_flag "false"
   if { $jump_active_sudoRoot == "true" } {
      expect {
         -re $cmd_prompt {
            send "sudo su -\r"
         }
      }
      expect {
         -re "password for" {
            send "$jump_loginpass\r"
            set root_flag "true"
            exp_continue
         }
         -re "]#" {
            if { $jump_root_cmd != "---" } {
               send "$jump_root_cmd\r"
            }
         }
         -re "is not in the sudoers file." {
            set root_flag "false"
         }
      }
   }

   if { ($jump_active_suRoot == "true") && ($root_flag == "false") } {
      expect {
         -re $cmd_prompt {
            send "su - root\r"
         }
      }
      expect {
         -re "assword" {
            send "$jump_rootpass\r"
            set root_flag "true"
            exp_continue
         }
         -re "]#" {
            if { $jump_root_cmd != "---" } {
               send "$jump_root_cmd\r"
            }
         }
         -re "Authentication failure" {
            set root_flag "false"
         }
      }
   }
}

interact
