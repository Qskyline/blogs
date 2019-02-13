#!/bin/bash

docker rmi $(docker images | grep "<none>" | awk '{print $3}')
docker rmi $(docker images | awk '{print $1":"$2}')

# echo "59 23 * * 3 /var/kingdee/bin/clear-dockerImages.sh" >> /var/spool/cron/root
