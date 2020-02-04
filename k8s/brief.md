### 1. 容器化的发展

容器革命
![container-evolution](../assets/container-evolution.svg)

当前状态
![container-develop](../assets/container-develop.png)

### 2. kubernetes是什么？
容器编排工具，提供弹性扩容、故障转移、服务发现、负载均衡、存储编排等服务。

### 3. kubernetes组成简介

**实体进程**
* master（kube-apiserver,kube-scheduler,kube-controller-manager,etcd)
* node(kubelet,kube-proxy)

**抽象概念**
* service（ClusterIP、NodePort、LoadBalancer、ExternalName）
* pod

### 4. kubernetes模型
**架构简图**
![k8s-model](../assets/k8s-model.png)

**流程图**
![k8s-flow](../assets/k8s-flow.png)

### 5. 网络模型
**docker**
1. 相同主机上的容器如何互相访问？
* container模式
* bridge模式
2. 不同主机上的容器如何互相访问？
* 搭建overlay网络（flannel）
![flannel](../assets/flannel.png)
* 虚拟路由网络（calico）
![calico](../assets/calico.png)

**k8s**
1. 容器中如何访问service
* clusterIp
* dns

2. 外部如何访问service
* NodePort
* LoadBalancer

### 6. kubernetes存储
* 直接存储
* nas
