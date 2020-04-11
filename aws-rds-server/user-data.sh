#!/bin/sh
set -x -e
sudo yum update -y
sudo yum install -y gcc
sudo yum install -y postgresql-devel
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python get-pip.py
sudo pip install pgcli --ignore-installed
