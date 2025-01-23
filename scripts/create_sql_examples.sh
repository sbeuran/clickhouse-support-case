#!/bin/bash

# Base directory for SQL queries
BASE_DIR="1-sql-queries"

# Create base directory
mkdir -p "$BASE_DIR"

# Function to create query file
create_query_file() {
    local dir=$1
    local type=$2
    local filename=$3
    local description=$4
    local query=$5
    
    mkdir -p "$dir"
    echo "-- Example query for ${type}
-- Description: ${description}

${query}" > "$dir/${filename}.sql"
}

# Basic Metrics Queries
create_query_file "$BASE_DIR/basic-metrics" "basic-metrics" "total_cases_by_engineer" \
"Total cases handled by each engineer" \
"SELECT 
    se.name as engineer_name,
    COUNT(DISTINCT ca.case_number) as total_cases,
    NULLIF(MIN(ca.date), '1970-01-01') as first_case,
    NULLIF(MAX(ca.date), '1970-01-01') as last_case
FROM support_engineers se
LEFT JOIN cases_assigned ca ON se.id = ca.assignee_id
WHERE se.id NOT IN (
    SELECT DISTINCT manager_id 
    FROM support_engineers 
    WHERE manager_id IS NOT NULL
)
GROUP BY se.name
ORDER BY total_cases DESC
FORMAT Pretty;"

create_query_file "$BASE_DIR/basic-metrics" "basic-metrics" "weekly_case_distribution" \
"Weekly case load distribution per engineer" \
"SELECT 
    se.name as engineer_name,
    toStartOfWeek(ca.date) as week_start,
    COUNT(DISTINCT ca.case_number) as weekly_cases
FROM support_engineers se
JOIN cases_assigned ca ON se.id = ca.assignee_id
WHERE se.id NOT IN (
    SELECT DISTINCT manager_id 
    FROM support_engineers 
    WHERE manager_id IS NOT NULL
)
GROUP BY se.name, toStartOfWeek(ca.date)
ORDER BY week_start DESC, weekly_cases DESC
FORMAT Pretty;"

# Management Queries
create_query_file "$BASE_DIR/management" "management" "reporting_structure" \
"Direct reporting relationships between engineers and managers" \
"WITH managers AS (
    SELECT DISTINCT m.id, m.name
    FROM support_engineers m
    JOIN support_engineers e ON e.manager_id = m.id
)
SELECT 
    se.name as engineer_name,
    m.name as manager_name,
    COUNT(DISTINCT ca.case_number) as total_cases
FROM support_engineers se
LEFT JOIN managers m ON se.manager_id = m.id
LEFT JOIN cases_assigned ca ON se.id = ca.assignee_id
WHERE se.id NOT IN (SELECT id FROM managers)
GROUP BY se.name, m.name
ORDER BY m.name NULLS FIRST, se.name
FORMAT Pretty;"

create_query_file "$BASE_DIR/management" "management" "team_size" \
"Number of direct reports per manager" \
"WITH managers AS (
    SELECT DISTINCT m.id, m.name
    FROM support_engineers m
    JOIN support_engineers e ON e.manager_id = m.id
)
SELECT 
    m.name as manager_name,
    COUNT(DISTINCT se.id) as team_size,
    arrayStringConcat(groupArray(DISTINCT se.name), ', ') as team_members
FROM managers m
JOIN support_engineers se ON se.manager_id = m.id
GROUP BY m.name
ORDER BY team_size DESC
FORMAT Pretty;"

# Team Performance
create_query_file "$BASE_DIR/team-performance" "team-performance" "daily_workload" \
"Daily case distribution across teams" \
"WITH managers AS (
    SELECT DISTINCT m.id, m.name
    FROM support_engineers m
    JOIN support_engineers e ON e.manager_id = m.id
)
SELECT 
    m.name as manager_name,
    se.name as engineer_name,
    ca.date,
    COUNT(DISTINCT ca.case_number) as daily_cases
FROM support_engineers se
JOIN managers m ON se.manager_id = m.id
JOIN cases_assigned ca ON se.id = ca.assignee_id
WHERE se.id NOT IN (SELECT id FROM managers)
GROUP BY m.name, se.name, ca.date
ORDER BY ca.date DESC, daily_cases DESC
FORMAT Pretty;"

create_query_file "$BASE_DIR/team-performance" "team-performance" "engineer_efficiency" \
"Engineer performance metrics" \
"WITH managers AS (
    SELECT DISTINCT m.id, m.name
    FROM support_engineers m
    JOIN support_engineers e ON e.manager_id = m.id
)
SELECT 
    se.name as engineer_name,
    m.name as manager_name,
    COUNT(DISTINCT ca.case_number) as total_cases,
    COUNT(DISTINCT ca.date) as active_days,
    ROUND(COUNT(DISTINCT ca.case_number) / COUNT(DISTINCT ca.date), 2) as cases_per_day
FROM support_engineers se
JOIN managers m ON se.manager_id = m.id
JOIN cases_assigned ca ON se.id = ca.assignee_id
WHERE se.id NOT IN (SELECT id FROM managers)
GROUP BY se.name, m.name
ORDER BY cases_per_day DESC
FORMAT Pretty;"

echo "Created SQL query examples in $BASE_DIR directory" 