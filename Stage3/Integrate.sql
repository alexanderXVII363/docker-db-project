-- ============================================================
-- Integrate.sql
-- Stage 3 - Integration of Ticket & Visitor Management System
-- with Zoo Admin Project Management System
-- ============================================================

-- ============================================================
-- STEP 1: Create the other team's tables
-- ============================================================

CREATE TABLE IF NOT EXISTS manager (
    manager_id      INT           PRIMARY KEY,
    first_name      VARCHAR(50)   NOT NULL,
    last_name       VARCHAR(50)   NOT NULL,
    email           VARCHAR(100)  NOT NULL UNIQUE,
    phone           VARCHAR(20)   NOT NULL,
    hire_date       DATE          NOT NULL,
    seniority_level VARCHAR(30)   NOT NULL
);

CREATE TABLE IF NOT EXISTS project (
    project_id   INT            PRIMARY KEY,
    project_name VARCHAR(100)   NOT NULL,
    description  VARCHAR(255)   NOT NULL,
    start_date   DATE           NOT NULL,
    end_date     DATE           NOT NULL,
    budget       NUMERIC(12,2)  NOT NULL CHECK (budget >= 0),
    status       VARCHAR(30)    NOT NULL,
    manager_id   INT            NOT NULL,
    CONSTRAINT fk_project_manager FOREIGN KEY (manager_id) REFERENCES manager(manager_id),
    CONSTRAINT chk_project_dates  CHECK (end_date >= start_date)
);

CREATE TABLE IF NOT EXISTS task (
    task_id     INT           PRIMARY KEY,
    task_name   VARCHAR(100)  NOT NULL,
    description VARCHAR(255)  NOT NULL,
    due_date    DATE          NOT NULL,
    priority    VARCHAR(20)   NOT NULL CHECK (priority IN ('Low', 'Medium', 'High')),
    status      VARCHAR(30)   NOT NULL CHECK (status IN ('Open', 'In Progress', 'Completed', 'Cancelled')),
    project_id  INT           NOT NULL,
    CONSTRAINT fk_task_project FOREIGN KEY (project_id) REFERENCES project(project_id)
);

CREATE TABLE IF NOT EXISTS report (
    report_id       INT           PRIMARY KEY,
    report_name     VARCHAR(100)  NOT NULL,
    report_date     DATE          NOT NULL,
    department_name VARCHAR(100)  NOT NULL,
    report_type     VARCHAR(50)   NOT NULL,
    summary         VARCHAR(255)  NOT NULL,
    manager_id      INT           NOT NULL,
    CONSTRAINT fk_report_manager FOREIGN KEY (manager_id) REFERENCES manager(manager_id)
);

CREATE TABLE IF NOT EXISTS kpi (
    kpi_id           INT            PRIMARY KEY,
    kpi_name         VARCHAR(100)   NOT NULL,
    department_name  VARCHAR(100)   NOT NULL,
    target_value     NUMERIC(10,2)  NOT NULL CHECK (target_value >= 0),
    actual_value     NUMERIC(10,2)  NOT NULL CHECK (actual_value >= 0),
    measurement_date DATE           NOT NULL,
    unit             VARCHAR(30)    NOT NULL,
    project_id       INT            NOT NULL,
    CONSTRAINT fk_kpi_project FOREIGN KEY (project_id) REFERENCES project(project_id)
);

CREATE TABLE IF NOT EXISTS audit (
    audit_id        INT           PRIMARY KEY,
    audit_date      DATE          NOT NULL,
    department_name VARCHAR(100)  NOT NULL,
    finding         VARCHAR(255)  NOT NULL,
    severity        VARCHAR(20)   NOT NULL CHECK (severity IN ('Low', 'Medium', 'High', 'Critical')),
    status          VARCHAR(30)   NOT NULL CHECK (status IN ('Open', 'In Review', 'Closed')),
    manager_id      INT           NOT NULL,
    project_id      INT           NOT NULL,
    CONSTRAINT fk_audit_manager FOREIGN KEY (manager_id) REFERENCES manager(manager_id),
    CONSTRAINT fk_audit_project FOREIGN KEY (project_id) REFERENCES project(project_id)
);


-- ============================================================
-- STEP 2: Insert the other team's data
-- ============================================================

INSERT INTO manager (manager_id, first_name, last_name, email, phone, hire_date, seniority_level) VALUES
(1, 'Noa',  'Levi',  'noa.levi@example.com',  '0501234567', '2021-03-10', 'Senior'),
(2, 'Dan',  'Cohen', 'dan.cohen@example.com',  '0529876543', '2020-06-15', 'Mid'),
(3, 'Maya', 'Aviv',  'maya.aviv@example.com',  '0534567890', '2022-01-20', 'Junior')
ON CONFLICT DO NOTHING;

INSERT INTO project (project_id, project_name, description, start_date, end_date, budget, status, manager_id) VALUES
(101, 'Zoo Expansion',            'Expansion of animal habitats',         '2024-01-01', '2024-12-31', 250000.00, 'Active',   1),
(102, 'Visitor Analytics',        'Improving visitor flow analysis',       '2024-02-01', '2024-10-31', 120000.00, 'Planning', 2),
(103, 'Food Supply Optimization', 'Optimization of animal food logistics', '2024-03-01', '2024-11-30',  80000.00, 'Active',   3)
ON CONFLICT DO NOTHING;

INSERT INTO task (task_id, task_name, description, due_date, priority, status, project_id) VALUES
(1001, 'Design habitats', 'Prepare initial habitat design',            '2024-03-15', 'High',   'Open',        101),
(1002, 'Install sensors', 'Install movement sensors in visitor areas', '2024-04-01', 'Medium', 'In Progress', 102),
(1003, 'Map suppliers',   'Create supplier map and logistics routes',  '2024-05-10', 'Low',    'Completed',   103)
ON CONFLICT DO NOTHING;

INSERT INTO report (report_id, report_name, report_date, department_name, report_type, summary, manager_id) VALUES
(201, 'Monthly Operations',    '2024-03-31', 'Operations', 'Monthly',     'Monthly management summary',    1),
(202, 'Visitor Trends',        '2024-03-31', 'Analytics',  'Performance', 'Visitor trend analysis',        2),
(203, 'Food Logistics Report', '2024-03-31', 'Logistics',  'Monthly',     'Food supply efficiency report', 3)
ON CONFLICT DO NOTHING;

INSERT INTO kpi (kpi_id, kpi_name, department_name, target_value, actual_value, measurement_date, unit, project_id) VALUES
(301, 'Completion Rate',      'Operations', 90.00, 82.00, '2024-03-31', 'Percent', 101),
(302, 'Visitor Satisfaction', 'Analytics',  95.00, 91.50, '2024-03-31', 'Percent', 102),
(303, 'Delivery Accuracy',    'Logistics',  98.00, 96.20, '2024-03-31', 'Percent', 103)
ON CONFLICT DO NOTHING;

INSERT INTO audit (audit_id, audit_date, department_name, finding, severity, status, manager_id, project_id) VALUES
(401, '2024-04-10', 'Operations', 'Minor delay in implementation',  'Medium', 'Open',      1, 101),
(402, '2024-04-12', 'Analytics',  'Incomplete reporting procedure', 'High',   'In Review', 2, 102),
(403, '2024-04-15', 'Logistics',  'Stock count mismatch found',     'Low',    'Closed',    3, 103)
ON CONFLICT DO NOTHING;


-- ============================================================
-- STEP 3: Link the two systems
-- Add manager_id to employees table
-- ============================================================

ALTER TABLE employees
ADD COLUMN IF NOT EXISTS manager_id INT;

ALTER TABLE employees
DROP CONSTRAINT IF EXISTS fk_emp_manager;

ALTER TABLE employees
ADD CONSTRAINT fk_emp_manager
    FOREIGN KEY (manager_id) REFERENCES manager(manager_id);

-- Link employees to managers
UPDATE employees SET manager_id = 1 WHERE employee_id BETWEEN 1   AND 166;
UPDATE employees SET manager_id = 2 WHERE employee_id BETWEEN 167 AND 333;
UPDATE employees SET manager_id = 3 WHERE employee_id BETWEEN 334 AND 500;


-- ============================================================
-- STEP 4: Verify row counts
-- ============================================================
SELECT 'employees'         AS table_name, COUNT(*) FROM employees
UNION ALL SELECT 'visitors',              COUNT(*) FROM visitors
UNION ALL SELECT 'ticket_types',          COUNT(*) FROM ticket_types
UNION ALL SELECT 'transactions',          COUNT(*) FROM transactions
UNION ALL SELECT 'transaction_items',     COUNT(*) FROM transaction_items
UNION ALL SELECT 'memberships',           COUNT(*) FROM memberships
UNION ALL SELECT 'manager',               COUNT(*) FROM manager
UNION ALL SELECT 'project',               COUNT(*) FROM project
UNION ALL SELECT 'task',                  COUNT(*) FROM task
UNION ALL SELECT 'report',                COUNT(*) FROM report
UNION ALL SELECT 'kpi',                   COUNT(*) FROM kpi
UNION ALL SELECT 'audit',                 COUNT(*) FROM audit;