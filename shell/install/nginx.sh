#/bin/bash

##定义根目录
base_dir=/kingdee
if [ -n "$global_base_dir" ]; then
    base_dir=$global_base_dir
fi

##创建存储安装包的临时目录
install_dir=/tmp/install
mkdir -p $install_dir

yum install -y gcc gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel
mkdir -p $base_dir
cd $base_dir
wget -c https://nginx.org/download/nginx-1.14.0.tar.gz
tar -xzf nginx-1.14.0.tar.gz
mv nginx-1.14.0.tar.gz $install_dir/
cd nginx-1.14.0
./configure --with-http_ssl_module
make
make install
