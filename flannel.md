# Flannels

### 配置
    ###flannel依赖etcd,请先在etcd中添加flannel启动依赖的配置,命令如下(在etcd节点执行)
    etcdctl --endpoints "http://etcd_ip:etcd_port" set /coreos.com/network/config '{"NetWork":"10.0.0.0/16", "SubnetMin":"10.0.1.0", "SubnetMax":"10.0.20.0", "Backend":{"Type":"vxlan"}}'

    ###之后的操作需要flannel启动后执行
    cat /run/flannel/subnet.env   #查看flannel分配的网络参数
    ./mk-docker-opts.sh -d /run/docker_opts.env -c   #生成docker服务启动参数

    ###修改docker服务启动参数(/lib/systemd/system/docker.service),使用flannel为其分配的子网信息,相关参数如下
    ExecStart=/usr/bin/dockerd $DOCKER_OPTS   #在启动docker服务时增加flannel提供的启动参数$DOCKER_OPTS
    EnvironmentFile=/run/docker_opts.env   #指定这些启动参数所在的文件位置(这个配置是新增的)
    systemctl restart docker   #重启docker服务

### 运维
    /kingdee/flannel-v0.10.0/bin/flanneld --etcd-endpoints="http://etcd_ip:etcd_port" --iface=本机通信ip --ip-masq=true >> /kingdee/flannel-v0.10.0/logs/flanneld.log 2>&1 &   #启动flannel
