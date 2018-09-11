# Rabbitmq
### Install
	##定义根目录
	base_dir=/kingdee
	if [ -n $global_base_dir ]; then
		base_dir=$global_base_dir
	fi

	##创建存储安装包的临时目录
	install_dir=/tmp/install
	mkdir -p install_dir

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

	##安装文件准备
	rabbitmq_install_dir=$base_dir/rabbitmq
	mkdir -p $rabbitmq_install_dir
	cd $rabbitmq_install_dir
	wget http://erlang.org/download/otp_src_20.3.tar.gz
	wget http://www.dest-unreach.org/socat/download/socat-1.7.3.2.tar.gz
	wget https://dl.bintray.com/rabbitmq/all/rabbitmq-server/3.7.6/rabbitmq-server-3.7.6-1.el7.noarch.rpm
	tar -xzf otp_src_20.3.tar.gz
	tar -xzf socat-1.7.3.2.tar.gz
	mv otp_src_20.3.tar.gz $install_dir/
	mv socat-1.7.3.2.tar.gz $install_dir/
	otp_install_dir=$rabbitmq_install_dir/otp_src_20.3
	socat_install_dir=$rabbitmq_install_dir/socat-1.7.3.2

	##安装erlang
	yum -y install gcc gcc-c++ make perl ncurses ncurses-devel openssl-devel unixODBC-devel logrotate
	export ERL_TOP=$otp_install_dir
	cd $otp_install_dir
	./configure --without-javac
	make
	make install

	##安装socat
	cd $socat_install_dir
	./configure
	make
	make install

	##安装rabbitmq
	cd $rabbitmq_install_dir
	rpm -i rabbitmq-server-3.7.6-1.el7.noarch.rpm --nodeps
	rabbitmq-plugins enable rabbitmq_management   #开启rabbitmq_management
	chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
	chmod 400 /var/lib/rabbitmq/.erlang.cookie
	mv rabbitmq-server-3.7.6-1.el7.noarch.rpm $install_dir/
	cd $base_dir
	rm -fr $rabbitmq_install_dir

	##启动rabbitmq
	rabbitmq-server -detached

	##如果是安装rabbitmq高可用集群,请继续执行下列操作
	1. 复置其中一个节点上的/var/lib/rabbitmq/.erlang.cookie文件替换其他所有节点上的此文件,注意复制后要保证目标文件的所属用户和用户组均为rabbitmq,权限为400,请参考以下命令:
		scp /var/lib/rabbitmq/.erlang.cookie kduser@ip:/home/kduser/
		mv -fr /home/kduser/.erlang.cookie /var/lib/rabbitmq/
		chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
		chmod 400 /var/lib/rabbitmq/.erlang.cookie
	2. 选中一个节点,将剩余所有节点都加入此节点组成集群,比如选中node1,则需要分别在剩余所有节点上执行如下操作:
		rabbitmqctl stop_app
		rabbitmqctl reset
		rabbitmqctl change_cluster_node_type disc
		rabbitmqctl join_cluster rabbit@node1
		rabbitmqctl start_app

### Configure
	##默认配置即可

### Operation
	rabbitmqctl cluster_status   #打印集群状态
	rabbitmqctl set_policy -p / ha-all "^" '{"ha-mode":"all"}'   #设置所有节点同步queue,此处vhost为"/",policy的名字是ha-all
	rabbitmqctl clear_policy -p / ha-all   #删除某个vhost上的某个policy
	rabbitmqctl list_policies -p /   #打印某个vhost上的所有policy
	rabbitmqctl add_user admin 123456   #添加用户
	rabbitmqctl set_user_tags admin administrator   #设置用户角色
	rabbitmqctl list_users   #查看用户列表
	rabbitmqctl set_permissions -p / admin '.*' '.*' '.*'   #赋予用户vhost访问权限,此处vhost为"/"
	rabbitmqctl add_vhost kingdee   #添加vhost,此处添加了一个名为kingdee的vhost
	rabbitmqctl list_vhosts   #打印所有vhost
	rabbitmqctl delete_vhost kingdee   #删除某个vhost
