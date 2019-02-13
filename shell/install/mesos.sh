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
wget http://mirror.bit.edu.cn/apache/mesos/1.6.0/mesos-1.6.0.tar.gz
tar -xzf mesos-1.6.0.tar.gz
mv mesos-1.6.0.tar.gz $install_dir/
yum groupinstall -y "Development Tools"
yum install -y epel-release apache-maven python-devel python-six python-virtualenv java-1.8.0-openjdk-devel zlib-devel libcurl-devel openssl-devel cyrus-sasl-devel cyrus-sasl-md5 apr-devel subversion-devel apr-util-devel
mkdir -p mesos-1.6.0/build
cd mesos-1.6.0/build
../configure
make -j2
make check
make install
