-- Example query for basic-metrics
-- Description: Total cases handled by each engineer

SELECT 
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
FORMAT Pretty;
