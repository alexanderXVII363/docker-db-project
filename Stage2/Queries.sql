-- =========================
-- SELECT QUERIES (COMPLEX)
-- =========================

-- 1. Visitors with number of transactions (JOIN + GROUP BY)
SELECT v.visitor_id, v.first_name, v.last_name,
       COUNT(tr.transaction_id) AS total_transactions
FROM visitors v
JOIN transactions tr ON v.visitor_id = tr.visitor_id
GROUP BY v.visitor_id, v.first_name, v.last_name
ORDER BY total_transactions DESC;

-- 2. Same query using correlated subquery (SECOND VERSION)
SELECT v.visitor_id, v.first_name, v.last_name,
    (SELECT COUNT(*) FROM transactions tr WHERE tr.visitor_id = v.visitor_id) AS total_transactions
FROM visitors v
ORDER BY total_transactions DESC;

-- 3. Transactions from last 30 days (uses transaction_date index)
SELECT transaction_id, visitor_id, employee_id,
       transaction_date, total_amount, payment_method
FROM transactions
WHERE transaction_date >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY transaction_date DESC;

-- 4. Same using EXTRACT (SECOND VERSION)
SELECT transaction_id, visitor_id, employee_id,
       transaction_date, total_amount,
       EXTRACT(DAY   FROM transaction_date) AS day,
       EXTRACT(MONTH FROM transaction_date) AS month,
       EXTRACT(YEAR  FROM transaction_date) AS year
FROM transactions
WHERE EXTRACT(MONTH FROM transaction_date) = EXTRACT(MONTH FROM CURRENT_DATE)
  AND EXTRACT(YEAR  FROM transaction_date) = EXTRACT(YEAR  FROM CURRENT_DATE)
ORDER BY transaction_date DESC;

-- 5. Visitors with last name starting with 'A' - LIKE (uses index)
SELECT visitor_id, first_name, last_name, email, phone
FROM visitors
WHERE last_name LIKE 'A%'
ORDER BY last_name;

-- 6. Same using ILIKE - case insensitive (SECOND VERSION)
SELECT visitor_id, first_name, last_name, email, phone
FROM visitors
WHERE last_name ILIKE 'a%'
ORDER BY last_name;

-- 7. Average transactions per visitor
SELECT AVG(transaction_count) AS avg_transactions_per_visitor
FROM (
    SELECT visitor_id, COUNT(*) AS transaction_count
    FROM transactions
    GROUP BY visitor_id
) sub;

-- 8. Visitors with more than 5 transactions (GROUP BY + HAVING)
SELECT v.visitor_id, v.first_name, v.last_name,
       COUNT(tr.transaction_id) AS total_transactions
FROM visitors v
JOIN transactions tr ON v.visitor_id = tr.visitor_id
GROUP BY v.visitor_id, v.first_name, v.last_name
HAVING COUNT(tr.transaction_id) > 5
ORDER BY total_transactions DESC;


-- =========================
-- UPDATE QUERIES
-- =========================

-- 1. Update ticket name
-- Before:
SELECT * FROM ticket_types WHERE ticket_id = 1;

UPDATE ticket_types
SET ticket_name = 'VIP Experience'
WHERE ticket_id = 1;

-- After:
SELECT * FROM ticket_types WHERE ticket_id = 1;

-- 2. Update visitor email
-- Before:
SELECT * FROM visitors WHERE visitor_id = 1;

UPDATE visitors
SET email = 'updated@email.com'
WHERE visitor_id = 1;

-- After:
SELECT * FROM visitors WHERE visitor_id = 1;

-- 3. Increase base price for all ticket types by 10%
-- Before:
SELECT * FROM ticket_types;

UPDATE ticket_types
SET base_price = base_price * 1.1;

-- After:
SELECT * FROM ticket_types;


-- =========================
-- DELETE QUERIES
-- =========================

-- 1. Delete old transactions before 2022
-- Before:
SELECT * FROM transactions WHERE transaction_date < '2022-01-01' LIMIT 5;

DELETE FROM transactions
WHERE transaction_date < '2022-01-01';

-- After:
SELECT * FROM transactions WHERE transaction_date < '2022-01-01';

-- 2. Delete specific visitor
-- Before:
SELECT * FROM visitors WHERE visitor_id = 9999;

DELETE FROM visitors
WHERE visitor_id = 9999;

-- After:
SELECT * FROM visitors WHERE visitor_id = 9999;

-- 3. Delete transaction items linked to old transactions
-- Before:
SELECT ti.* FROM transaction_items ti
JOIN transactions tr ON ti.transaction_id = tr.transaction_id
WHERE tr.transaction_date < '2022-01-01' LIMIT 5;

DELETE FROM transaction_items
WHERE transaction_id IN (
    SELECT transaction_id FROM transactions
    WHERE transaction_date < '2022-01-01'
);

-- After:
SELECT * FROM transaction_items LIMIT 5;
