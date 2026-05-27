-- ============================================================
-- Views.sql
-- Stage 3 - Views for the integrated database
-- ============================================================

-- ============================================================
-- VIEW 1: view_employee_manager
-- Our system's perspective — employees linked to their managers
-- This view joins our employees table with the other team's
-- manager and project tables, showing each employee alongside
-- their manager's details and the project they are responsible for.
-- ============================================================

CREATE OR REPLACE VIEW view_employee_manager AS
SELECT
    e.employee_id,
    e.first_name        AS employee_first_name,
    e.last_name         AS employee_last_name,
    e.hire_date,
    m.manager_id,
    m.first_name        AS manager_first_name,
    m.last_name         AS manager_last_name,
    m.seniority_level,
    p.project_name,
    p.status            AS project_status,
    p.budget
FROM employees e
JOIN manager m ON e.manager_id = m.manager_id
JOIN project p ON p.manager_id = m.manager_id;


-- ------------------------------------------------------------
-- Query 1.1: Number of employees per manager
-- This query shows how many employees each manager supervises,
-- along with their seniority level. Useful for understanding
-- the management load and team sizes across the organization.
-- ------------------------------------------------------------
SELECT
    manager_first_name || ' ' || manager_last_name AS manager_name,
    seniority_level,
    COUNT(DISTINCT employee_id) AS total_employees
FROM view_employee_manager
GROUP BY manager_name, seniority_level
ORDER BY total_employees DESC;


-- ------------------------------------------------------------
-- Query 1.2: Recently hired employees and their manager's project
-- This query returns all employees hired after January 2022,
-- showing which manager they report to and which project
-- that manager is currently running. Useful for onboarding
-- reports and project staffing overview.
-- ------------------------------------------------------------
SELECT
    employee_first_name || ' ' || employee_last_name AS employee_name,
    hire_date,
    manager_first_name || ' ' || manager_last_name   AS manager_name,
    project_name,
    project_status
FROM view_employee_manager
WHERE hire_date >= '2022-01-01'
ORDER BY hire_date DESC;


-- ============================================================
-- VIEW 2: view_project_transactions
-- Other team's perspective — projects linked to transactions
-- This view connects the other team's project management system
-- with our ticketing system. It shows how visitor transactions
-- relate to active projects through the employee-manager link,
-- giving a full picture of revenue generated under each project.
-- ============================================================

CREATE OR REPLACE VIEW view_project_transactions AS
SELECT
    p.project_id,
    p.project_name,
    p.status            AS project_status,
    p.budget,
    m.first_name || ' ' || m.last_name AS manager_name,
    m.seniority_level,
    e.employee_id,
    e.first_name        AS employee_first_name,
    e.last_name         AS employee_last_name,
    t.transaction_id,
    t.transaction_date,
    t.total_amount,
    t.payment_method,
    v.first_name        AS visitor_first_name,
    v.last_name         AS visitor_last_name
FROM project p
JOIN manager m      ON m.manager_id     = p.manager_id
JOIN employees e    ON e.manager_id     = m.manager_id
JOIN transactions t ON t.employee_id    = e.employee_id
JOIN visitors v     ON v.visitor_id     = t.visitor_id;


-- ------------------------------------------------------------
-- Query 2.1: Total revenue per project
-- This query calculates the total number of transactions and
-- total revenue generated under each project, by tracing
-- which employees handled the transactions and which manager
-- (and therefore which project) they belong to.
-- Useful for measuring the financial contribution of each project.
-- ------------------------------------------------------------
SELECT
    project_name,
    project_status,
    COUNT(transaction_id)   AS total_transactions,
    SUM(total_amount)       AS total_revenue
FROM view_project_transactions
GROUP BY project_name, project_status
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- Query 2.2: Average transaction amount per manager
-- This query shows the average transaction value handled by
-- employees under each manager, grouped by manager name and
-- seniority level. Useful for evaluating manager performance
-- and identifying which teams process higher-value transactions.
-- ------------------------------------------------------------
SELECT
    manager_name,
    seniority_level,
    COUNT(transaction_id)       AS total_transactions,
    ROUND(AVG(total_amount), 2) AS avg_transaction_amount
FROM view_project_transactions
GROUP BY manager_name, seniority_level
ORDER BY avg_transaction_amount DESC;