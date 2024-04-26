#!/bin/bash

# ProxySQL Parameters
export MYSQL_USER="stnduser"
export MYSQL_PASSWORD="stnduser"
export MYSQL_HOST="NLB_endpoint_or_proxysql_instance_ipaddress"
export PORT=3306

# Sysbench Parameters
export SYSBENCH_DB="sbtest"
export SYSBENCH_THREADS=16
export SYSBENCH_NUM_TABLES=16
export SYSBENCH_TABLE_SIZE=1000000

sysbench oltp_read_only run \
--report-interval=5 \
--table-size=$SYSBENCH_TABLE_SIZE \
--mysql-host=$MYSQL_HOST \
--mysql-port=$PORT \
--mysql-user=$MYSQL_USER \
--mysql-password=$MYSQL_PASSWORD \
--mysql-db=$SYSBENCH_DB \
--tables=1 \
--time=300 \
--warmup-time=300 \
--threads=128 \
--skip_trx=on \
--db-ps-mode=disable \
--histogram=on \
# --mysql-ignore-errors=2013,2003,1290,1213 \
# --reconnect=1000 \

