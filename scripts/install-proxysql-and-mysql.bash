#!/bin/bash
: '
This script installs the necessary resources to run proxysql locally. 
On some scenarios, the EC2 is unable to install proxysql and this script must be run manually after startup.
'

# Installation
cat <<EOF | sudo tee /etc/yum.repos.d/proxysql.repo
[proxysql_repo]
name=ProxySQL repository
baseurl=https://repo.proxysql.com/ProxySQL/proxysql-2.5.x/centos/8
gpgcheck=1
gpgkey=https://repo.proxysql.com/ProxySQL/proxysql-2.5.x/repo_pub_key
EOF

dnf -y install proxysql
dnf -y localinstall https://dev.mysql.com/get/mysql80-community-release-el9-4.noarch.rpm
dnf -y install mysql mysql-community-client

dnf -y install httpd
echo "Hello from proxysql Instance 1" | tee /var/www/html/index.html

service proxysql start 
systemctl start httpd
systemctl enable httpd 