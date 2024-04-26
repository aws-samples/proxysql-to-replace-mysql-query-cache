#!/bin/bash
: '
This Script sets up the sysbench tables and environment from the `Sysbench EC2 instance`.
Appropriate sysbench tables will be created on your MySQL5.7 and MySQL8.0 Databases. 

Note that in this template, we have spun up 2 Databases: 
- (1) Aurora MySQL 8.0, and 
- (2) Aurora MySQL 5.7 
The Aurora MySQL 5.7 database is there to help in benchmarking tests.

Take note that you will need to fill up the following variables:
    ```
    export MYSQL_USER="fill_up"
    export MYSQL_PASSWORD="fill_up"
    export MYSQL_HOST="fill_up_with_MySQL5.7_writer"
    ```
and also do not forget the variable near the bottom of the script:

    ```
    export MYSQL_HOST="fill_up_with_MySQL8.0_writer"
    ```

This script is only needed if you want to run performance tests via the `Sysbench EC2 Instance`.
'

# MySQL Connection Details
export MYSQL_USER="fill_up"
export MYSQL_PASSWORD="fill_up"
export MYSQL_HOST="fill_up_with_MySQL5.7_writer"
export PORT=3306

# Sysbench Parameters
export SYSBENCH_DB="sbtest"
export SYSBENCH_THREADS=16
export SYSBENCH_NUM_TABLES=16
export SYSBENCH_TABLE_SIZE=1000000

# MySQL Command Example
mysql_command() {
    mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST -P$PORT -e "$1"
}

export -f mysql_command

# Drop and Recreate Database
mysql_command "DROP DATABASE IF EXISTS $SYSBENCH_DB;"
mysql_command "CREATE DATABASE $SYSBENCH_DB;"

# Run Sysbench Prepare Statement for MySQl5.7
sysbench oltp_read_only prepare \
--threads=$SYSBENCH_THREADS \
--db-driver=mysql \
--mysql-host=$MYSQL_HOST \
--mysql-port=$PORT \
--mysql-user=$MYSQL_USER \
--mysql-password=$MYSQL_PASSWORD \
--mysql-db=$SYSBENCH_DB \
--tables=$SYSBENCH_NUM_TABLES \
--table-size=$SYSBENCH_TABLE_SIZE \

# Run Sysbench Prepare Statement for MySQL8.0
export MYSQL_HOST="fill_up_with_MySQL8.0_writer"

# Drop and Recreate Database
mysql_command "DROP DATABASE IF EXISTS $SYSBENCH_DB;"
mysql_command "CREATE DATABASE $SYSBENCH_DB;"

sysbench oltp_read_only prepare \
--threads=$SYSBENCH_THREADS \
--db-driver=mysql \
--mysql-host=$MYSQL_HOST \
--mysql-port=$PORT \
--mysql-user=$MYSQL_USER \
--mysql-password=$MYSQL_PASSWORD \
--mysql-db=$SYSBENCH_DB \
--tables=$SYSBENCH_NUM_TABLES \
--table-size=$SYSBENCH_TABLE_SIZE \

