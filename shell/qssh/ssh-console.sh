#!/bin/bash

#定义安装目录(运行必须)
dirPath="/usr/local/lib/my_cmd"

#获取筛选字符串
filter=$1

#函数功能:输入检查函数
# input_check 输入值 最大值
function input_check() {
  if [ $# -lt 2 ]; then
    echo "非法输入!"
    exit
  fi
  if [ "$1" -ge 0 ] 2>/dev/null && [ "$1" -lt "$2" ];then
     echo "输入检查通过! 已选择输入: $1"
  else
     echo "非法输入!"
     exit
  fi
}

#函数功能:计算机器配置文件相对路径,存储在全局变量tempPath
# getPath 绝对路径 相对深度
tempPath=""
function getPath() {
   OLD_IFS="$IFS"
   IFS="/"
   arr=($1)
   IFS="$OLD_IFS"
   leng=${#arr[@]}
   flag=0
   for((i=$2; i>=0; i--));
   do
      if [ "$flag" -eq 0 ]; then
         tempPath=${arr[leng-i-1]}
         flag=1
      else
         tempPath=$tempPath"/"${arr[leng-i-1]}
      fi
   done
}

#函数功能:递归扫描机器信息存储目录,保存机器配置文件相对路径在数据machines中(全局变量j保存递归深度,用于计算相对路径)
# searchMachine 目录 递归深度
machines=()
j=0
function searchMachine() {
   for machine in $(ls $1)
   do
      fileName=$1"/"$machine
      if [ -d "$fileName" ];then
         level=$2
         level=$[level+1]
         searchMachine $fileName $level
      else
         getPath $fileName $2
         if [[ "$tempPath" =~ ^[A-Za-z0-9|/|_|.|-]+\.sh$ ]] && [[ "$tempPath" =~ $filter.*\.sh$ ]]; then
            machines[$j]=$tempPath
            j=$[j+1]
         fi
      fi
   done
}

#确定机器信息来源,默认目录为"~/.ssh-console",可使用环境变量SSH_CONSOLE_SOURCE指定
if [ ! $SSH_CONSOLE_SOURCE ] || [ -z $SSH_CONSOLE_SOURCE ]; then
   if [ ! -d ~/.ssh-console ]; then
      mkdir ~/.ssh-console
   fi
   SSH_CONSOLE_SOURCE=~/.ssh-console
fi
machinesFolder=$SSH_CONSOLE_SOURCE

#打印机器信息来源目录
echo -n -e "\033[24;30;1m机器信息来源: \033[0m"
echo $machinesFolder

#扫描机器信息存储目录
searchMachine $machinesFolder 0

#保存有效机器信息个数
count=${#machines[@]}

#判断是否有可用机器信息(有则继续,无则推出)
if [ $count -le 0 ];then
   echo "未发现可用机器信息!"
   exit
fi

#输出机器配置信息文件,以供用户选择
for((index=0; index<$count; index++))
do
   echo $index\) ${machines[index]}
done

#获取用户输入(机器信息配置文件编号)
echo -n -e "\033[24;30;1m请选择登陆机器: \033[0m"
read choice
input_check $choice $count
echo -e "\033[24;30;1m登陆 ${machines[choice]} ...\033[0m"

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

#加载机器信息配置文件
. $machinesFolder"/"${machines[choice]}

#输出机器具体的配置信息
echo "*****************************************************************************"
echo "机器说明信息: "$info
echo "-----------------------------------------------------------------------------"
if [ "$active_jump" == "true" ]; then
   echo "跳板机IP: "$ip
   echo "跳板机登陆端口: "$port
   echo "跳板机登陆用户: "$loginuser
   echo "-----------------------------------------------------------------------------"
   echo "机器IP: "$jump_ip
   echo "登陆端口: "$jump_port
   echo "登陆用户: "$jump_loginuser
else
   echo "机器IP: "$ip
   echo "登陆端口: "$port
   echo "登陆用户: "$loginuser
fi
echo "*****************************************************************************"

#执行登陆操作
if [ "$driver_type" == "qssh" ]; then
   #调用expect脚本
   $dirPath"/login.sh" \
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
