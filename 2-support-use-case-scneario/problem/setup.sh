#!/bin/bash

# Remove existing container if it exists
echo "Removing existing clickhouse-server container..."
docker rm -f clickhouse-server || true

# Start a new container
echo "Starting new clickhouse-server container..."
docker run -d --name clickhouse-server --ulimit nofile=262144:262144 clickhouse/clickhouse-server
container_id=$(docker ps -q -f name=clickhouse-server)

# Wait for ClickHouse to start
echo "Waiting for ClickHouse to start..."
sleep 5

# Clean up existing databases
echo "Cleaning up existing databases..."
docker exec -i clickhouse-server clickhouse-client --query "
DROP DATABASE IF EXISTS test;
DROP DATABASE IF EXISTS analytics;
"

# Execute SQL scripts in order
for script in sql/*.sql; do
    echo "Running $(basename $script)..."
    docker exec -i clickhouse-server clickhouse-client --multiquery < "$script"
    if [ $? -eq 0 ]; then
        echo "✓ Successfully executed $(basename $script)"
    else
        echo "✗ Failed to execute $(basename $script)"
        exit 1
    fi
done

# Verify setup
echo "Verifying setup..."
docker exec -it clickhouse-server clickhouse-client --multiquery "
SELECT 'Support Engineers' as title FORMAT Pretty;
SELECT * FROM test.support_engineers FORMAT Pretty;

SELECT 'Cases Assigned' as title FORMAT Pretty;
SELECT * FROM test.cases_assigned FORMAT Pretty;

SELECT 'Materialized View' as title FORMAT Pretty;
SELECT * FROM analytics.engineer_case_stats FORMAT Pretty;
"

echo "Setup complete with problem scenario!" 