-- ============================================================
-- proc_update_bonuses.sql
-- PROCEDURE 1: update_employee_bonuses
--
-- Description:
-- This procedure loops through all employees and calculates
-- a bonus based on the total revenue they handled in
-- transactions. Employees with high revenue get a higher
-- bonus percentage. It updates the bonus_amount column for
-- each employee and prints a summary using RAISE NOTICE.
--
-- Elements used:
-- - Explicit cursor
-- - Record
-- - DML (UPDATE)
-- - Branches (bonus tiers)
-- - Loop
-- - Exception handling
-- ============================================================

CREATE OR REPLACE PROCEDURE update_employee_bonuses()
LANGUAGE plpgsql
AS $$
DECLARE
    v_emp_record    RECORD;
    v_revenue       NUMERIC;
    v_bonus         NUMERIC;
    v_updated_count INT := 0;

    -- Explicit cursor for all employees
    cur_emp CURSOR FOR
        SELECT employee_id, first_name, last_name
        FROM employees
        ORDER BY employee_id;

BEGIN
    OPEN cur_emp;
    LOOP
        FETCH cur_emp INTO v_emp_record;
        EXIT WHEN NOT FOUND;

        -- Calculate total revenue for this employee (implicit cursor)
        SELECT COALESCE(SUM(total_amount), 0)
        INTO v_revenue
        FROM transactions
        WHERE employee_id = v_emp_record.employee_id;

        -- Branch: determine bonus based on revenue tiers
        IF v_revenue >= 100000 THEN
            v_bonus := v_revenue * 0.05;  -- 5% bonus
        ELSIF v_revenue >= 50000 THEN
            v_bonus := v_revenue * 0.03;  -- 3% bonus
        ELSIF v_revenue >= 10000 THEN
            v_bonus := v_revenue * 0.01;  -- 1% bonus
        ELSE
            v_bonus := 0;
        END IF;

        -- Update bonus in database (DML)
        UPDATE employees
        SET bonus_amount = v_bonus
        WHERE employee_id = v_emp_record.employee_id;

        v_updated_count := v_updated_count + 1;

        -- Print notice for high performers
        IF v_bonus > 0 THEN
            RAISE NOTICE 'Employee % % received bonus: %',
                v_emp_record.first_name,
                v_emp_record.last_name,
                v_bonus;
        END IF;

    END LOOP;
    CLOSE cur_emp;

    RAISE NOTICE 'Bonus update complete. % employees processed.', v_updated_count;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in update_employee_bonuses: %', SQLERRM;
END;
$$;
