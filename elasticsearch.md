# Elasticsearch

### Configure
配置文件路径:$base_dir/elasticsearch-6.3.0/config/elasticsearch.yml

**单节点配置**
	##请关注以下配置
	path.data: /kingdee/data/es   #数据存储目录
	path.logs: /kingdee/elasticsearch-6.3.0/logs   #日志存储目录
	network.host: 192.168.10.11   #通信ip
	http.port: 9200   #监听端口
	http.cors.enabled: true
	http.cors.allow-origin: "*"

**集群配置**
	##请关注以下配置
	cluster.name: kingdee-es   #集群名称,每个节点的集群名称必须一样
	node.name: node1   #集群节点名称,配置本节点主机名,比如此处hostname为node1
	path.data: /kingdee/data/es   #数据存储目录
	path.logs: /kingdee/elasticsearch-6.3.0/logs   #日志存储目录
	network.host: 192.168.10.11   #通信ip
	http.port: 9200   #监听端口
	http.cors.enabled: true
	http.cors.allow-origin: "*"
	discovery.zen.ping.unicast.hosts: ["node1", "node2", "node3"]   #集群节点信息,用于互相发现,协调选主

### Operation
	su - elsearch -s /bin/sh -c "/kingdee/elasticsearch-6.3.0/bin/elasticesrarch -d"   #启动
