SHOW VARIABLES LIKE 'mysql-query_cache%';
SHOW VARIABLES LIKE 'mysql-th%';
SHOW VARIABLES LIKE 'mysql%';
SELECT * FROM stats_mysql_global WHERE Variable_Name LIKE 'Query_Cache%';
SELECT count_star,sum_time,hostgroup,digest,digest_text FROM stats_mysql_query_digest ORDER BY sum_time DESC LIMIT 10;
select * from mysql_query_rules\G;
select * from stats_mysql_query_digest_reset limit 1;