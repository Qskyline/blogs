#/bin/bash
#set -x

#params
#定义仓库地址(必选)
repo_url=git@github.com:Qskyline/devops.git
#指定构建版本(必选)
branch=master
#指定构建包名称(必选)
pkg_name=devops-1.0.jar
#指定构建目录(可选)
build_dir=
#指定构建包输出路径(可选)
output_dir=/var/kingdee/image/devops/devops

#外部传入params覆盖定义值
if [ -n "$1" ]; then
    repo_url=$1
fi
if [ -n "$2" ]; then
    branch=$2
fi
if [ -n "$3" ]; then
    pkg_name=$3
fi
if [ -n "$4" ]; then
    build_dir=$4
fi
if [ -n "$5" ]; then
    output_dir=$5
fi

#记录当前目录
current_workdir=$(pwd)

#判断必须params是否为空
if [ -z "$repo_url" ]; then
    echo 'Must specify the repo_url!'
    exit
fi
if [ -z "$branch" ]; then
    echo 'Must specify the branch!'
    exit
fi
if [ -z "$pkg_name" ]; then
    echo 'Must specify the pkg_name!'
    exit
fi

#计算项目名
temp=${repo_url##*/}
prj_name=${temp%.*}

#为当前依然为空的可选参数赋默认值
if [ -z "$build_dir" ]; then
    build_dir=/tmp
fi
if [ -z "$output_dir" ]; then
    output_dir=$(cd `dirname $0`; pwd)/$prj_name'-build-output'
fi

#拉取项目并进入项目目录
if [ -d "$build_dir/$prj_name" ]; then
    cd $build_dir/$prj_name
elif [ -d "$build_dir" ]; then
    cd $build_dir
    git clone $repo_url
    cd $prj_name
else
    mkdir -p $build_dir
    cd $build_dir
    git clone $repo_url
    cd $prj_name
fi

#记录git当前所在分支
current_branch=$(git branch | grep '*' | awk '{print $2}')

#基于指定分支创建构建分支
build_branch=$branch"-build-"$(date "+%Y%m%d%H%M")

#切换到构建分支
git checkout -b $build_branch origin/$branch
git pull

#编译构建前端文件
echo "===============================开始前端构建==============================="
sh updateClient.sh git@github.com:Qskyline/client.git devops dist /tmp
echo "===============================结束前端构建==============================="

#构建
mvn clean package

#放置构建包到输出目录
if [ ! -d $output_dir ]; then
    mkdir -p $output_dir
fi
rm -fr $output_dir/*
mv $build_dir/$prj_name/target/$pkg_name $output_dir

#切换回构建前的分支
git checkout $current_branch

#删除临时的构建分支
git branch -d $build_branch

#回到执行此脚本时的目录
cd $current_workdir

#清空项目目录
#rm -fr $build_dir/$prj_name
