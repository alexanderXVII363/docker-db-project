-- Index 1: Speed up searches and reports based on ticket purchase date
CREATE INDEX IDX_Tickets_PurchaseDate ON Tickets(PurchaseDate);

-- Index 2: Speed up queries that link tickets to specific visitors
CREATE INDEX IDX_Tickets_VisitorID ON Tickets(VisitorID);

-- Index 3: Speed up searches for visitors by their last name at the ticket counter
CREATE INDEX IDX_Visitors_LastName ON Visitors(LastName);