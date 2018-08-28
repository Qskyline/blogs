# Elasticsearch
### Install
	##定义根目录
	base_dir=/kingdee
	if [ -n $global_base_dir ]; then
		base_dir=$global_base_dir
	fi

	##创建存储安装包的临时目录
	install_dir=/tmp/install
	mkdir -p install_dir

	##定义服务ip和端口
	service_ip_port=ip:port

	##添加环境ip和主机名的映射
	hosts_add=(
		ip_1@hostname_1
		ip_2@hostname_2
		...
	)
	for host in ${hosts_add[@]}; do
		OLD_IFS="$IFS"
		IFS="@"
		arr=($host)
		pair="${arr[0]} ${arr[1]}"
		IFS="$OLD_IFS"
		echo "$pair" >> /etc/hosts
	done

	##系统优化
	echo "* soft nofile 65536" >> /etc/security/limits.conf
	echo "* hard nofile 131072" >> /etc/security/limits.conf
	echo "* soft nproc 2048" >> /etc/security/limits.conf
	echo "* hard nproc 4096" >> /etc/security/limits.conf
	echo "vm.max_map_count=655360" >> /etc/sysctl.conf
	sysctl -p

	##安装es
	mkdir -p $base_dir
	cd $base_dir
	wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.3.0.tar.gz
	tar -xzf elasticsearch-6.3.0.tar.gz
	mv -fr elasticsearch-6.3.0.tar.gz $install_dir/
	es_base_dir=$base_dir/elasticsearch-6.3.0
	es_data_dir=$base_dir/data/es
	es_log_dir=$es_base_dir/logs
	mkdir -p $es_data_dir
	mkdir -p $es_log_dir
	groupadd elsearch
	useradd elsearch -g elsearch
	chown -R elsearch:elsearch $es_base_dir $es_data_dir
	chmod -R 755 $es_base_dir $es_data_dir

	##安装es-head
	cd $base_dir
	wget https://npm.taobao.org/mirrors/node/v10.8.0/node-v10.8.0-linux-x64.tar.xz
	tar -xf node-v10.8.0-linux-x64.tar.xz
	mv -fr node-v10.8.0-linux-x64.tar.xz $install_dir/
	mv node-v10.8.0-linux-x64/lib/node_modules /usr/local/lib/
	mv node-v10.8.0-linux-x64/bin/* /usr/local/bin/
	rm -fr node-v10.8.0-linux-x64
	yum -y install git
	git clone https://github.com/mobz/elasticsearch-head.git
	cd elasticsearch-head
	npm install
	nohup npm run start &   #http://ip:9100

	##安装定时任务清理es中过期的index
	echo '#!/bin/bash
	keep_days=5
	es_ip_port='$service_ip_port'
	time=`date +%Y-%m-%d -d "$keep_days days ago"`
	index=`curl -XGET http://$es_ip_port/_cat/indices?v|awk '"'"'{print $3}'"'"'|grep "$time"`
	for i in $index; do
	  curl -X DELETE "http://$es_ip_port/${i}"
	done' > $es_base_dir/clear.sh
	chmod -R 755 $es_base_dir/clear.sh
	echo "59 23 * * * $es_base_dir/clear.sh" >> /var/spool/cron/root

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

### 运维
	su - elsearch -s /bin/sh -c "/kingdee/elasticsearch-6.3.0/bin/elasticesrarch -d"   #启动
