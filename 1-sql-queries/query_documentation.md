# SQL Query Documentation

## TEAM-PERFORMANCE

### daily_workload.sql
**Description:** Daily case distribution across teams

**Query:**
```sql
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

```

**Results:**

```
+----------------------------------------------------------------+
|  ┏━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━┳━━━━━━━━━━━━┳━━━━━━━━━━━━━┓   |
+----------------------------------------------------------------+
|    ┃ manager_name ┃ engineer_name ┃       date ┃ daily_cases ┃ |
|    ┡━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━╇━━━━━━━━━━━━╇━━━━━━━━━━━━━┩ |
| 1. │ Camilo       │ Konsta        │ 2023-12-21 │           2 │ |
|    ├──────────────┼───────────────┼────────────┼─────────────┤ |
| 2. │ Camilo       │ Konsta        │ 2023-12-20 │           2 │ |
|    ├──────────────┼───────────────┼────────────┼─────────────┤ |
| 3. │ Thom         │ Derek         │ 2023-12-19 │           1 │ |
|    ├──────────────┼───────────────┼────────────┼─────────────┤ |
| 4. │ Camilo       │ Konsta        │ 2023-12-18 │           2 │ |
|    ├──────────────┼───────────────┼────────────┼─────────────┤ |
| 5. │ Camilo       │ Sante         │ 2023-12-17 │           1 │ |
|    ├──────────────┼───────────────┼────────────┼─────────────┤ |
| 6. │ Camilo       │ Sante         │ 2023-12-16 │           1 │ |
|    └──────────────┴───────────────┴────────────┴─────────────┘ |
+----------------------------------------------------------------+
```

---

### engineer_efficiency.sql
**Description:** Engineer performance metrics

**Query:**
```sql
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

```

**Results:**

```
+---------------------------------------------------------------------------------+
|   ┏━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━┓  |
+---------------------------------------------------------------------------------+
|    ┃ engineer_name ┃ manager_name ┃ total_cases ┃ active_days ┃ cases_per_day ┃ |
|    ┡━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━╇━━━━━━━━━━━━━╇━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━┩ |
| 1. │ Konsta        │ Camilo       │           6 │           3 │             2 │ |
|    ├───────────────┼──────────────┼─────────────┼─────────────┼───────────────┤ |
| 2. │ Derek         │ Thom         │           1 │           1 │             1 │ |
|    ├───────────────┼──────────────┼─────────────┼─────────────┼───────────────┤ |
| 3. │ Sante         │ Camilo       │           2 │           2 │             1 │ |
|    └───────────────┴──────────────┴─────────────┴─────────────┴───────────────┘ |
+---------------------------------------------------------------------------------+
```

---

## MANAGEMENT

### reporting_structure.sql
**Description:** Direct reporting relationships between engineers and managers

**Query:**
```sql
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

```

**Results:**

```
+---------------------------------------------------+
|   ┏━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━┳━━━━━━━━━━━━━┓  |
+---------------------------------------------------+
|    ┃ engineer_name ┃ manager_name ┃ total_cases ┃ |
|    ┡━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━╇━━━━━━━━━━━━━┩ |
| 1. │ Konsta        │ Camilo       │           6 │ |
|    ├───────────────┼──────────────┼─────────────┤ |
| 2. │ Sante         │ Camilo       │           2 │ |
|    ├───────────────┼──────────────┼─────────────┤ |
| 3. │ Derek         │ Thom         │           1 │ |
|    └───────────────┴──────────────┴─────────────┘ |
+---------------------------------------------------+
```

---

### team_size.sql
**Description:** Number of direct reports per manager

**Query:**
```sql
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

```

**Results:**

```
+-------------------------------------------------+
|   ┏━━━━━━━━━━━━━━┳━━━━━━━━━━━┳━━━━━━━━━━━━━━━┓  |
+-------------------------------------------------+
|    ┃ manager_name ┃ team_size ┃ team_members  ┃ |
|    ┡━━━━━━━━━━━━━━╇━━━━━━━━━━━╇━━━━━━━━━━━━━━━┩ |
| 1. │ Thom         │         2 │ Derek, Camilo │ |
|    ├──────────────┼───────────┼───────────────┤ |
| 2. │ Camilo       │         2 │ Sante, Konsta │ |
|    └──────────────┴───────────┴───────────────┘ |
+-------------------------------------------------+
```

---

## BASIC-METRICS

### total_cases_by_engineer.sql
**Description:** Total cases handled by each engineer

**Query:**
```sql
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

```

**Results:**

```
+--------------------------------------------------------------+
|  ┏━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━┳━━━━━━━━━━━━┓   |
+--------------------------------------------------------------+
|    ┃ engineer_name ┃ total_cases ┃ first_case ┃  last_case ┃ |
|    ┡━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━╇━━━━━━━━━━━━╇━━━━━━━━━━━━┩ |
| 1. │ Konsta        │           6 │ 2023-12-18 │ 2023-12-21 │ |
|    ├───────────────┼─────────────┼────────────┼────────────┤ |
| 2. │ Sante         │           2 │ 2023-12-16 │ 2023-12-17 │ |
|    ├───────────────┼─────────────┼────────────┼────────────┤ |
| 3. │ Derek         │           1 │ 2023-12-19 │ 2023-12-19 │ |
|    └───────────────┴─────────────┴────────────┴────────────┘ |
+--------------------------------------------------------------+
```

---

### weekly_case_distribution.sql
**Description:** Weekly case load distribution per engineer

**Query:**
```sql
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

```

**Results:**

```
+--------------------------------------------------+
|  ┏━━━━━━━━━━━━━━━┳━━━━━━━━━━━━┳━━━━━━━━━━━━━━┓   |
+--------------------------------------------------+
|    ┃ engineer_name ┃ week_start ┃ weekly_cases ┃ |
|    ┡━━━━━━━━━━━━━━━╇━━━━━━━━━━━━╇━━━━━━━━━━━━━━┩ |
| 1. │ Konsta        │ 2023-12-17 │            6 │ |
|    ├───────────────┼────────────┼──────────────┤ |
| 2. │ Sante         │ 2023-12-17 │            1 │ |
|    ├───────────────┼────────────┼──────────────┤ |
| 3. │ Derek         │ 2023-12-17 │            1 │ |
|    ├───────────────┼────────────┼──────────────┤ |
| 4. │ Sante         │ 2023-12-10 │            1 │ |
|    └───────────────┴────────────┴──────────────┘ |
+--------------------------------------------------+
```

---

