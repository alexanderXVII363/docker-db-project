-- ============================================================
-- trg_update_loyalty_points.sql
-- TRIGGER 1: trg_update_loyalty_points
--
-- Description:
-- This trigger fires AFTER INSERT on the transactions table.
-- When a new transaction is added, it automatically adds
-- 10 loyalty points to the visitor who made the transaction,
-- and updates their last_activity_date to today.
-- This ensures loyalty points are always up to date without
-- needing to call a function manually.
--
-- Trigger type: AFTER INSERT on transactions
-- Elements used: DML, branches, exception handling
-- ============================================================

CREATE OR REPLACE FUNCTION trg_fn_update_loyalty_points()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_current_points INT;
BEGIN
    -- Get current loyalty points (implicit cursor)
    SELECT loyalty_points INTO v_current_points
    FROM visitors
    WHERE visitor_id = NEW.visitor_id;

    -- Branch: handle case where visitor doesn't exist
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Visitor % not found when updating loyalty points', NEW.visitor_id;
    END IF;

    -- Add 10 loyalty points and update last activity (DML)
    UPDATE visitors
    SET loyalty_points     = COALESCE(v_current_points, 0) + 10,
        last_activity_date = CURRENT_DATE
    WHERE visitor_id = NEW.visitor_id;

    RAISE NOTICE 'Loyalty points updated for visitor %. New total: %',
        NEW.visitor_id,
        COALESCE(v_current_points, 0) + 10;

    RETURN NEW;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in trg_update_loyalty_points: %', SQLERRM;
END;
$$;

-- Drop trigger if exists and recreate
DROP TRIGGER IF EXISTS trg_update_loyalty_points ON transactions;

CREATE TRIGGER trg_update_loyalty_points
AFTER INSERT ON transactions
FOR EACH ROW
EXECUTE FUNCTION trg_fn_update_loyalty_points();
