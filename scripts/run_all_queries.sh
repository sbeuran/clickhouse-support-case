#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Setup tables and data
setup_database() {
    echo -e "${BLUE}Setting up database and tables...${NC}"
    
    docker exec -i clickhouse-server clickhouse-client --multiquery <<-EOSQL
    CREATE TABLE IF NOT EXISTS support_engineers
    (
        name String,
        id UInt8,
        manager_id Nullable(UInt8)
    )
    ENGINE = Memory;

    CREATE TABLE IF NOT EXISTS cases_assigned
    (
        case_number Nullable(String),
        assignee_id UInt8,
        date Date
    )
    ENGINE = Memory;

    -- Insert sample data
    INSERT INTO support_engineers VALUES ('Sante', 2, 1);
    INSERT INTO support_engineers VALUES ('Konsta', 3, 1);
    INSERT INTO support_engineers VALUES ('Camilo', 1, 5);
    INSERT INTO support_engineers VALUES ('Derek', 4, 5);
    INSERT INTO support_engineers VALUES ('Thom', 5, NULL);

    INSERT INTO cases_assigned VALUES ('1330441851', 1, '2023-12-15');
    INSERT INTO cases_assigned VALUES ('1330541851', 1, '2023-12-16');
    INSERT INTO cases_assigned VALUES ('1330549851', 1, '2023-12-22');
    INSERT INTO cases_assigned VALUES ('1330641851', 2, '2023-12-16');
    INSERT INTO cases_assigned VALUES ('1330741851', 2, '2023-12-17');
    INSERT INTO cases_assigned VALUES ('1330841851', 3, '2023-12-18');
    INSERT INTO cases_assigned VALUES ('1330941851', 3, '2023-12-18');
    INSERT INTO cases_assigned VALUES ('1331841851', 3, '2023-12-20');
    INSERT INTO cases_assigned VALUES ('1334941851', 3, '2023-12-21');
    INSERT INTO cases_assigned VALUES ('1341841851', 3, '2023-12-20');
    INSERT INTO cases_assigned VALUES ('1354941851', 3, '2023-12-21');
    INSERT INTO cases_assigned VALUES ('1330431851', 4, '2023-12-19');
EOSQL

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Database setup completed successfully${NC}"
    else
        echo -e "${RED}✗ Database setup failed${NC}"
        exit 1
    fi
}

# Function to run a query and format output
run_query() {
    local file=$1
    echo -e "${BLUE}Running query from: ${file}${NC}"
    echo -e "${BLUE}Query:${NC}"
    cat "$file"
    echo -e "\n${BLUE}Result:${NC}"
    
    # Run the query through clickhouse-client
    docker exec -i clickhouse-server clickhouse-client --multiquery < "$file"
    
    # Check if query was successful
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Query executed successfully${NC}"
    else
        echo -e "${RED}✗ Query failed${NC}"
    fi
    echo -e "\n----------------------------------------\n"
}

# Main script
echo "Starting to run all SQL queries..."

# Setup database first
setup_database

# Find all .sql files and sort them by directory and name
find 1-sql-queries -name "*.sql" | sort | while read -r file; do
    # Extract directory name for section header
    dir=$(dirname "$file" | xargs basename)
    
    # Print section header
    echo -e "\n${BLUE}=== Executing queries in ${dir} ===${NC}\n"
    
    # Run the query
    run_query "$file"
done

echo "Finished running all queries." 