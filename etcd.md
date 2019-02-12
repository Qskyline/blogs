# Etcd

### 配置
需要新建配置文件，路径没有特殊要求，etcd在启动的时候要指定配置文件.

**单例模式**

    name: etcd-1   #节点名字
    data-dir: /kingdee/data/etcd   #数据存储目录
    listen-client-urls: http://192.168.108.128:2379   #etcd与client通信使用的ip和端口，可以多个
    advertise-client-urls: http://192.168.108.128:2379   #etcd与client通信使用的建议ip和端口，可以多个
    listen-peer-urls: http://192.168.108.128:2380   #etcd本节点与其他节点通信所使用的ip和端口，可以多个
    initial-advertise-peer-urls: http://192.168.108.128:2380   #etcd本节点与其他节点通信所使用的建议ip和端口，可以多个


**集群模式**
    ###此处以三个节点(etcd-1,etcd-2,etcd-3)为例搭建集群,大部分配置与单例模式相同,下面仅给出集群相关配置(各节点一样)
    initial-cluster: etcd-1=http://192.168.108.128:2380,etcd-2=http://192.168.108.129:2380,etcd-3=http://192.168.108.130:2380   #所有集群节点的通信信息,格式为:节点名=对应节点initial-advertise-peer-urls其中的一个,多个节点用英文逗号隔开
    initial-cluster-token: etcd-cluster-token   #集群id
    initial-cluster-state: new   #新建集群的标志

### 运维
    cd /kingdee/etcd-v3.3.8/bin
    ./etcd --config-file=/kingdee/etcd-v3.3.8/conf/conf.yml   #启动
    ./etcdctl member list   #查看集群成员信息
    ./etcdctl cluster-health   #查看集群状态
    ./etcdctl set /message Hello   #给message key设置Hello值
    ./etcdctl get /message   #读取message key的值
    ./etcdctl rm /message   #删除message key
