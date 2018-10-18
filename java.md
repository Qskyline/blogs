# Maven Commands

    ## deploy jars to your private maven repository
    mvn deploy:deploy-file -DgroupId=kd.bos -DartifactId=bos-mc-license -Dversion=1.0 -Dpackaging=jar -Dfile=/Users/skyline/Downloads/bos-mc-license-1.0.jar -Durl=http://172.20.178.39:8081/repository/maven-releases/ -DrepositoryId=[servers.server.id(settings.xml)]
