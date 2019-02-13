# Marathon

### Commands
    ##建议配置2个以上的marathon节点
    #启动,master参数后面为mesos使用的zk信息,zk参数后面为marathon运行使用的zk信息,两种zk可以相同,也可以不同
    /kingdee/marathon-1.6.322/bin/start --master zk://mesos-zk1_ip:mesos-zk1_port,mesos-zk2_ip:mesos-zk2_port,mesos-zk3_ip:mesos-zk3_port/mesos --zk zk://marathon-zk1_ip:marathon-zk1_port,marathon-zk2_ip:marathon-zk2_port,marathon-zk3_ip:marathon-zk3_port/marathon
