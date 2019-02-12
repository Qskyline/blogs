#!/bin/bash

#镜像tar包目录(运行必须)
image_tar_path=/var/kingdee/share/dockerImage
#镜像根目录(运行必须)
base_dir=/var/kingdee/image

#镜像生成函数
# image_make 工作空间 镜像名 版本 预处理命令 仓库url 仓库目录 仓库用户名 仓库密码
function image_make() {
  work_dir=$1
  image_name=$2
  cus_version=$3
  preparation=$4
  repo_url=$5
  repo_prefix=$6
  repo_user=$7
  repo_password=$8

  push_flag=true
  version=`date "+%Y%m%d%H%M"`
  #至少传递工作空间和镜像名
  if [ $# -lt 2 ]; then
    echo "Error: params error!"
    exit
  elif [ $# -gt 1 ] && [ $#  -lt 5 ]; then
    push_flag=false
  elif [ $# -gt 4 ] && [ $#  -lt 7 ]; then
    push_flag=true
  elif [ $# -eq 7 ]; then
    echo "Error: Please transmit the repo password!"
    exit
  elif [ $# -eq 8 ]; then
    docker login -u $repo_user -p $repo_password $repo_url
  else
    echo "Warning: Ignore the redundant params."
  fi

  if [ $work_dir"q" != "q" ]; then
    cd $work_dir
  fi

  if [ "$preparation"q != "q" ]; then
    OLD_PATH=`pwd`
    OLD_IFS="$IFS"
    IFS=";"
    arr=($preparation)
    for value in ${arr[@]}; do
      IFS="$OLD_IFS"
      $value
    done
    IFS="$OLD_IFS"
    cd "$OLD_PATH"
  fi

  if [ -n $cus_version ] && [ $cus_version != "-" ]; then
    version=$cus_version
  fi

  tag=$image_name":v-"$version
  if [ $repo_prefix"q" != "q" ] && [ $repo_prefix != "\"\"" ]; then
    tag=$repo_prefix"/"$tag
  fi
  if [ $repo_url"q" != "q" ] && [ $repo_url != "\"\"" ]; then
    tag=$repo_url"/"$tag
  fi

  echo "########################## $tag making start ##########################"
  docker build -t $tag .
  if [ $push_flag == "true" ]; then
    docker push $tag
  else
    tar_file=$image_tar_path/kd-$image_name-$version.tar
    echo "import $tag to $tar_file ..."
    rm -fr $tar_file
    docker save $tag -o $tar_file
  fi
  echo "########################## $tag making complete ##########################"
}

#输入检查函数
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

#以传参方式启动脚本
_imageName=$1
_repoInfo=$2
_isConfirm=$3
_imageVersion=$4

#扫描镜像配置
echo "镜像扫描目录为:"$base_dir
echo "------------------------------镜像配置------------------------------"
images=()
i=0
for image in $base_dir/*; do
  if [ -d $image ] && [ -f $image/Dockerfile ]; then
    images[$i]=$image
    echo $i")" ${image#*$base_dir/}
    i=$[i+1]
  fi
done

#计算镜像配置个数
count=${#images[@]}
if [ $count == 0 ]; then
  echo "未发现可用镜像配置"
  exit
fi

#获取用户输入
if [ -n "$_imageName" ]; then
  _imageName="$base_dir/$_imageName"
  c=0
  choice='null'
  for value in ${images[@]}; do
    if [ "$value" == "$_imageName" ]; then
      choice=$c
    else
      c=$[c+1]
    fi
  done
  if [ "$choice" == 'null' ]; then
    echo "Can not find the Dockerfile of ${_imageName#*$base_dir/}"
    exit
  fi
else
  echo -n "请输入镜像配置编号: "
  read choice
fi
input_check $choice $count

#默认配置
work_dir=${images[$choice]}
image_name=${work_dir#*$base_dir/}
preparation=""
repo_info=()
image_version=`date "+%Y%m%d%H%M"`

#加载全局环境变量
if [ -f ./env.sh ]; then
  . ./env.sh
fi

#加载镜像特定环境变量
if [ -f $work_dir/env.sh ]; then
  . $work_dir/env.sh
fi

#传参的版本号具有最高优先级
if [ -n "$_imageVersion" ]; then
  image_version=$_imageVersion
fi

#获取镜像仓库信息
echo "------------------------------镜像仓库------------------------------"
echo "0) 不上传镜像仓库"
count=${#repo_info[@]}
count=$[count+1]
i=1
for value in ${repo_info[@]}; do
  OLD_IFS="$IFS"
  IFS=","
  arr=($value)
  if [ -z ${arr[1]} ]; then
    echo $i") "${arr[0]}
  else
    echo $i") "${arr[0]}"/"${arr[1]}
  fi
  IFS="$OLD_IFS"
  i=$[i+1]
done

if [ -n "$_repoInfo" ]; then
  if [ "$_repoInfo" == 'local' ]; then
    choice=0
  else
    c=1
    choice='null'
    for value in ${repo_info[@]}; do
      OLD_IFS="$IFS"
      IFS=","
      arr=($value)
      if [ -z "${arr[1]}" ]; then
        _temp=${arr[0]}
      else
        _temp=${arr[0]}"/"${arr[1]}
      fi
      IFS="$OLD_IFS"
      if [ "$_repoInfo" == "$_temp" ]; then
        choice=$c
      else
        c=$[c+1]
      fi
    done
  fi
  if [ "$choice" == 'null' ]; then
    echo "Can not find the repoInfo of $_repoInfo"
    exit
  fi
else
  echo -n "请选择镜像仓库: "
  read choice
fi
input_check $choice $count

#输出确认信息
if [ $choice -eq 0 ]; then
  _repoInfo="local"
else
   OLD_IFS="$IFS"
   IFS=","
   arr=(${repo_info[choice-1]})
   if [ -z "${arr[1]}" ]; then
     _repoInfo=${arr[0]}
   else
     _repoInfo=${arr[0]}"/"${arr[1]}
   fi
   IFS="$OLD_IFS"
fi
echo "请确认镜像信息:"
echo "-----------------------------------------------------------------"
echo "镜像名字: "$image_name
echo "镜像版本: "$image_version
echo "镜像仓库: "$_repoInfo
echo "-----------------------------------------------------------------"

#判断是否已经传入确认标识
if [ "$_isConfirm"q == "-yq" ]; then
  confirm="y"
else
  echo -n "是否确认操作(y/n): "
  read confirm
fi

if [ "$confirm"q == "yq" ]; then
  echo "操作已确认!"
elif [ "$confirm"q == "nq" ]; then
  echo "操作取消!"
  exit
else
  echo "未知选项!"
  exit
fi

#镜像制作
if [ $choice -eq 0 ]; then
  image_make $work_dir $image_name $image_version "$preparation"
else
  choice=$[choice-1]
  repo=${repo_info[$choice]}
  OLD_IFS="$IFS"
  IFS=","
  arr=($repo)
  IFS="$OLD_IFS"
  count=${#arr[@]}
  if [ $count -eq 3 ]; then
    echo "Error: Unknown repo info!"
    exit
  fi
  params=""
  for (( i = $count-1; i >= 0; i-- )); do
    temp=${arr[$i]}
    if [ $temp"q" == "q" ]; then
      params="\"\" "$params
    else
      params=$temp" "$params
    fi
  done
  image_make $work_dir $image_name $image_version "$preparation" $params
fi
