# SQL Queries Documentation

## Overview
This folder contains SQL queries organized into three categories to analyze support engineer case assignments and team performance.

### Folder Structure
```
1-sql-queries/
├── basic-metrics/        # Basic performance and workload metrics
├── management/          # Team structure and reporting relationships
├── team-performance/    # Detailed team and individual performance analysis
└── README.md           # This file
```

## Query Categories

### Basic Metrics
Contains queries for fundamental metrics like:
- Total cases handled by each engineer
- Weekly case distribution
- Case assignment trends

### Management
Contains queries related to team structure:
- Reporting relationships between engineers and managers
- Team size and composition
- Manager-wise case distribution

### Team Performance
Contains queries for detailed performance analysis:
- Daily workload distribution across teams
- Engineer efficiency metrics
- Case handling patterns

## How to Run

1. Execute all queries:
   ```bash
   ./run_all_queries.sh
   ```
   This will run each query and show the results in the terminal.

2. Generate documentation:
   ```bash
   ./document_queries.sh
   ```
   This creates detailed documentation with query results.

3. View results:
   Check `1-sql-queries/query_documentation.md` for:
   - Query descriptions
   - SQL code
   - Execution results
   - Performance analysis

## Data Source
The queries are based on two main tables:
- `support_engineers`: Engineer and manager information
- `cases_assigned`: Case assignment details

For the complete database schema and sample data, see the table creation scripts in the repository. 