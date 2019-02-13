#/bin/bash

##定义根目录
base_dir=/kingdee
if [ -n "$global_base_dir" ]; then
    base_dir=$global_base_dir
fi

##创建存储安装包的临时目录
install_dir=/tmp/install
mkdir -p $install_dir

mkdir -p $base_dir
cd $base_dir
wget https://downloads.mesosphere.com/marathon/releases/1.6.322/marathon-1.6.322-2bf46b341.tgz
tar -xzf marathon-1.6.322-2bf46b341.tgz
mv marathon-1.6.322-2bf46b341.tgz $install_dir/
mv marathon-1.6.322-2bf46b341 marathon-1.6.322
cd marathon-1.6.322
