# Haproxy

### 安装
	yum -y install haproxy

### 配置
/etc/haproxy/haproxy.cfg配置文件最后加入如下配置

	listen rabbitmq_cluster 0.0.0.0:55672   #指定监听的端口
	mode tcp
	balance roundrobin   #负载策略
	server node1 172.18.4.112:5672 check inter 2000 rise 2 fall 3   #指定负载目标地址,个数不限
	server node2 172.18.4.113:5672 check inter 2000 rise 2 fall 3
	server node2 172.18.4.114:5672 check inter 2000 rise 2 fall 3

### 运维

	systemctl start haproxy   #启动
	systemctl restart haproxy   #重启
	systemctl stop haproxy   #关闭
