# Redis

### Configure
配置文件路径：$redis_base_dir/conf/redis.conf

**单例模式**

	##请关注如下配置

    #后台启动
    daemonize yes
    #是否以集群模式启动
    cluster-enabled no

    #监听端口
	port 6379
    #绑定ip(redis使用本机的哪个ip通信)
	bind 192.168.119.131

    #数据文件存放路径(rdb和aof文件存储位置)
	dir /kingdee/data/redis/6379
    #redis运行pid文件存放路径
	pidfile /kingdee/redis-3.0.6/run/redis_6379.pid
    #指定日志文件路径
    logfile /kingdee/redis-3.0.6/logs/redis_6379.log

    #最大内存限制,此处设置为3G
    maxmemory 3221225472
    #最大连接数限制
    maxclients 10000

    #客户端连接密码
	requirepass yourpassword

    ##快照持久化的相关配置(rdb方式)
    #指定rdb数据文件存储文件名(快照持久化方式的数据文件)
    dbfilename dump.rdb
    #当snapshot时出现错误无法继续时,是否阻塞客户端"变更操作","错误"可能因为磁盘已满/磁盘故障/OS级别异常等
    stop-writes-on-bgsave-error yes
    #如果redis不需要落盘,请注释掉下面所有save相关配置(或者在最后配置save "")
    #更改1个key,时间隔900s进行持久化存储
    save 900 1
    #更改10个key时间隔300s进行持久化存储
    save 300 10
    #更改10000个key时间隔60s进行持久化存储
    save 60 10000
    #是否启用rdb文件压缩,默认为"yes",压缩往往意味着"额外的cpu消耗",同时也意味这较小的文件尺寸以及较短的网络传输时间(指主从时的网络传输)
    rdbcompression yes

    ##操作日志追加方式的持久化相关配置(AOF)
    #打开AOF持久化方式
    appendonly yes
    #指定aof文件名称
    appendfilename appendonly.aof
    #指定aof操作的文件同步策略,有3个合法值:always/everysec/no,默认为everysec,以应对OS文件系统缓存所导致的数据丢失
    appendfsync everysec
    #在aof-rewrite期间,appendfsync是否暂缓文件同步,默认为no
    no-appendfsync-on-rewrite no
    #aof文件rewrite触发的最小文件尺寸(mb,gb),默认"64mb",建议"512mb"
    auto-aof-rewrite-min-size 512mb
    #每一次aof记录的添加,都会检测当前aof文件的尺寸;每一次rewrite之后,redis都会记录下此时新的aof文件的大小;auto-aof-rewrite-percentage参数指定下次rewrite的触发条件
    auto-aof-rewrite-percentage 100

    ##redis内存淘汰策略,有6个合法值:noeviction/allkeys-lru/allkeys-random/volatile-lru/volatile-random/volatile-ttl
    maxmemory-policy volatile-lru

**哨兵模式**

	##暂不考虑

**集群模式**

	##分别在多台机器上启动redis集群节点,因为要设置主从复置比例为1:1,所以建议偶数个节点(至少6个)
	##集群模式的配置与单例模式基本相同,下面列出有区别的配置
    #是否以集群模式启动
	cluster-enabled yes
    #设定了保存节点配置文件的路径
	cluster-config-file nodes.conf
	cluster-node-timeout 15000
    #主节点连接密码
	masterauth yourpassword
    #客户端连接密码
	requirepass yourpassword

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
