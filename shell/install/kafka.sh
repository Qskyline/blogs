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
wget http://mirrors.hust.edu.cn/apache/kafka/1.1.0/kafka_2.12-1.1.0.tgz
tar -xzf kafka_2.12-1.1.0.tgz
mv kafka_2.12-1.1.0.tgz $install_dir/
mv kafka_2.12-1.1.0 kafka
cd kafka
