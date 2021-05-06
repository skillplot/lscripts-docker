#!/bin/bash

sudo service docker stop
sudo service docker start
docker exec -u $(id -u):$(id -g) -it bzohub-230820_220308 /bin/bash && xhost -local:root 1>/dev/null 2>&1
