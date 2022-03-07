#!/bin/bash

sudo apt-get -y update &&
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common &&
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&
sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable' &&
sudo apt-get -y update &&
sudo apt-cache policy docker-ce &&
sudo apt-get install -y nload screen docker-ce
sudo docker pull alpine/bombardier
sudo poweroff
