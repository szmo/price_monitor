#!/bin/bash
wget -O - https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
echo "deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main" > /etc/apt/sources.list.d/saltstack.list
apt-get update
apt-get install -y salt-minion
echo "34.253.237.39 salt" >> /etc/hosts
salt-minion -d
salt-call state.highstate
