SET mysql-query_cache_size_MB=4096;
SET mysql-max_allowed_packet=4194304;
SET mysql-threshold_resultset_size=64*1024*1024;
update mysql_query_rules set cache_ttl=300000 where rule_id=51;
LOAD MYSQL VARIABLES TO RUNTIME;
LOAD MYSQL QUERY RULES TO RUNTIME;
SAVE MYSQL VARIABLES TO DISK;
SAVE MYSQL QUERY RULES TO DISK;
PROXYSQL FLUSH QUERY CACHE;
SET mysql-threads=4; # Do not set very high threads
SAVE MYSQL VARIABLES TO DISK;
PROXYSQL RESTART;