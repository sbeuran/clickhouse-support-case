#!/bin/bash
docker exec -it clickhouse-server clickhouse-client --user user_analytics --password password --query "
SELECT engine, name, database, total_rows 
FROM system.tables 
WHERE engine = 'MergeTree'
LIMIT 10
FORMAT Pretty;
" 