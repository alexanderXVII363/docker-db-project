-- ============================================================
-- main_program_1.sql
-- MAIN PROGRAM 1
--
-- Description:
-- This main program demonstrates the use of Function 1
-- (get_visitor_summary) and Procedure 1 (update_employee_bonuses).
-- It first calls the function to get a summary for visitor 1,
-- prints the result, then calls the procedure to update
-- all employee bonuses. Finally it shows the updated bonuses.
-- ============================================================

DO $$
DECLARE
    v_name          TEXT;
    v_transactions  BIGINT;
    v_spent         NUMERIC;
    v_loyalty       INT;
    v_membership    TEXT;
    v_result        RECORD;
BEGIN
    RAISE NOTICE '========================================';
    RAISE NOTICE 'MAIN PROGRAM 1 - START';
    RAISE NOTICE '========================================';

    -- -------------------------------------------------------
    -- PART 1: Call Function 1 - get_visitor_summary
    -- -------------------------------------------------------
    RAISE NOTICE 'Calling get_visitor_summary for visitor_id = 1...';

    SELECT * INTO v_result
    FROM get_visitor_summary(1);

    RAISE NOTICE '--- Visitor Summary ---';
    RAISE NOTICE 'Name: %',             v_result.visitor_name;
    RAISE NOTICE 'Total Transactions: %', v_result.total_transactions;
    RAISE NOTICE 'Total Spent: %',       v_result.total_spent;
    RAISE NOTICE 'Loyalty Points: %',    v_result.loyalty_points;
    RAISE NOTICE 'Membership Status: %', v_result.membership_status;

    -- -------------------------------------------------------
    -- PART 2: Call Procedure 1 - update_employee_bonuses
    -- -------------------------------------------------------
    RAISE NOTICE '----------------------------------------';
    RAISE NOTICE 'Calling update_employee_bonuses...';

    CALL update_employee_bonuses();

    -- Show top 5 employees by bonus after update
    RAISE NOTICE '--- Top 5 Employees by Bonus ---';
    FOR v_result IN
        SELECT first_name || ' ' || last_name AS name, bonus_amount
        FROM employees
        WHERE bonus_amount > 0
        ORDER BY bonus_amount DESC
        LIMIT 5
    LOOP
        RAISE NOTICE 'Employee: %, Bonus: %', v_result.name, v_result.bonus_amount;
    END LOOP;

    RAISE NOTICE '========================================';
    RAISE NOTICE 'MAIN PROGRAM 1 - COMPLETE';
    RAISE NOTICE '========================================';

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in main_program_1: %', SQLERRM;
END;
$$;
