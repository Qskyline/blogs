#!/bin/bash

#定义安装目录(运行必须)
dirPath="/usr/local/lib/my_cmd"

#获取机器信息
. $dirPath"/fetch_machine_info.sh"

#输出密码
echo "密码: "$loginpass
