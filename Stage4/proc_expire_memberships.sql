-- ============================================================
-- proc_expire_memberships.sql
-- PROCEDURE 2: expire_old_memberships
--
-- Description:
-- This procedure loops through all memberships and checks
-- if each one has passed its expiry date. If expired, it
-- sets is_active to FALSE and updates the visitor's
-- loyalty_points by deducting 50 points as a penalty.
-- It also prints a summary of how many memberships were
-- expired during the run.
--
-- Elements used:
-- - Explicit cursor
-- - Record
-- - DML (UPDATE x2)
-- - Branches (expiry check)
-- - Loop
-- - Exception handling
-- ============================================================

CREATE OR REPLACE PROCEDURE expire_old_memberships()
LANGUAGE plpgsql
AS $$
DECLARE
    v_mem_record    RECORD;
    v_expired_count INT := 0;
    v_already_count INT := 0;

    -- Explicit cursor for all memberships
    cur_memberships CURSOR FOR
        SELECT m.membership_id,
               m.visitor_id,
               m.expiry_date,
               m.is_active,
               v.first_name || ' ' || v.last_name AS visitor_name
        FROM memberships m
        JOIN visitors v ON m.visitor_id = v.visitor_id
        ORDER BY m.membership_id;

BEGIN
    OPEN cur_memberships;
    LOOP
        FETCH cur_memberships INTO v_mem_record;
        EXIT WHEN NOT FOUND;

        -- Branch: check if membership is expired
        IF v_mem_record.expiry_date < CURRENT_DATE AND v_mem_record.is_active = TRUE THEN

            -- Mark membership as inactive (DML)
            UPDATE memberships
            SET is_active = FALSE
            WHERE membership_id = v_mem_record.membership_id;

            -- Deduct loyalty points from visitor (DML)
            UPDATE visitors
            SET loyalty_points = GREATEST(0, loyalty_points - 50)
            WHERE visitor_id = v_mem_record.visitor_id;

            v_expired_count := v_expired_count + 1;

            RAISE NOTICE 'Membership % for visitor % has been expired.',
                v_mem_record.membership_id,
                v_mem_record.visitor_name;

        ELSIF v_mem_record.is_active = FALSE THEN
            v_already_count := v_already_count + 1;
        END IF;

    END LOOP;
    CLOSE cur_memberships;

    RAISE NOTICE 'Expiry process complete. Newly expired: %, Already inactive: %.',
        v_expired_count, v_already_count;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in expire_old_memberships: %', SQLERRM;
END;
$$;
