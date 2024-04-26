#!/bin/bash

# MySQL Connection Details
export MYSQL_USER="fill_up"
export MYSQL_PASSWORD="fill_up"
export MYSQL_HOST="fill_up_with_MySQL80_writer_endpoint"
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
--threads=128 \
--skip_trx=on \
--db-ps-mode=disable \
--histogram=on \
# --warmup-time=300 \
# --mysql-ignore-errors=2013,2003,1290,1213 \
# --reconnect=1000 \

