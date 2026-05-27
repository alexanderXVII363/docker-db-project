-- ============================================================
-- trg_log_price_change.sql
-- TRIGGER 2: trg_log_price_change
--
-- Description:
-- This trigger fires AFTER UPDATE on the ticket_types table.
-- When a ticket's base_price is changed, the trigger logs
-- the old and new price into the ticket_price_log table.
-- This provides an audit trail of all price changes.
--
-- Trigger type: AFTER UPDATE on ticket_types
-- Elements used: DML, branches, record (OLD/NEW), exception
-- ============================================================

CREATE OR REPLACE FUNCTION trg_fn_log_price_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Branch: only log if price actually changed
    IF OLD.base_price <> NEW.base_price THEN

        -- Insert log record (DML)
        INSERT INTO ticket_price_log (ticket_id, old_price, new_price, changed_at)
        VALUES (NEW.ticket_id, OLD.base_price, NEW.base_price, NOW());

        RAISE NOTICE 'Price change logged for ticket %. Old: %, New: %',
            NEW.ticket_id,
            OLD.base_price,
            NEW.base_price;
    ELSE
        RAISE NOTICE 'No price change detected for ticket %. Skipping log.',
            NEW.ticket_id;
    END IF;

    RETURN NEW;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in trg_log_price_change: %', SQLERRM;
END;
$$;

-- Drop trigger if exists and recreate
DROP TRIGGER IF EXISTS trg_log_price_change ON ticket_types;

CREATE TRIGGER trg_log_price_change
AFTER UPDATE ON ticket_types
FOR EACH ROW
EXECUTE FUNCTION trg_fn_log_price_change();
