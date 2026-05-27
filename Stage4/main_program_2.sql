-- ============================================================
-- main_program_2.sql
-- MAIN PROGRAM 2
--
-- Description:
-- This main program demonstrates the use of Function 2
-- (get_employee_report) and Procedure 2 (expire_old_memberships).
-- It first calls the procedure to expire old memberships,
-- then calls the function to get the employee report via
-- a ref cursor, fetches the results and prints them.
-- ============================================================

DO $$
DECLARE
    ref_cur     REFCURSOR;
    v_row       RECORD;
    v_count     INT := 0;
BEGIN
    RAISE NOTICE '========================================';
    RAISE NOTICE 'MAIN PROGRAM 2 - START';
    RAISE NOTICE '========================================';

    -- -------------------------------------------------------
    -- PART 1: Call Procedure 2 - expire_old_memberships
    -- -------------------------------------------------------
    RAISE NOTICE 'Calling expire_old_memberships...';

    CALL expire_old_memberships();

    -- Show membership status summary after procedure
    RAISE NOTICE '--- Membership Status Summary ---';
    FOR v_row IN
        SELECT is_active, COUNT(*) AS total
        FROM memberships
        GROUP BY is_active
    LOOP
        RAISE NOTICE 'Active: %, Count: %', v_row.is_active, v_row.total;
    END LOOP;

    -- -------------------------------------------------------
    -- PART 2: Call Function 2 - get_employee_report (ref cursor)
    -- -------------------------------------------------------
    RAISE NOTICE '----------------------------------------';
    RAISE NOTICE 'Calling get_employee_report...';

    -- Get the ref cursor from the function
    SELECT get_employee_report() INTO ref_cur;

    -- Fetch and print results from ref cursor
    RAISE NOTICE '--- Employee Performance Report ---';
    LOOP
        FETCH ref_cur INTO v_row;
        EXIT WHEN NOT FOUND;

        v_count := v_count + 1;

        -- Only print first 10 rows to keep output manageable
        IF v_count <= 10 THEN
            RAISE NOTICE 'Employee: %, Transactions: %, Revenue: %, Performance: %',
                v_row.employee_name,
                v_row.total_transactions,
                v_row.total_revenue,
                v_row.performance;
        END IF;
    END LOOP;

    CLOSE ref_cur;

    RAISE NOTICE 'Total employees in report: %', v_count;
    RAISE NOTICE '========================================';
    RAISE NOTICE 'MAIN PROGRAM 2 - COMPLETE';
    RAISE NOTICE '========================================';

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in main_program_2: %', SQLERRM;
END;
$$;
