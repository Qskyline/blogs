# Zookeeper

### Configure
配置文件路径:$zk_base_dir/conf/zoo.cfg

**单节点配置**

	tickTime=2000
	initLimit=10
	syncLimit=5
	dataDir=/kingdee/data/zk/2181   #数据存储目录
	dataLogDir=/kingdee/zookeeper-3.4.12/logs/2181   #日志存储目录
	clientPort=2181   #监听端口
	maxClientCnxns=120
	autopurge.snapRetainCount=3
	autopurge.purgeInterval=1

**集群配置**

	##请设置奇数个节点(此处以3个节点为例)
	##请在每个节点的数据存储目录中新增文件myid,此文件保存了对应节点的id值,此值必须与配置文件中server.id的id值一致,参考命令如下(以172.18.2.177节点为例,对应id值为0):
	mkdir -p $zk_data_dir/2181/
	echo 0 > $zk_data_dir/2181/myid
	##在所有单节点的配置文件最后加入如下配置
	server.0=172.18.2.177:2888:3888   #集群节点信息,格式为:server.id=ip:集群通信端口:选举端口
	server.1=172.18.2.178:2888:3888
	server.2=172.18.2.179:2888:3888

### Operation
	##shell commands
	/kingdee/zookeeper-3.4.12/bin/zkServer.sh start /kingdee/zookeeper-3.4.12/conf/zoo.cfg   #start
	/kingdee/zookeeper-3.4.12/bin/zkServer.sh stop /kingdee/zookeeper-3.4.12/conf/zoo.cfg   #stop
	/kingdee/zookeeper-3.4.12/bin/zkServer.sh status /kingdee/zookeeper-3.4.12/conf/zoo.cfg   #show zk node status
	/kingdee/zookeeper-3.4.12/bin/zkCli.sh -server ip:port   #connect zk

	##zk commands
	rmr path   #删除非空节点
	delete path   #删除叶子节点

	##zk telnet commands or 'echo {command} | nc ip port'
	conf   #打印服务器的配置信息
	cons   #输出所有客户端连接的详细信息
	stat   #输出服务器运行时的状态信息
	mntr   #输出比stat更详尽的服务器统计信息
	envi   #打印服务器运行时的环境信息
	ruok   #确认服务运行状态是否正常,如果服务正在运行,则回复'imok',相反的服务将不会回应
	srvr   #打印所有的服务器信息
