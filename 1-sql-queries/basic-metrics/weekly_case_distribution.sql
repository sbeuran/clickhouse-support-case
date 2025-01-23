-- Example query for basic-metrics
-- Description: Weekly case load distribution per engineer

SELECT 
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
FORMAT Pretty;
