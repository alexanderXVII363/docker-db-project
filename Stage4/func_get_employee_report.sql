-- ============================================================
-- func_get_employee_report.sql
-- FUNCTION 2: get_employee_report
--
-- Description:
-- This function returns a REF CURSOR containing a full
-- performance report for all employees. It loops through
-- every employee, counts their transactions, calculates
-- total revenue they handled, classifies their performance
-- level, and stores results in a temp table. The ref cursor
-- is then opened on that temp table and returned.
--
-- Elements used:
-- - Explicit cursor
-- - Ref cursor (returned)
-- - Record
-- - DML (INSERT into temp table)
-- - Branches (performance classification)
-- - Loop
-- - Exception handling
-- ============================================================

CREATE OR REPLACE FUNCTION get_employee_report()
RETURNS REFCURSOR
LANGUAGE plpgsql
AS $$
DECLARE
    ref_cur         REFCURSOR := 'employee_report_cursor';
    v_emp_record    RECORD;
    v_trans_count   INT;
    v_total_revenue NUMERIC;
    v_performance   TEXT;

    -- Explicit cursor for all employees
    cur_employees CURSOR FOR
        SELECT e.employee_id,
               e.first_name,
               e.last_name,
               e.hire_date,
               e.bonus_amount,
               COALESCE(m.first_name || ' ' || m.last_name, 'No Manager') AS manager_name
        FROM employees e
        LEFT JOIN manager m ON e.manager_id = m.manager_id
        ORDER BY e.employee_id;

BEGIN
    -- Create temp table to hold report data
    DROP TABLE IF EXISTS temp_employee_report;
    CREATE TEMP TABLE temp_employee_report (
        employee_id        INT,
        employee_name      TEXT,
        hire_date          DATE,
        manager_name       TEXT,
        total_transactions INT,
        total_revenue      NUMERIC,
        bonus_amount       NUMERIC,
        performance        TEXT
    );

    -- Loop through all employees
    OPEN cur_employees;
    LOOP
        FETCH cur_employees INTO v_emp_record;
        EXIT WHEN NOT FOUND;

        -- Count transactions per employee (implicit cursor)
        SELECT COUNT(*), COALESCE(SUM(total_amount), 0)
        INTO v_trans_count, v_total_revenue
        FROM transactions
        WHERE employee_id = v_emp_record.employee_id;

        -- Branch: classify performance
        IF v_trans_count >= 100 THEN
            v_performance := 'Excellent';
        ELSIF v_trans_count >= 50 THEN
            v_performance := 'Good';
        ELSIF v_trans_count >= 10 THEN
            v_performance := 'Average';
        ELSE
            v_performance := 'Low';
        END IF;

        -- Insert into temp table (DML)
        INSERT INTO temp_employee_report VALUES (
            v_emp_record.employee_id,
            v_emp_record.first_name || ' ' || v_emp_record.last_name,
            v_emp_record.hire_date,
            v_emp_record.manager_name,
            v_trans_count,
            v_total_revenue,
            v_emp_record.bonus_amount,
            v_performance
        );

    END LOOP;
    CLOSE cur_employees;

    -- Open ref cursor on temp table and return it
    OPEN ref_cur FOR
        SELECT * FROM temp_employee_report
        ORDER BY total_revenue DESC;

    RETURN ref_cur;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in get_employee_report: %', SQLERRM;
END;
$$;
