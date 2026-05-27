-- ============================================================
-- AlterTable.sql
-- Stage 4 - Additional columns needed for PL/pgSQL programs
-- ============================================================

-- Add loyalty_points to visitors (used by function and trigger)
ALTER TABLE visitors
ADD COLUMN IF NOT EXISTS loyalty_points INT DEFAULT 0;

-- Add last_activity_date to visitors (updated by trigger on transaction)
ALTER TABLE visitors
ADD COLUMN IF NOT EXISTS last_activity_date DATE;

-- Add bonus_amount to employees (used by procedure)
ALTER TABLE employees
ADD COLUMN IF NOT EXISTS bonus_amount NUMERIC(10,2) DEFAULT 0;

-- Add is_active to memberships (used by procedure)
ALTER TABLE memberships
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT TRUE;

-- Add price_change_log table for trigger
CREATE TABLE IF NOT EXISTS ticket_price_log (
    log_id          SERIAL PRIMARY KEY,
    ticket_id       INT NOT NULL,
    old_price       NUMERIC(10,2),
    new_price       NUMERIC(10,2),
    changed_at      TIMESTAMP DEFAULT NOW()
);

-- Initialize loyalty_points based on existing transactions
UPDATE visitors v
SET loyalty_points = (
    SELECT COUNT(*) * 10
    FROM transactions t
    WHERE t.visitor_id = v.visitor_id
);

-- Initialize last_activity_date
UPDATE visitors v
SET last_activity_date = (
    SELECT MAX(transaction_date)
    FROM transactions t
    WHERE t.visitor_id = v.visitor_id
);
