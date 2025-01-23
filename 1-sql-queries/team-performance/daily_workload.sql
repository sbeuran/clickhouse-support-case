-- Example query for team-performance
-- Description: Daily case distribution across teams

WITH managers AS (
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
FORMAT Pretty;
