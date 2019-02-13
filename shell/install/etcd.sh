#/bin/bash

##定义根目录
base_dir=/kingdee
if [ -n "$global_base_dir" ]; then
    base_dir=$global_base_dir
fi

##创建存储安装包的临时目录
install_dir=/tmp/install
mkdir -p $install_dir

##定义数据存储目录
mkdir -p $base_dir/data/etcd

##定义环境变量
echo 'export ETCDCTL_API=3' >> /etc/profile
source /etc/profile

cd $base_dir
wget https://github.com/coreos/etcd/releases/download/v3.3.8/etcd-v3.3.8-linux-amd64.tar.gz
tar -xzf etcd-v3.3.8-linux-amd64.tar.gz
mv -f etcd-v3.3.8-linux-amd64.tar.gz $install_dir/
mv etcd-v3.3.8-linux-amd64 etcd-v3.3.8
mkdir -p etcd-v3.3.8/conf/
touch etcd-v3.3.8/conf/conf.yml
