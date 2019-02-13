# Mesos

### Commnands
    ##建议mesos-master部署3个节点
    ##mesos web页面地址为:任意mesos-master节点ip:5050

    #创建日志目录
    mkdir -p /kingdee/data/mesos/logs/master
    mkdir -p /kingdee/data/mesos/logs/slave

    #切换目录
    cd /kingdee/mesos-1.6.0/build/bin

    #mesos-master启动,此处使用3个节点的zk集群
    ./mesos-master.sh --ip=本机用于通信的ip zk=zk://zk1_ip:zk1_port,zk2_ip:zk2_port,zk3_ip:zk3_port/mesos --quorum=2 --work_dir=/kingdee/data/mesos --external_log_file=/kingdee/data/mesos/logs/master

    #mesos-slave启动,此处使用3个节点的zk集群
    ./mesos-agent.sh --master=zk://zk1_ip:zk1_port,zk2_ip:zk2_port,zk3_ip:zk3_port/mesos --containerizers=docker,mesos --hostname=hostname  --ip=本机用于通信的ip --work_dir=/kingdee/data/mesos --external_log_file=/kingdee/data/mesos/logs/slave
