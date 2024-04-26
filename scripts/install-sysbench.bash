#!/bin/bash
: '
This script installs the necessary resources to run sysbench, inclusive of sysbench v1.1.0-2ca9e3f. 
On some scenarios, the EC2 is unable to install sysbench and this script must be run manually after startup. This script should be run on the `sysbench EC2 Instance`.

Sysbench is a widely-used, open-source performance benchmarking tool for databases. 
You can use sysbench to run your performance tests from the `sysbench EC2 Instance` which is included in this template.

This script is only needed if you want to run performance tests via the `Sysbench EC2 Instance`.
'

sudo dnf -y install git gcc make automake libtool openssl-devel ncurses-compat-libs
sudo dnf -y localinstall https://dev.mysql.com/get/mysql80-community-release-el9-4.noarch.rpm
sudo dnf -y update
sudo dnf -y install mysql-community-devel mysql-community-client mysql-community-common
sudo git clone https://github.com/akopytov/sysbench
cd sysbench
sudo ./autogen.sh
sudo ./configure
make
sudo make install