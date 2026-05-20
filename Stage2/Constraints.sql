-- =========================
-- CONSTRAINTS
-- =========================

-- Constraint 1: Check that the base price is greater than zero
ALTER TABLE ticket_types
ADD CONSTRAINT chk_base_price CHECK (base_price > 0);

-- Test - this should fail:
-- INSERT INTO ticket_types (ticket_id, ticket_name, max_capacity, base_price, category)
-- VALUES (9999, 'Test', 100, -5.00, 'Regular');

-- Constraint 2: Make sure visitor phone numbers are unique
ALTER TABLE visitors
ADD CONSTRAINT uq_visitor_phone UNIQUE (phone);

-- Test - this should fail (duplicate phone):
-- INSERT INTO visitors (visitor_id, first_name, last_name, phone, date_of_birth, email, registration_date)
-- VALUES (9999, 'Test', 'User', '0501234567', '1990-01-01', 'test@test.com', '2024-01-01');

-- Constraint 3: Check that the ticket category is a valid value
ALTER TABLE ticket_types
ADD CONSTRAINT chk_category CHECK (category IN ('Regular', 'Child', 'Student', 'Senior', 'VIP'));

-- Test - this should fail:
-- INSERT INTO ticket_types (ticket_id, ticket_name, max_capacity, base_price, category)
-- VALUES (9998, 'Test', 100, 10.00, 'InvalidCategory');
