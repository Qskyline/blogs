## iptables

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

## reset password of root in centos7

1. 启动过程,'e'键进入启动参数配置界面
2. LANG=zh_CN.UTF-8后加入'init=/bin/sh', ctrl+x 退出配置界面
3. mount –o remount,rw /   --挂载文件系统到根目录
4. passwd   --修改root密码
5. touch /.autorelabel
6. exec /sbin/init 或 exec /sbin/reboot 重启OS

----------

## samba

**configure**

    ##/etc/samba/smb.conf
    [global]
        workgroup = WORKGROUP
        security = user
        #security = share
        passdb backend = tdbsam
        printing = cups
        printcap name = cups
        load printers = yes
        cups options = raw

    [huawei]
        comment = ierp-huawei-custom
        path = /var/kingdee/share/samba/huawei
        valid users = build
        browseable = yes
        writable = yes
        public = no
        create mask = 0600
        directory mask = 0775

**commands**

    pdbedit -L   #列出samba用户
    pdbedit -Lv   #列出samba用户详细信息
    smbpasswd -a userName   #添加samba用户
    smbpasswd -x userName   #删除samba用户
    net use * /del /y   #Windows中此命令断开所有连接,用于解决"不允许一个用户使用一个以上用户名与一个服务器或共享资源的多重连接"问题
    net use   #Windows中此命令可以查看当前本机与网络资源的连接,例如驱动器映射、IPC连接等
