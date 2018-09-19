### clear docker images

    docker rmi $(docker images | grep "<none>" | awk '{print $3}')
    docker rmi $(docker images | awk '{print $1":"$2}')
