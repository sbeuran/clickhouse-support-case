CREATE DATABASE IF NOT EXISTS test;

CREATE TABLE IF NOT EXISTS test.support_engineers
(
    name String,
    id UInt32,
    team UInt32
) ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE IF NOT EXISTS test.cases_assigned
(
    case_id UInt64,
    engineer_id UInt32,
    assigned_date Date
) ENGINE = MergeTree()
ORDER BY (engineer_id, assigned_date); 