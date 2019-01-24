# Maven
### Commands

    ## deploy jars to your private maven repository
    mvn deploy:deploy-file -DgroupId=kd.bos -DartifactId=bos-mc-license -Dversion=1.0 -Dpackaging=jar -Dfile=/Users/skyline/Downloads/bos-mc-license-1.0.jar -Durl=http://172.20.178.39:8081/repository/maven-releases/ -DrepositoryId=[servers.server.id(settings.xml)]

------

# Gerrit
### Install
    ## prepare a mysql db connection
    ## install and configure java
    ## prepare a nginx

    ## define the root path
    base_dir=/kingdee
    if [ -n $global_base_dir ]; then
        base_dir=$global_base_dir
    fi

    ## creat the temp dir for installing
    install_dir=/tmp/install
    mkdir -p $install_dir

    ## define the application dir.
    gerrit_dir=$base_dir/gerrit

    ## install httpd
    yum install -y httpd

    ## download Gerrit
    wget -P $install_dir/ https://gerrit-releases.storage.googleapis.com/gerrit-2.16.3.war

    ## install Gerrit
    java -jar $install_dir/gerrit-2.16.3.war init -d $gerrit_dir

    ## following the steps

    ## generate htpasswd
    htpasswd -b -c $gerrit_dir/etc/passwd admin admin

    ## configure nginx proxy to gerrit
    echo
        'server {
            listen  8080;
            server_name 127.0.0.1;
            location / {
                auth_basic "Restricted";
                auth_basic_user_file $gerrit_dir/etc/passwd;
                proxy_pass http://127.0.0.1:8081;
                proxy_set_header X-Forwarded-For $remote_addr;
                proxy_set_header Host $host;
            }
        }'
    > gerrit.conf


### Commands
    ## set user email
    ssh -P gerrit_ssh_port admin@ip gerrit set-account --add-email 1002485975@qq.com admin

    ## generate ssh-keygen
    ssh-keygen -t rsa -b 1024 -f skyline -C "my key"

    ## operate gerrit
    $gerrit_dir/bin/gerrit.sh start
    $gerrit_dir/bin/gerrit.sh stop
    $gerrit_dir/bin/gerrit.sh restart
