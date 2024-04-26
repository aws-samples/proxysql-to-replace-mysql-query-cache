#!/bin/bash
: '
This script initialises the ProxySQL Server and Aurora MySQL 8.0 Database with the necessary ProxySQL permissions and settings.

Most notably, you will need to fill in the following parameters in the script. The writer and reader endpoints should point to Aurora MySQL 8.0, and they can be found in the CloudFormation Outputs section. The Admin user and password should be set according to best practices. In the recommended demo, we have set it to default to `MYSQL_ADMIN_USER=admin` and `MYSQL_ADMIN_PASSWORD=mysqladmin`.
    ```
    WRITER_ENDPOINT="fill_up_with_MySQL8.0_writer" 
    READER_ENDPOINT="fill_up_with_MySQL8.0_reader" 
    MYSQL_ADMIN_USER="fill_up"
    MYSQL_ADMIN_PASSWORD="fill_up"
    ```

If you are unsure if ProxySQL is connected, you can run the following commands in the script. These commands provide us insight as to whether the ProxySQL-Aurora integration has been correctly setup. Look at the ProxySQL documentation if more help is needed:
    ```
    execute_proxysql_command "SELECT * FROM monitor.mysql_server_connect_log ORDER BY time_start_us DESC LIMIT 3;"
    execute_proxysql_command "SELECT * FROM monitor.mysql_server_ping_log ORDER BY time_start_us DESC LIMIT 3;"
    ```
'

# Proxysql variables
export PROXY_ADMIN_USER="admin"
export PROXY_ADMIN_PASSWORD="admin"
export MONITOR_USERNAME="monitor"
export MONITOR_PASSWORD="monitor"
export PROXYSQL_USER="stnduser"
export PROXYSQL_PASSWORD="stnduser"

# Aurora Cluster variables
export WRITER_ENDPOINT="fill_up_with_MySQL8.0_writer" 
export READER_ENDPOINT="fill_up_with_MySQL8.0_reader" 
export MYSQL_ADMIN_USER="fill_up"
export MYSQL_ADMIN_PASSWORD="fill_up"

export SYSBENCH_DB="sbtest"


execute_proxysql_command() {
    mysql -u$PROXY_ADMIN_USER -p$PROXY_ADMIN_PASSWORD -h 127.0.0.1 -P6032  -e "$1"
}

execute_mysql_command() {
    mysql -u$MYSQL_ADMIN_USER -p$MYSQL_ADMIN_PASSWORD -h $WRITER_ENDPOINT -e "$1"
}

export -f execute_proxysql_command
export -f execute_mysql_command


# Create Appropriate users in mysql
execute_mysql_command "CREATE USER '$PROXYSQL_USER'@'%' IDENTIFIED BY '$PROXYSQL_PASSWORD';"
execute_mysql_command "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, PROCESS, INDEX, ALTER, CREATE VIEW ON *.* TO '$PROXYSQL_USER'@'%';"
execute_mysql_command "GRANT ALL PRIVILEGES ON $SYSBENCH_DB.* TO '$PROXYSQL_USER'@'%';"
execute_mysql_command "CREATE USER '$MONITOR_USERNAME'@'%' IDENTIFIED BY '$MONITOR_PASSWORD';"
execute_mysql_command "GRANT USAGE, REPLICATION CLIENT ON *.* TO '$MONITOR_USERNAME'@'%';"

execute_proxysql_command "INSERT INTO mysql_servers (hostname,hostgroup_id,port,weight,max_connections) VALUES ('$WRITER_ENDPOINT',10,3306,1000,2000);"
execute_proxysql_command "INSERT INTO mysql_servers (hostname,hostgroup_id,port,weight,max_connections) VALUES ('$READER_ENDPOINT',20,3306,1000,2000);"
execute_proxysql_command "UPDATE global_variables SET variable_value='$MONITOR_USERNAME' WHERE variable_name='mysql-monitor_username';"
execute_proxysql_command "UPDATE global_variables SET variable_value='$MONITOR_PASSWORD' WHERE variable_name='mysql-monitor_password';"
execute_proxysql_command "INSERT INTO mysql_query_rules (rule_id,active,match_digest,destination_hostgroup,apply) VALUES (50,1,'^SELECT.*FOR UPDATE$',10,1), (51,1,'^SELECT',20,1);"
execute_proxysql_command "UPDATE mysql_query_rules set cache_ttl=60000 where destination_hostgroup=20;" # MySQL Query Cache enabler
execute_proxysql_command "CREATE USER '$PROXYSQL_USER'@'%' IDENTIFIED BY '$PROXYSQL_PASSWORD';"
execute_proxysql_command "GRANT SELECT, INSERT, UPDATE, DELETE, PROCESS, CREATE ON *.* TO '$PROXYSQL_USER'@'%';"
execute_proxysql_command "INSERT INTO mysql_users (username,password,default_hostgroup) VALUES ('$PROXYSQL_USER','$PROXYSQL_PASSWORD',10);"
execute_proxysql_command "LOAD MYSQL VARIABLES TO RUNTIME; SAVE MYSQL VARIABLES TO DISK;"
execute_proxysql_command "LOAD MYSQL USERS TO RUNTIME; SAVE MYSQL USERS TO DISK;"
execute_proxysql_command "LOAD MYSQL SERVERS TO RUNTIME; SAVE MYSQL SERVERS TO DISK;"
execute_proxysql_command "LOAD MYSQL QUERY RULES TO RUNTIME; SAVE MYSQL QUERY RULES TO DISK;"

execute_proxysql_command "SELECT * FROM monitor.mysql_server_connect_log ORDER BY time_start_us DESC LIMIT 3;"
execute_proxysql_command "SELECT * FROM monitor.mysql_server_ping_log ORDER BY time_start_us DESC LIMIT 3;"
