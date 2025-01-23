-- Example query for management
-- Description: Direct reporting relationships between engineers and managers

WITH managers AS (
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
FORMAT Pretty;
