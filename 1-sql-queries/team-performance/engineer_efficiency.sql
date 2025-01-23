-- Example query for team-performance
-- Description: Engineer performance metrics

WITH managers AS (
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
FORMAT Pretty;
