#!/bin/bash

#默认信息
logintype="password"
ip="---"
port=22
loginuser="kduser"
loginpass="---"
cmd="---"
active_sudoRoot=false
active_suRoot=false
rootpass="---"
rootcmd="cd ~"
active_jump=false
jump_logintype="password"
jump_ip="---"
jump_port=22
jump_loginuser="kduser"
jump_loginpass="---"
jump_cmd="---"
jump_active_sudoRoot=false
jump_active_suRoot=false
jump_rootpass="---"
jump_rootcmd="cd ~"
driver_type="qssh"

#获取筛选字符串
filter=$1

#获取机器信息
. fetch_machine_info.sh

#输出机器具体的配置信息
# echo "*****************************************************************************"
# echo "机器说明信息: "$info
# echo "-----------------------------------------------------------------------------"
# if [ "$active_jump" == "true" ]; then
#    echo "跳板机IP: "$ip
#    echo "跳板机登陆端口: "$port
#    echo "跳板机登陆用户: "$loginuser
#    echo "-----------------------------------------------------------------------------"
#    echo "机器IP: "$jump_ip
#    echo "登陆端口: "$jump_port
#    echo "登陆用户: "$jump_loginuser
# else
#    echo "机器IP: "$ip
#    echo "登陆端口: "$port
#    echo "登陆用户: "$loginuser
# fi
# echo "*****************************************************************************"

#执行登陆操作
if [ "$driver_type" == "qssh" ]; then
   #调用expect脚本
   "./login.sh" \
   $logintype \
   $ip \
   $port \
   $loginuser \
   $loginpass \
   "$cmd" \
   $active_sudoRoot \
   $active_suRoot \
   $rootpass \
   "$rootcmd" \
   $active_jump \
   $jump_logintype \
   $jump_ip \
   $jump_port \
   $jump_loginuser \
   $jump_loginpass \
   "$jump_cmd" \
   $jump_active_sudoRoot \
   $jump_active_suRoot \
   $jump_rootpass \
   "$jump_rootcmd"
elif [ "$driver_type" == "ssh" ]; then
   ssh -p $port $loginuser@$ip
else
   echo "Unknown driver type!"
fi
