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
wget https://github.com/coreos/flannel/releases/download/v0.10.0/flannel-v0.10.0-linux-amd64.tar.gz
tar -xzf flannel-v0.10.0-linux-amd64.tar.gz
mv flannel-v0.10.0-linux-amd64.tar.gz $install_dir/
mv flannel-v0.10.0-linux-amd64 flannel-v0.10.0
mkdir flannel-v0.10.0/logs
