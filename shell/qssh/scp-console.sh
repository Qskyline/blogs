#!/bin/bash

#定义安装目录(运行必须)
dirPath="/usr/local/lib/my_cmd"

#默认信息
logintype="password"
ip="---"
port=22
loginuser="kduser"
loginpass="---"

#参数信息
param1_host=
param1_path=
param2_host=
param2_path=

#默认下载路径
default_local_path=~/Downloads
default_remote_path="~"

#参数处理
if [ -n "$1" ] && [ -z "$2" ]; then
    if [[ "$1" =~ ^@.* ]]; then
        temp=${1:1}
    else
        temp=$1
    fi
    OLD_IFS="$IFS"
    IFS=":"
    arr=($temp)
    IFS="$OLD_IFS"
    param1_host=${arr[0]}
    param1_path=${arr[1]}
elif [ -n "$1" ] && [ -n "$2" ]; then
    if [[ "$1" =~ ^@.* ]]; then
        temp=${1:1}
        OLD_IFS="$IFS"
        IFS=":"
        arr=($temp)
        IFS="$OLD_IFS"
        param1_host=${arr[0]}
        param1_path=${arr[1]}
    else
        param1_path=$1
    fi
    if [[ "$2" =~ ^@.* ]]; then
        temp=${2:1}
        OLD_IFS="$IFS"
        IFS=":"
        arr=($temp)
        IFS="$OLD_IFS"
        param2_host=${arr[0]}
        param2_path=${arr[1]}
    else
        param2_path=$2
    fi
fi

#补充参数信息
if [ -z "$param1_host" ] && [ -z "$param2_host" ]; then
    echo "未检测到远端地址!"
    exit
elif [ -n "$param1_host" ] && [ -z "$param2_host" ]; then
    filter=$param1_host
    if [ -z "$param1_path" ]; then
        echo -n "请输入远端源路径(文件或者目录): "
        read param1_path
    fi
    if [ -z "$param2_path" ]; then
        echo "本地目标目录未指定,使用默认路径("$default_local_path")."
        param2_path=$default_local_path
    fi
elif [ -z "$param1_host" ] && [ -n "$param2_host" ]; then
    filter=$param2_host
    if [ -z "$param1_path" ]; then
        echo -n "请输入本地源路径(文件或者目录): "
        read param1_path
    fi
    if [ -z "$param2_path" ]; then
        echo "远端目标目录未指定,使用默认路径("$default_remote_path")."
        param2_path=$default_remote_path
    fi
else
    filter=$param1_host
    if [ -z "$param1_path" ]; then
        echo -n "请输入远端源路径(文件或者目录): "
        read param1_path
    fi
    if [ -z "$param2_path" ]; then
        echo "远端目标目录未指定,使用默认路径("$default_remote_path")."
        param2_path=$default_remote_path
    fi
fi

#判断参数是否足够
if [ -z "$param1_path" ] || [ -z "$param2_path" ]; then
    echo "源路径未指定,无法完成复制."
    exit
fi

#获取机器信息
. $dirPath"/fetch_machine_info.sh"

#计算scp命令
if [ -n "$param1_host" ] && [ -z "$param2_host" ]; then
    scp_command="scp -r -P "$port" "$loginuser"@"$ip":"$param1_path" "$param2_path
elif [ -z "$param1_host" ] && [ -n "$param2_host" ]; then
    scp_command="scp -r -P "$port" "$param1_path" "$loginuser"@"$ip":"$param2_path
elif [ -n "$param1_host" ] && [ -n "$param2_host" ]; then
    help_loginpass=$loginpass
    help_scp_command="scp -r -P "$port" "$loginuser"@"$ip":"$param1_path" "$default_local_path
    #再次获取机器信息
    filter=$param2_host
    . $dirPath"/fetch_machine_info.sh"
    scp_command="scp -r -P "$port" "$default_local_path"/"$(basename $param1_path)" "$loginuser"@"$ip":"$param2_path
fi

#执行复制操作
if [ -n "$help_scp_command" ]; then
    $dirPath"/copy.sh" "$help_scp_command" $help_loginpass
fi
$dirPath"/copy.sh" "$scp_command" $loginpass

#清除临时文件
if [ -n "$help_scp_command" ]; then
    temp_file=$default_local_path"/"$(basename $param1_path)
    echo "清除临时文件: rm -fr "$temp_file
    rm -fr $temp_file
fi
