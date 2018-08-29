# Redis
### Install
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

### Configure
配置文件路径：$redis_base_dir/conf/redis.conf

**单例模式**

	##请关注如下配置
	port 6379   #监听端口
	daemonize yes   #后台启动
	bind 192.168.119.131   #绑定ip(redis使用本机的哪个ip通信)
	dir /kingdee/data/redis/6379   #数据文件存放路径
	pidfile /kingdee/redis-3.0.6/run/redis_6379.pid   #redis运行pid文件存放路径
	cluster-enabled no   #是否以集群模式启动
	logfile /kingdee/redis-3.0.6/logs/redis_6379.log   #指定日志文件路径
	dbfilename dump.rdb   #指定数据文件存储文件名
	appendonly yes   #开启数据持久化模式为AOF
	requirepass yourpassword   #客户端连接密码
    maxclients 10000   #最大连接数限制
    maxmemory 3221225472   #最大内存限制,此处设置为3G
    #如果redis不需要落盘,请注释掉下面配置
    save 900 1
    save 300 10
    save 60 10000

**哨兵模式**

	##暂不考虑

**集群模式**

	##分别在多台机器上启动redis集群节点,因为要设置主从复置比例为1:1,所以建议偶数个节点(至少6个)
	##集群模式的配置与单例模式基本相同,下面列出有区别的配置
	cluster-enabled yes   #是否以集群模式启动
	cluster-config-file nodes.conf   #设定了保存节点配置文件的路径
	cluster-node-timeout 15000
	masterauth yourpassword   #主节点连接密码
	requirepass yourpassword   #客户端连接密码

### Operation
    ##shell commands
    /kingdee/redis-3.0.6/bin/redis /kingdee/redis-3.0.6/conf/redis.conf   #开启redis节点
	/kingdee/redis-3.0.6/bin/redis-trib.rb create --replicas 1 node1_ip:node1_port node2_ip:node2_port ...   #搭建集群(主从复置比例为1:1,至少6个节点)
	/kingdee/redis-3.0.6/bin/redis-cli -c -h ip -p port   #连接redis集群(任意节点ip/port即可)
    /kingdee/redis-3.0.6/bin/redis-cli -h ip -p port   #连接redis单例

	##redis commands
	cluster info   #查看集群信息
	cluster nodes   #查看集群节点
	slowlog   #查看慢查询日志
	info   #查看redis节点信息
