### iptables
    /sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
    /etc/rc.d/init.d/iptables save
    /etc/rc.d/init.d/iptables restart

    firewall-cmd --permanent --zone=public --add-rich-rule='rule family=ipv4 source address=172.20.70.68 port protocol=tcp port=80 accept'
    firewall-cmd --zone=public --add-port=80/tcp --permanent
    systemctl restart firewalld.service
    firewall-cmd --query-port=80/tcp

    iptables -t nat -A PREROUTING -d hostIp -p tcp -m tcp --dport hostPort -j DNAT --to-destination destinationIP:destinationPort   --端口转发
    iptables -t nat -A POSTROUTING -d destinationIP -p tcp --dport destinationPort -j MASQUERADE   --修改包的源地址
    iptables -t nat -L -n --line-numbe   --查看nat表
    iptables -t nat -D chainName ruleNumber   --删除某个链中的某个规则

-----------

### reset password of root in centos7
1. 启动过程,'e'键进入启动参数配置界面
2. LANG=zh_CN.UTF-8后加入'init=/bin/sh', ctrl+x 退出配置界面
3. mount –o remount,rw /   --挂载文件系统到根目录
4. passwd   --修改root密码
5. touch /.autorelabel
6. exec /sbin/init 或 exec /sbin/reboot 重启OS

----------
