-- =========================
-- INDEXES
-- =========================

-- Index 1: Speed up date-range queries on transactions
-- Motivation: Queries filtering by transaction_date (e.g. last 30 days) 
-- benefit from this index as PostgreSQL can use Index Scan instead of Seq Scan.
CREATE INDEX idx_transactions_date ON transactions(transaction_date);

-- Index 2: Speed up JOIN queries linking transactions to visitors
-- Motivation: JOIN operations between visitors and transactions use visitor_id.
-- This index accelerates those lookups significantly on large datasets.
CREATE INDEX idx_transactions_visitor_id ON transactions(visitor_id);

-- Index 3: Speed up last name searches at the ticket counter
-- Motivation: LIKE 'A%' queries on last_name are common at point of sale.
-- A B-tree index on last_name supports prefix searches efficiently.
CREATE INDEX idx_visitors_last_name ON visitors(last_name);
