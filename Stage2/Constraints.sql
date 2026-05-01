-- Constraint 1: Check that the ticket price is greater than zero
ALTER TABLE Tickets
ADD CONSTRAINT CHK_TicketPrice CHECK (Price > 0);

-- Constraint 2: Make sure visitor phone numbers are not duplicated
ALTER TABLE Visitors
ADD CONSTRAINT UQ_VisitorPhone UNIQUE (PhoneNumber);

-- Constraint 3: Check that the ticket type is valid (from a specific list)
ALTER TABLE Tickets
ADD CONSTRAINT CHK_TicketType CHECK (TicketType IN ('Regular', 'Child', 'Student', 'Senior'));