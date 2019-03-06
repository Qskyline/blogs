# Rabbitmq

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
