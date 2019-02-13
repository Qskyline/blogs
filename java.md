# Maven
    ## deploy jars to your private maven repository
    mvn deploy:deploy-file -DgroupId=kd.bos -DartifactId=bos-mc-license -Dversion=1.0 -Dpackaging=jar -Dfile=/Users/skyline/Downloads/bos-mc-license-1.0.jar -Durl=http://172.20.178.39:8081/repository/maven-releases/ -DrepositoryId=[servers.server.id(settings.xml)]

------

# Gerrit
    ## set user email
    ssh -P gerrit_ssh_port admin@ip gerrit set-account --add-email 1002485975@qq.com admin

    ## generate ssh-keygen
    ssh-keygen -t rsa -b 1024 -f skyline -C "my key"

    ## operate gerrit
    $gerrit_dir/bin/gerrit.sh start
    $gerrit_dir/bin/gerrit.sh stop
    $gerrit_dir/bin/gerrit.sh restart
