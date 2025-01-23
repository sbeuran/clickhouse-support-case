CREATE DATABASE IF NOT EXISTS analytics;

-- Create an optimized materialized view with better performance
CREATE MATERIALIZED VIEW IF NOT EXISTS analytics.engineer_case_stats
ENGINE = SummingMergeTree()
ORDER BY (engineer_id, date)
POPULATE
AS SELECT
    engineer_id,
    assigned_date as date,
    count() as cases_assigned,
    any(team) as team
FROM test.cases_assigned
LEFT JOIN test.support_engineers ON cases_assigned.engineer_id = support_engineers.id
GROUP BY engineer_id, assigned_date
SETTINGS join_algorithm = 'partial_merge'; 