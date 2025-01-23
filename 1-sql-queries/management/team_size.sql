-- Example query for management
-- Description: Number of direct reports per manager

WITH managers AS (
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
FORMAT Pretty;
