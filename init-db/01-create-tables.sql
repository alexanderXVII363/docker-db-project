-- ============================================================
-- 01-create-tables.sql
-- Creates all tables for the Zoo Ticket & Visitor Management System
-- Executed automatically by PostgreSQL on first container start
-- ============================================================

-- Drop tables if they exist (in reverse dependency order)
DROP TABLE IF EXISTS transaction_items CASCADE;
DROP TABLE IF EXISTS memberships      CASCADE;
DROP TABLE IF EXISTS transactions     CASCADE;
DROP TABLE IF EXISTS ticket_types     CASCADE;
DROP TABLE IF EXISTS visitors         CASCADE;
DROP TABLE IF EXISTS employees        CASCADE;

-- ============================================================
-- 1. EMPLOYEES
-- ============================================================
CREATE TABLE employees (
    employee_id   INT          NOT NULL,
    first_name    VARCHAR(20)  NOT NULL,
    last_name     VARCHAR(20)  NOT NULL,
    hire_date     DATE         NOT NULL,
    PRIMARY KEY (employee_id)
);

-- ============================================================
-- 2. VISITORS
-- ============================================================
CREATE TABLE visitors (
    visitor_id        INT          NOT NULL,
    first_name        VARCHAR(20)  NOT NULL,
    last_name         VARCHAR(20)  NOT NULL,
    phone             VARCHAR(20)  NOT NULL,
    date_of_birth     DATE         NOT NULL,
    email             VARCHAR(50)  NOT NULL,
    registration_date DATE         NOT NULL,
    PRIMARY KEY (visitor_id)
);

-- ============================================================
-- 3. TICKET_TYPES
-- ============================================================
CREATE TABLE ticket_types (
    ticket_id    INT            NOT NULL,
    ticket_name  VARCHAR(100)   NOT NULL,
    max_capacity INT            NOT NULL,
    base_price   NUMERIC(10,2)  NOT NULL,
    category     VARCHAR(50)    NOT NULL,
    PRIMARY KEY (ticket_id)
);

-- ============================================================
-- 4. TRANSACTIONS  (references employees, visitors)
-- ============================================================
CREATE TABLE transactions (
    transaction_id   INT            NOT NULL,
    transaction_date DATE           NOT NULL,
    total_amount     NUMERIC(10,2)  NOT NULL,
    payment_method   VARCHAR(50)    NOT NULL,
    employee_id      INT            NOT NULL,
    visitor_id       INT            NOT NULL,
    PRIMARY KEY (transaction_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (visitor_id)  REFERENCES visitors(visitor_id)
);

-- ============================================================
-- 5. TRANSACTION_ITEMS  (references transactions, ticket_types)
-- ============================================================
CREATE TABLE transaction_items (
    item_id        INT            NOT NULL,
    quantity       INT            NOT NULL,
    price_at_sale  NUMERIC(10,2)  NOT NULL,
    transaction_id INT            NOT NULL,
    ticket_id      INT            NOT NULL,
    PRIMARY KEY (item_id, transaction_id),
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id),
    FOREIGN KEY (ticket_id)      REFERENCES ticket_types(ticket_id)
);

-- ============================================================
-- 6. MEMBERSHIPS  (references visitors)
-- ============================================================
CREATE TABLE memberships (
    membership_id INT  NOT NULL,
    start_date    DATE NOT NULL,
    expiry_date   DATE NOT NULL,
    visitor_id    INT  NOT NULL,
    PRIMARY KEY (membership_id),
    FOREIGN KEY (visitor_id) REFERENCES visitors(visitor_id)
);

-- ============================================================
-- INDEXES  (for common query patterns)
-- ============================================================
CREATE INDEX idx_visitors_last_name    ON visitors(last_name);
CREATE INDEX idx_transactions_date     ON transactions(transaction_date);
CREATE INDEX idx_transactions_visitor  ON transactions(visitor_id);
CREATE INDEX idx_memberships_visitor   ON memberships(visitor_id);
CREATE INDEX idx_transaction_items_txn ON transaction_items(transaction_id);