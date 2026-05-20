-- =========================
-- ROLLBACK DEMO
-- =========================

-- Step 1: Check current state
SELECT visitor_id, email FROM visitors WHERE visitor_id = 1;

-- Step 2: Begin transaction and make a change
BEGIN;

UPDATE visitors
SET email = 'rollback_test@email.com'
WHERE visitor_id = 1;

-- Step 3: Check state after update (change is visible inside transaction)
SELECT visitor_id, email FROM visitors WHERE visitor_id = 1;

-- Step 4: Rollback - undo all changes
ROLLBACK;

-- Step 5: Check state after rollback (original value restored)
SELECT visitor_id, email FROM visitors WHERE visitor_id = 1;


-- =========================
-- COMMIT DEMO
-- =========================

-- Step 1: Check current state
SELECT visitor_id, email FROM visitors WHERE visitor_id = 2;

-- Step 2: Begin transaction and make a change
BEGIN;

UPDATE visitors
SET email = 'commit_test@email.com'
WHERE visitor_id = 2;

-- Step 3: Check state after update
SELECT visitor_id, email FROM visitors WHERE visitor_id = 2;

-- Step 4: Commit - save changes permanently
COMMIT;

-- Step 5: Check state after commit (change is permanently saved)
SELECT visitor_id, email FROM visitors WHERE visitor_id = 2;
