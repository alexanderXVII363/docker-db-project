-- ============================================================
-- func_get_visitor_summary.sql
-- FUNCTION 1: get_visitor_summary
-- 
-- Description:
-- This function receives a visitor_id and returns a summary
-- of that visitor including their full name, total number of
-- transactions, total amount spent, loyalty points, and
-- membership status. It uses an explicit cursor to loop
-- through transactions, updates the visitor's loyalty points
-- in the database, and handles exceptions gracefully.
--
-- Elements used:
-- - Explicit cursor
-- - Record
-- - DML (UPDATE)
-- - Branches (IF/ELSIF/ELSE)
-- - Loop
-- - Exception handling
-- ============================================================

CREATE OR REPLACE FUNCTION get_visitor_summary(p_visitor_id INT)
RETURNS TABLE (
    visitor_name        TEXT,
    total_transactions  BIGINT,
    total_spent         NUMERIC,
    loyalty_points      INT,
    membership_status   TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_record        visitors%ROWTYPE;
    v_trans_count   BIGINT := 0;
    v_total_spent   NUMERIC := 0;
    v_loyalty       INT := 0;
    v_membership    TEXT := 'No Membership';

    -- Explicit cursor for transactions
    cur_transactions CURSOR FOR
        SELECT total_amount
        FROM transactions
        WHERE visitor_id = p_visitor_id;

    v_trans_row RECORD;
BEGIN
    -- Get visitor record using implicit cursor
    BEGIN
        SELECT * INTO STRICT v_record
        FROM visitors
        WHERE visitor_id = p_visitor_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE EXCEPTION 'Visitor with ID % not found', p_visitor_id;
    END;

    -- Loop through transactions using explicit cursor
    OPEN cur_transactions;
    LOOP
        FETCH cur_transactions INTO v_trans_row;
        EXIT WHEN NOT FOUND;

        v_trans_count := v_trans_count + 1;
        v_total_spent := v_total_spent + v_trans_row.total_amount;
    END LOOP;
    CLOSE cur_transactions;

    -- Calculate loyalty points (10 per transaction)
    v_loyalty := v_trans_count * 10;

    -- Update loyalty points in database (DML)
    UPDATE visitors
    SET loyalty_points     = v_loyalty,
        last_activity_date = CURRENT_DATE
    WHERE visitor_id = p_visitor_id;

    -- Check membership status using branches
    IF EXISTS (
        SELECT 1 FROM memberships
        WHERE visitor_id = p_visitor_id
          AND is_active = TRUE
          AND expiry_date >= CURRENT_DATE
    ) THEN
        v_membership := 'Active Member';
    ELSIF EXISTS (
        SELECT 1 FROM memberships
        WHERE visitor_id = p_visitor_id
    ) THEN
        v_membership := 'Expired Member';
    ELSE
        v_membership := 'No Membership';
    END IF;

    -- Return result row
    RETURN QUERY SELECT
        v_record.first_name || ' ' || v_record.last_name,
        v_trans_count,
        v_total_spent,
        v_loyalty,
        v_membership;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in get_visitor_summary: %', SQLERRM;
END;
$$;
