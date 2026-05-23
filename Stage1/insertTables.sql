-- ============================================================
-- insertTables.sql
-- Demonstrates 3 different data insertion methods
-- ============================================================

-- ============================================================
-- METHOD 1: Manual SQL INSERT statements
-- Data inserted directly by writing SQL INSERT commands.
-- Used for small, controlled inserts to verify table structure
-- and test constraints during development.
-- ============================================================

INSERT INTO employees (employee_id, first_name, last_name, hire_date) VALUES
(1, 'John',    'Smith',  '2023-01-10'),
(2, 'Sara',    'Cohen',  '2022-05-12'),
(3, 'David',   'Levy',   '2021-09-01'),
(4, 'Anna',    'Brown',  '2023-03-20'),
(5, 'Michael', 'Green',  '2020-11-15');

INSERT INTO visitors (visitor_id, first_name, last_name, phone, date_of_birth, email, registration_date) VALUES
(1, 'Alice',   'Johnson', '0501111111', '1990-04-15', 'alice@email.com',   '2024-01-01'),
(2, 'Bob',     'Williams','0502222222', '1985-07-22', 'bob@email.com',     '2024-01-05'),
(3, 'Charlie', 'Davis',   '0503333333', '1992-11-03', 'charlie@email.com', '2024-01-10'),
(4, 'Diana',   'Miller',  '0504444444', '1998-02-28', 'diana@email.com',   '2024-01-15'),
(5, 'Eve',     'Wilson',  '0505555555', '2000-09-17', 'eve@email.com',     '2024-01-20');

INSERT INTO ticket_types (ticket_id, ticket_name, max_capacity, base_price, category) VALUES
(1, 'General Admission', 500, 50.00,  'Regular'),
(2, 'Child Ticket',      300, 25.00,  'Child'),
(3, 'Student Ticket',    200, 35.00,  'Student'),
(4, 'Senior Ticket',     150, 30.00,  'Senior'),
(5, 'VIP Ticket',        50,  120.00, 'VIP');

INSERT INTO transactions (transaction_id, transaction_date, total_amount, payment_method, employee_id, visitor_id) VALUES
(1, '2024-03-01', 100.00, 'Credit Card', 1, 1),
(2, '2024-03-05', 50.00,  'Cash',        2, 2),
(3, '2024-03-10', 75.00,  'Credit Card', 3, 3),
(4, '2024-03-15', 120.00, 'Cash',        4, 4),
(5, '2024-03-20', 200.00, 'Credit Card', 5, 5);

INSERT INTO transaction_items (item_id, quantity, price_at_sale, transaction_id, ticket_id) VALUES
(1, 2, 50.00,  1, 1),
(2, 1, 25.00,  2, 2),
(3, 1, 35.00,  3, 3),
(4, 1, 30.00,  4, 4),
(5, 1, 120.00, 5, 5);

INSERT INTO memberships (membership_id, start_date, expiry_date, visitor_id) VALUES
(1, '2024-01-01', '2025-01-01', 1),
(2, '2024-02-01', '2025-02-01', 2),
(3, '2024-03-01', '2025-03-01', 3),
(4, '2024-04-01', '2025-04-01', 4),
(5, '2024-05-01', '2025-05-01', 5);


-- ============================================================
-- METHOD 2: Mockaroo (External data generation tool)
-- ~500 rows per table were generated using mockaroo.com
-- with realistic field types and value ranges.
-- The generated SQL insert files are saved in:
--   Stage1/MockarooFiles/
--     - employees.sql
--     - visitors.sql
--     - ticket_types.sql
--     - transactions.sql
--     - transaction_items.sql
--     - memberships.sql
-- ============================================================


-- ============================================================
-- METHOD 3: pgAdmin GUI (Manual insertion via interface)
-- Additional rows were inserted directly through the pgAdmin
-- table editor, using the graphical interface to enter data
-- row by row without writing SQL.
-- Screenshots of this process are saved in:
--   Stage1/Screenshots1/
-- ============================================================