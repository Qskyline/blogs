# Kafka

### 配置
配置文件路径:$base_dir/kafka/config/server.properties

**单实例配置**

	##请关注如下参数配置
	broker.id=1   #节点编号,如果是集群,每个节点的编号必须不同
	port=9092   #监听端口
	host.name=192.168.1.211   #本机通信ip
	num.network.threads=2
	num.io.threads=8
	socket.send.buffer.bytes=1048576
	socket.receive.buffer.bytes=1048576
	socket.request.max.bytes=104857600
	log.dirs=/tmp/kafka-logs   #日志路径
	num.partitions=2
	log.retention.hours=168
	log.segment.bytes=536870912
	log.retention.check.interval.ms=60000
	log.cleaner.enable=false
	zookeeper.connect=192.168.1.213:2181,192.168.1.216:2181,192.168.1.217:2181   #zk地址,并非一定是zk集群,可以配置单个zk地址
	zookeeper.connection.timeout.ms=1000000

**集群配置**

	##集群中每个节点的配置基本与单实例模式下节点的配置相同,下面列出需要更改的相关配置项
	broker.id=*   #每个节点的编号必须不同,由1开始递增
	host.name=192.168.1.211   #每个节点绑定自己本机的通信ip    10.200.4.203:2181

### 运维
	cd /kingdee/kafka/bin
	./kafka-server-start.sh -daemon ../config/server.properties &   #启动
	./kafka-topics.sh --create --replication-factor 1 --partitions 1 --topic test --zookeeper zk_ip:zk_port   #创建topic,副本数量为1(最大值是集群节点数),分区数为1,主题名为test,还需要指定Kafka集群所用的zk信息
	./kafka-topics.sh --list --zookeeper 10.200.4.203:2181   #列出所有topic
	./kafka-topics.sh --describe --zookeeper zk_ip:zk_port --topic test   #查看topic详细信息
	./kafka-console-producer.sh --zookeeper zk_ip:zk_port --topic test   #连接Kafka,发送消息
	./kafka-console-consumer.sh --zookeeper 10.200.4.203:2181 --topic yike-ierp0410-log --from-beginning   #连接Kafka,消费消息
