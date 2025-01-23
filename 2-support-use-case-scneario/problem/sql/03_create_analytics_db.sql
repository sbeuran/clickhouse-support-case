CREATE DATABASE IF NOT EXISTS analytics;

CREATE TABLE analytics.test
(
    "name" String,
    "id" UInt32
)
ENGINE = MergeTree()
ORDER BY (id);

-- Create role and user with row policy
CREATE ROLE role_analytics 
SETTINGS log_profile_events = 1 READONLY, 
         log_queries = 1 READONLY, 
         log_query_settings = 1 READONLY, 
         log_query_threads = 1 READONLY;

CREATE USER user_analytics IDENTIFIED WITH plaintext_password BY 'password' 
DEFAULT ROLE role_analytics;

CREATE ROW POLICY user_analytics_filter ON system.tables 
FOR SELECT USING database = 'analytics' TO user_analytics;

-- Create a problematic view that doesn't store data
CREATE VIEW IF NOT EXISTS analytics.engineer_case_stats
AS SELECT
    engineer_id,
    assigned_date as date,
    count() as cases_assigned,
    any(team) as team
FROM test.cases_assigned
LEFT JOIN test.support_engineers ON cases_assigned.engineer_id = support_engineers.id
GROUP BY engineer_id, assigned_date; 