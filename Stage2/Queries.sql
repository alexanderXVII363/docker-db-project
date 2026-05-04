-- =========================
-- SELECT QUERIES (COMPLEX)
-- =========================

-- 1. Visitors with number of tickets (JOIN + GROUP BY)
SELECT v.visitor_id, v.first_name, v.last_name, COUNT(t.ticket_id) AS total_tickets
FROM visitors v
JOIN tickets t ON v.visitor_id = t.visitor_id
GROUP BY v.visitor_id, v.first_name, v.last_name
ORDER BY total_tickets DESC;

-- 2. Same query using subquery (SECOND VERSION)
SELECT visitor_id, first_name, last_name,
    (SELECT COUNT(*) FROM tickets t WHERE t.visitor_id = v.visitor_id) AS total_tickets
FROM visitors v;

-- 3. Tickets purchased in last 30 days (uses PurchaseDate index)
SELECT *
FROM tickets
WHERE purchase_date >= CURRENT_DATE - INTERVAL '30 days';

-- 4. Same using EXTRACT (SECOND VERSION)
SELECT *
FROM tickets
WHERE EXTRACT(MONTH FROM purchase_date) = EXTRACT(MONTH FROM CURRENT_DATE);

-- 5. Visitors with last name starting with 'A' (uses index)
SELECT *
FROM visitors
WHERE last_name LIKE 'A%';

-- 6. Same using ILIKE (SECOND VERSION)
SELECT *
FROM visitors
WHERE last_name ILIKE 'a%';

-- 7. Average tickets per visitor
SELECT AVG(ticket_count)
FROM (
    SELECT COUNT(*) AS ticket_count
    FROM tickets
    GROUP BY visitor_id
) sub;

-- 8. Visitors with more than 5 tickets (GROUP BY + HAVING)
SELECT visitor_id, COUNT(*) AS total
FROM tickets
GROUP BY visitor_id
HAVING COUNT(*) > 5;


-- =========================
-- UPDATE QUERIES
-- =========================

-- 1. Update ticket type
UPDATE tickets
SET ticket_type = 'VIP'
WHERE ticket_id = 1;

-- 2. Update visitor email
UPDATE visitors
SET email = 'updated@email.com'
WHERE visitor_id = 1;

-- 3. Increase price for all tickets
UPDATE tickets
SET price = price * 1.1;


-- =========================
-- DELETE QUERIES
-- =========================

-- 1. Delete old tickets
DELETE FROM tickets
WHERE purchase_date < '2022-01-01';

-- 2. Delete specific visitor
DELETE FROM visitors
WHERE visitor_id = 9999;

-- 3. Delete tickets with NULL visitor
DELETE FROM tickets
WHERE visitor_id IS NULL;