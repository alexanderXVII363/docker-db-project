# Docker Database Project

**Submitted by:** Alex & Moshe

**System:** Ticket & Visitor Management System

> This project demonstrates relational database design, normalization to 3NF, query optimization, and containerized deployment using Docker.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Technologies Used](#technologies-used)
3. [Database Entities](#database-entities)
4. [Data Dictionary](#data-dictionary)
5. [Docker Setup](#docker-setup)
6. [Data Generation](#data-generation)
7. [Backup](#backup)
8. [Project Structure](#project-structure)
9. [Stage 1 Tag](#stage-1-tag)
10. [Stage 2 – Queries, Constraints & Indexes](#stage-2--queries-constraints--indexes)
11. [Conclusion](#conclusion)

---

## Project Overview

This project implements a robust database system using **PostgreSQL** and **pgAdmin** orchestrated via **Docker containers**.

The system models a **Ticket & Visitor Management System**, tracking visitors, employees, ticket types, transactions, and memberships. It is designed to handle the complex data requirements of a high-traffic venue, such as a theme park or zoo.

The schema is strictly normalized to **3NF** to eliminate data redundancy and ensure referential integrity. The environment is managed through a containerized pgAdmin instance, providing a professional interface for database administration and performance monitoring.

---

## Technologies Used

**Core Stack:**
- **Docker & Docker Compose**: System containerization and service orchestration.
- **PostgreSQL**: Relational database engine.
- **pgAdmin 4**: Database administration and visualization.
- **SQL**: For schema definition (DDL) and complex querying (DML).

**Development Tools:**
- **Mockaroo**: Bulk dataset generation.
- **Git / GitHub**: Source control and documentation.

---

## Database Entities

The database architecture consists of six core tables:

1. **employees**: Personnel management and transaction accountability.
2. **visitors**: Comprehensive customer profiles and contact data.
3. **ticket_types**: Product catalog including pricing and capacity constraints.
4. **transactions**: High-level purchase headers.
5. **transaction_items**: Granular line-item details for individual sales.
6. **memberships**: Validity and subscription tracking for recurring visitors.

---

## Data Dictionary

### 👨‍💼 employees

**Description:** Stores staff information for system operations.

| Field Name | Type | Description |
| --- | --- | --- |
| employee_id | INT | Unique identifier (Primary Key) |
| first_name | VARCHAR(20) | Employee's first name |
| last_name | VARCHAR(20) | Employee's last name |
| hire_date | DATE | Employment commencement date |

**Relationships:** Referenced by `transactions.employee_id`.

---

### 👤 visitors

**Description:** Stores registered customer data.

| Field Name | Type | Description |
| --- | --- | --- |
| visitor_id | INT | Unique identifier (Primary Key) |
| first_name | VARCHAR(20) | Visitor's first name |
| last_name | VARCHAR(20) | Visitor's last name |
| phone | VARCHAR(20) | Contact number (Unique Constraint) |
| date_of_birth | DATE | Visitor's date of birth |
| email | VARCHAR(50) | Primary contact email address |
| registration_date | DATE | Profile creation date |

**Relationships:** Referenced by `transactions.visitor_id` and `memberships.visitor_id`.

---

### 🎟️ ticket_types

**Description:** Inventory of ticket products and associated rules.

| Field Name | Type | Description |
| --- | --- | --- |
| ticket_id | INT | Unique identifier (Primary Key) |
| ticket_name | VARCHAR(100) | Product name (e.g., VIP, General) |
| max_capacity | INT | Sales limit per ticket type |
| base_price | NUMERIC(10,2) | Default unit price (Constraint: > 0) |
| category | VARCHAR(50) | Classification (e.g., Student, Senior, Child) |

**Relationships:** Referenced by `transaction_items.ticket_id`.

---

### 💳 transactions

**Description:** Records of financial exchanges.

| Field Name | Type | Description |
| --- | --- | --- |
| transaction_id | INT | Unique identifier (Primary Key) |
| transaction_date | DATE | Date the transaction occurred |
| total_amount | NUMERIC(10,2) | Final amount paid |
| payment_method | VARCHAR(50) | Payment method (e.g., Credit, Cash) |
| employee_id | INT | Processing staff member (Foreign Key) |
| visitor_id | INT | Purchasing visitor (Foreign Key) |

**Relationships:** Referenced by `transaction_items.transaction_id`.

---

### 🧾 transaction_items

**Description:** Line-item details for each sale, mapping products to transactions.

| Field Name | Type | Description |
| --- | --- | --- |
| item_id | INT | Item sequence (Composite Primary Key) |
| transaction_id | INT | Parent transaction (Composite PK / Foreign Key) |
| ticket_id | INT | Specific ticket product (Foreign Key) |
| quantity | INT | Number of units purchased |
| price_at_sale | NUMERIC(10,2) | Historical price captured at time of sale |

---

### 🏅 memberships

**Description:** Active subscription status for visitors.

| Field Name | Type | Description |
| --- | --- | --- |
| membership_id | INT | Unique identifier (Primary Key) |
| start_date | DATE | Activation date |
| expiry_date | DATE | Validity expiration date |
| visitor_id | INT | Associated customer (Foreign Key) |

---

## Docker Setup

The entire environment can be deployed with a single command:

```bash
docker-compose up -d
```

**Services:**

* **PostgreSQL_DB**: The database engine and storage.
* **pgadminApp**: Administration GUI available at `http://localhost:8080`.

---

## Data Generation

The database was populated using three methods to ensure realistic testing:

1. **Manual SQL DML**: Targeted `INSERT` statements for verifying constraints.
2. **Mockaroo**: Generation of ~500 rows per table to evaluate performance at scale.
3. **pgAdmin GUI**: Interactive entry for rapid administrative changes.

---

## Backup

A full database dump was created for backup verification: `backup.sql`.

* **GUI Method**: Performed via the pgAdmin "Backup" interface.
* **CLI Method**: Executed via the `pg_dump` utility within the Docker container.

---

## Project Structure

```text
docker-db-project
│
├── docker-compose.yml
├── README.md
│
├── Stage1
│   ├── createTables.sql
│   ├── dropTables.sql
│   ├── insertTables.sql
│   ├── selectAll.sql
│   ├── ERD/
│   ├── Screenshots1/
│   ├── stage1-ui.html
│   └── MockarooFiles/
│
└── Stage2
    ├── Queries.sql
    ├── Constraints.sql
    ├── Index.sql
    ├── RollbackCommit.sql
    ├── backup.sql
    └── screenshots/
```

---

## Stage 1 Tag

`stage1` — marks the submission point for Stage 1 of the project.

---

## Stage 2 – Queries, Constraints & Indexes

### SELECT Queries

---

#### 🔷 Q1 – JOIN Query

```sql
SELECT v.visitor_id, v.first_name, v.last_name, COUNT(t.ticket_id) AS total_tickets
FROM visitors v
JOIN tickets t ON v.visitor_id = t.visitor_id
GROUP BY v.visitor_id, v.first_name, v.last_name
ORDER BY total_tickets DESC;
```

**Purpose:** Count total tickets per visitor using a JOIN with GROUP BY.

---

#### 🔷 Q2 – Correlated Subquery

```sql
SELECT visitor_id, first_name, last_name,
    (SELECT COUNT(*) FROM tickets t WHERE t.visitor_id = v.visitor_id) AS total_tickets
FROM visitors v;
```

**Purpose:** Count total tickets per visitor using a correlated subquery — an alternative to Q1.

---

#### 🔷 Q3 – Date Comparison Query

```sql
SELECT *
FROM tickets
WHERE purchase_date >= CURRENT_DATE - INTERVAL '30 days';
```

**Purpose:** Retrieve all tickets purchased in the last 30 days using direct date comparison.

---

#### 🔷 Q4 – EXTRACT Query

```sql
SELECT *
FROM tickets
WHERE EXTRACT(MONTH FROM purchase_date) = EXTRACT(MONTH FROM CURRENT_DATE);
```

**Purpose:** Retrieve tickets from the current month using EXTRACT — an alternative to Q3.

---

#### 🔷 Q5 – LIKE Query

```sql
SELECT *
FROM visitors
WHERE last_name LIKE 'A%';
```

**Purpose:** Search visitors whose last name starts with the letter 'A' (case-sensitive).

---

#### 🔷 Q6 – ILIKE Query

```sql
SELECT *
FROM visitors
WHERE last_name ILIKE 'a%';
```

**Purpose:** Perform a case-insensitive surname search — an alternative to Q5.

---

#### 🔷 Q7 – Average Tickets per Visitor

```sql
SELECT AVG(ticket_count)
FROM (
    SELECT COUNT(*) AS ticket_count
    FROM tickets
    GROUP BY visitor_id
) sub;
```

**Purpose:** Calculate the average number of tickets purchased per visitor using a subquery.

---

#### 🔷 Q8 – GROUP BY with HAVING

```sql
SELECT visitor_id, COUNT(*) AS total
FROM tickets
GROUP BY visitor_id
HAVING COUNT(*) > 5;
```

**Purpose:** Find visitors who have purchased more than 5 tickets using HAVING.

---

### UPDATE Queries

---

#### 🔶 U1 – Update a Single Ticket Type

```sql
UPDATE tickets
SET ticket_type = 'VIP'
WHERE ticket_id = 1;
```

**Purpose:** Upgrade a specific ticket to VIP status.

---

#### 🔶 U2 – Update a Visitor's Email

```sql
UPDATE visitors
SET email = 'updated@email.com'
WHERE visitor_id = 1;
```

**Purpose:** Correct or refresh a visitor's contact email address.

---

#### 🔶 U3 – Bulk Price Increase

```sql
UPDATE tickets
SET price = price * 1.1;
```

**Purpose:** Apply a 10% price increase across all tickets.

---

### DELETE Queries

---

#### 🔴 D1 – Delete Old Tickets

```sql
DELETE FROM tickets
WHERE purchase_date < '2022-01-01';
```

**Purpose:** Remove outdated ticket records prior to 2022 to keep the dataset clean.

---

#### 🔴 D2 – Delete a Specific Visitor

```sql
DELETE FROM visitors
WHERE visitor_id = 9999;
```

**Purpose:** Remove a specific visitor record by ID.

---

#### 🔴 D3 – Delete Orphaned Tickets

```sql
DELETE FROM tickets
WHERE visitor_id IS NULL;
```

**Purpose:** Clean up ticket records with no associated visitor.

---

### Query Performance Insights

#### JOIN vs. Correlated Subquery

* JOIN queries are generally faster on large datasets.
* Correlated subqueries execute a repeated lookup per row and may be slower at scale.

#### Date Comparison vs. EXTRACT

* Direct date comparison (`>=`) is SARGable and takes advantage of indexes efficiently.
* EXTRACT wraps the column in a function, which prevents index usage and causes full table scans.

#### LIKE vs. ILIKE

* LIKE uses standard B-tree indexes efficiently for prefix searches.
* ILIKE improves usability but may require a specialized `pg_trgm` index for optimal performance.

---

### Constraints

To ensure data integrity at the database level, three constraints were implemented:

---

#### ✅ Constraint 1 – Ticket Price Must Be Positive

```sql
-- Constraint 1: Check that the ticket price is greater than zero
ALTER TABLE Tickets
ADD CONSTRAINT CHK_TicketPrice CHECK (Price > 0);
```

**Purpose:** Prevents invalid ticket records with zero or negative prices from being inserted.

---

#### ✅ Constraint 2 – Unique Visitor Phone Numbers

```sql
-- Constraint 2: Make sure visitor phone numbers are not duplicated
ALTER TABLE Visitors
ADD CONSTRAINT UQ_VisitorPhone UNIQUE (PhoneNumber);
```

**Purpose:** Enforces that each visitor has a unique phone number, preventing duplicate registrations.

---

#### ✅ Constraint 3 – Valid Ticket Type Values

```sql
-- Constraint 3: Check that the ticket type is valid (from a specific list)
ALTER TABLE Tickets
ADD CONSTRAINT CHK_TicketType CHECK (TicketType IN ('Regular', 'Child', 'Student', 'Senior'));
```

**Purpose:** Restricts the `TicketType` column to a predefined set of valid categories, preventing bad data entry.

---

### Indexes

Three indexes were created to optimize the most frequent query patterns:

---

#### ⚡ Index 1 – Purchase Date

```sql
-- Index 1: Speed up searches and reports based on ticket purchase date
CREATE INDEX IDX_Tickets_PurchaseDate ON Tickets(PurchaseDate);
```

**Purpose:** Optimizes date-range queries (Q3) and time-based reporting. Works directly with the SARGable `>=` comparison used in Q3.

---

#### ⚡ Index 2 – Visitor ID on Tickets

```sql
-- Index 2: Speed up queries that link tickets to specific visitors
CREATE INDEX IDX_Tickets_VisitorID ON Tickets(VisitorID);
```

**Purpose:** Improves JOIN performance between `tickets` and `visitors` tables (Q1, Q2).

---

#### ⚡ Index 3 – Visitor Last Name

```sql
-- Index 3: Speed up searches for visitors by their last name at the ticket counter
CREATE INDEX IDX_Visitors_LastName ON Visitors(LastName);
```

**Purpose:** Accelerates surname-based prefix searches using `LIKE 'A%'` (Q5).

---

### Rollback & Commit

Transaction control was demonstrated using `BEGIN`, `ROLLBACK`, and `COMMIT` to verify data safety.

**Rollback example** — changes are reversed:

```sql
BEGIN;

DELETE FROM tickets WHERE purchase_date < '2022-01-01';

-- Verify the deletion took effect within the transaction
SELECT COUNT(*) FROM tickets;

-- Undo all changes — data is fully restored
ROLLBACK;
```

**Commit example** — changes are permanently saved:

```sql
BEGIN;

UPDATE visitors
SET email = 'confirmed@email.com'
WHERE visitor_id = 1;

-- Persist the change permanently
COMMIT;
```

**Key takeaway:** `ROLLBACK` undoes all statements since the last `BEGIN`, while `COMMIT` makes them permanent. This is critical for maintaining data integrity during bulk operations.

---

## Conclusion

Stage 2 focused on transforming a structured relational schema into an optimized, production-ready system. By applying 3NF normalization, strategic indexing, and strict integrity constraints, we developed a system that is scalable, efficient, and resilient to data entry errors. Future extensions could include role-based access control, audit logging, and a live reporting dashboard.

---

## Stage 2 Tag

`stage2`