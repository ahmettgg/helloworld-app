#! /bin/bash
dnf update -y
hostnamectl set-hostname Devops-Task-Testinium
dnf install docker -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user
curl -SL https://github.com/docker/compose/releases/download/v2.26.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
dnf install git -y
dnf install wget -y
wget https://corretto.aws/downloads/latest/amazon-corretto-21-x64-linux-jdk.rpm
rpm -ivh amazon-corretto-21-x64-linux-jdk.rpm
newgrp docker