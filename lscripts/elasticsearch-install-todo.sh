#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Elastic Search (ES)
###----------------------------------------------------------


#### dependencies
sudo apt -y install apt-transport-https

#### Add repository
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
sudo apt -y install elasticsearch

#### test ES installation
sudo systemctl start elasticsearch.service
curl -XGET 'localhost:9200/?pretty'
