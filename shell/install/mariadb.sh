#/bin/bash

#配置yum源
echo
    '[mariadb]
    name = MariaDB
    baseurl = http://yum.mariadb.org/10.1.22/centos7-amd64/
    gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
    gpgcheck=1'
> /etc/yum.repos.d/MariaDB.repo

#安装mariadb
yum install -y MariaDB-server MariaDB-client
