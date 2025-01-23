# ClickHouse Support Engineer Case Assignment

## Overview
This project contains a comprehensive analysis of support engineer case assignments in ClickHouse, including SQL queries for performance analysis and a detailed support use case scenario with solution.

## Project Structure
```
.
├── 1-sql-queries/               # SQL analysis queries
│   ├── basic-metrics/          # Basic performance metrics
│   ├── management/             # Team structure queries
│   ├── team-performance/       # Detailed performance analysis
│   └── README.md              # SQL queries documentation
│
├── 2-support-use-case-scenario/ # Support case analysis
│   ├── problem/               # Issue reproduction
│   │   ├── run_query.sh
│   │   ├── setup.sh
│   │   └── sql/
│   ├── solution/              # Problem solution
│   │   ├── run_query.sh
│   │   ├── setup.sh
│   │   └── sql/
│   └── README.md             # Case documentation
│
├── scripts/                    # Utility scripts
│   ├── document_queries.sh   # Query results formatter
│   └── run_all_queries.sh    # Query execution script
│
└── README.md                  # This file
```

## Components

### 1. SQL Queries (1-sql-queries/)
Contains analytical SQL queries organized into three categories:
- Basic metrics for case assignments
- Management reporting and team structure
- Team performance analysis

Each query is documented with description, code, and example results.

### 2. Support Use Case Scenario (2-support-use-case-scenario/)
Contains a complete analysis of a ClickHouse row policy issue:
- Problem reproduction steps
- Root cause analysis
- Solution implementation
- Verification steps
- Customer communication

### 3. Scripts (scripts/)
Utility scripts for:
- Running all SQL queries
- Formatting query results

## Getting Started

1. Run SQL analysis:
   ```bash
   cd scripts
   ./run_all_queries.sh
   ```

2. Format query results:
   ```bash
   cd scripts
   ./document_queries.sh
   ```

3. Check results:
   - SQL analysis: `1-sql-queries/query_documentation.md`
   - Support case: `2-support-use-case-scenario/README.md`

## Documentation
- SQL Queries: See `1-sql-queries/README.md`
- Support Case: See `2-support-use-case-scenario/README.md`
- Query Results: See `1-sql-queries/query_documentation.md` 