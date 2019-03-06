##定义根目录
base_dir=/kingdee
if [ -n $global_base_dir ]; then
base_dir=$global_base_dir
fi

##创建存储安装包的临时目录
install_dir=/tmp/install
mkdir -p install_dir

#依赖安装
yum install ruby rubygems
gem install redis

#编译redis
mkdir -p $base_dir/redis_temp
cd $base_dir/redis_temp
wget http://download.redis.io/releases/redis-3.0.6.tar.gz
tar -xzf redis-3.0.6
cd redis-3.0.6
make
make install

#整理redis目录
redis_base_dir=$base_dir/redis-3.0.6
mkdir -p $redis_base_dir/bin $redis_base_dir/conf $redis_base_dir/logs $redis_base_dir/run $base_dir/data/redis
cp -fr $base_dir/redis_temp/src/{mkreleasehdr.sh,redis-benchmark,redis-check-aof,redis-check-dump,redis-cli,redis-sentinel,redis-server,redis-trib.rb} $redis_base_dir/bin
cp -fr $base_dir/redis_temp/{redis.conf,sentinel.conf} $redis_base_dir/conf
rm -fr $base_dir/redis_temp
