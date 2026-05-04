# Docker Database Project – Stage 1

## Project Overview

This project implements the first stage of a database system using **PostgreSQL** and **pgAdmin** running inside **Docker containers**.
The goal of Stage 1 is to design the database schema, create the required tables, and populate them with sample data.

The system models a **ticket and visitor management system**, which tracks visitors, employees, ticket types, transactions, and memberships.

---

## Technologies Used

* Docker
* PostgreSQL
* pgAdmin
* SQL
* Mockaroo (for data generation)
* Git / GitHub

---

## Database Entities

The database includes the following tables:

1. **employees** – stores employee information
2. **visitors** – stores visitor details
3. **ticket_types** – different types of tickets available
4. **transactions** – records purchases made by visitors
5. **transaction_items** – items included in each transaction
6. **memberships** – visitor membership information

These tables are connected through **primary keys and foreign keys** to maintain referential integrity.

---

## SQL Scripts

The project includes several SQL scripts located in the `Stage1` folder.

| File             | Purpose                              |
| ---------------- | ------------------------------------ |
| createTables.sql | Creates all database tables          |
| dropTables.sql   | Removes all tables from the database |
| insertTables.sql | Inserts initial data                 |
| selectAll.sql    | Queries to display table contents    |

---

## Data Generation

Data for the tables was generated using multiple methods:

1. **Manual SQL INSERT statements**
2. **Mockaroo generated SQL files**
3. **Manual data insertion through pgAdmin**

Each main table contains approximately **500 records** for testing purposes.

---

## Backup

A full database backup is included:

`backup_2026.sql`

This file allows the entire database to be restored if needed.

---

## Docker Setup

The database and pgAdmin run inside Docker containers using `docker-compose`.

To start the containers:

```
docker-compose up -d
```

This will start:

* PostgreSQL database container
* pgAdmin management interface

---

## Project Structure

```
docker-db-project
│
├── docker-compose.yml
├── README.md
│
└── Stage1
    ├── createTables.sql
    ├── dropTables.sql
    ├── insertTables.sql
    ├── selectAll.sql
    ├── backup_2026.sql
    │
    └── MockarooFiles
        ├── employees.sql
        ├── visitors.sql
        ├── ticket_types.sql
        ├── transactions.sql
        └── transaction_items.sql
```

---

## Stage 1 Tag

The submission for this stage is marked using the Git tag:

`stage1`

---

## Data Dictionary
## 📊 Data Dictionary

This section describes each table in the system, including its purpose, fields, and relationships.

---

## 👨‍💼 EMPLOYEES

**Description:**
Stores information about employees working in the system.

| Field Name  | Type        | Description                                       |
| ----------- | ----------- | ------------------------------------------------- |
| employee_id | INT         | Unique identifier for each employee (Primary Key) |
| first_name  | VARCHAR(20) | Employee's first name                             |
| last_name   | VARCHAR(20) | Employee's last name                              |
| hire_date   | DATE        | Date the employee was hired                       |

**Relationships:**

* Referenced by `transactions.employee_id`

---

## 👤 VISITORS

**Description:**
Stores information about visitors/customers of the system.

| Field Name        | Type        | Description                                      |
| ----------------- | ----------- | ------------------------------------------------ |
| visitor_id        | INT         | Unique identifier for each visitor (Primary Key) |
| first_name        | VARCHAR(20) | Visitor's first name                             |
| last_name         | VARCHAR(20) | Visitor's last name                              |
| phone             | VARCHAR(20) | Visitor's phone number                           |
| date_of_birth     | DATE        | Visitor's date of birth                          |
| email             | VARCHAR(50) | Visitor's email address                          |
| registration_date | DATE        | Date the visitor registered                      |

**Relationships:**

* Referenced by `transactions.visitor_id`
* Referenced by `memberships.visitor_id`

---

## TICKET_TYPES

**Description:**
Stores different types of tickets available for purchase.

| Field Name   | Type          | Description                                          |
| ------------ | ------------- | ---------------------------------------------------- |
| ticket_id    | INT           | Unique identifier for each ticket type (Primary Key) |
| ticket_name  | VARCHAR(100)  | Name of the ticket (e.g., VIP, General)              |
| max_capacity | INT           | Maximum number of tickets available                  |
| base_price   | NUMERIC(10,2) | Base price of the ticket                             |
| category     | VARCHAR(50)   | Category of the ticket (e.g., adult, child, VIP)     |

**Relationships:**

* Referenced by `transaction_items.ticket_id`

---

## TRANSACTIONS

**Description:**
Represents purchases made by visitors.

| Field Name       | Type          | Description                                          |
| ---------------- | ------------- | ---------------------------------------------------- |
| transaction_id   | INT           | Unique identifier for each transaction (Primary Key) |
| transaction_date | DATE          | Date the transaction occurred                        |
| total_amount     | NUMERIC(10,2) | Total amount paid                                    |
| payment_method   | VARCHAR(50)   | Payment method (e.g., cash, credit card)             |
| employee_id      | INT           | Employee who handled the transaction (Foreign Key)   |
| visitor_id       | INT           | Visitor who made the purchase (Foreign Key)          |

**Relationships:**

* References `employees.employee_id`
* References `visitors.visitor_id`
* Referenced by `transaction_items.transaction_id`

---

## TRANSACTION_ITEMS

**Description:**
Stores the individual items (tickets) included in each transaction.

| Field Name     | Type          | Description                                  |
| -------------- | ------------- | -------------------------------------------- |
| item_id        | INT           | Identifier for the item within a transaction |
| transaction_id | INT           | Associated transaction (Foreign Key)         |
| ticket_id      | INT           | Ticket type purchased (Foreign Key)          |
| quantity       | INT           | Number of tickets purchased                  |
| price_at_sale  | NUMERIC(10,2) | Price per ticket at time of sale             |

**Primary Key:**

* Composite key: (item_id, transaction_id)

**Relationships:**

* References `transactions.transaction_id`
* References `ticket_types.ticket_id`

---

##  MEMBERSHIPS

**Description:**
Stores membership information for visitors.

| Field Name    | Type | Description                                          |
| ------------- | ---- | ---------------------------------------------------- |
| membership_id | INT  | Unique identifier for each membership (Primary Key)  |
| start_date    | DATE | Start date of the membership                         |
| expiry_date   | DATE | Expiration date of the membership                    |
| visitor_id    | INT  | Visitor associated with the membership (Foreign Key) |

**Relationships:**

* References `visitors.visitor_id`

---
## Link To AI Studio
https://ai.studio/apps/e3a41d20-422a-404f-9456-cf01e27ff37b

# Stage 2 – SQL Queries, Constraints & Indexes

## Overview
In this stage we worked on querying the database, improving data integrity using constraints, and optimizing performance using indexes. We also tested transaction control using commit and rollback operations.

---

## SELECT QUERIES

We implemented 8 SELECT queries with different levels of complexity including JOINs, subqueries, aggregation, filtering, and grouping.

### Query 1 – JOIN (Visitors & Transactions)
This query returns visitors and the number of transactions they made using a JOIN and GROUP BY.

### Query 2 – Subquery version
This query returns the same result as Query 1 but uses a nested subquery instead of JOIN to compare approaches.

### Query 3 – Date filtering
This query retrieves transactions from the last 30 days using date comparison.

### Query 4 – Extract function on date
This query filters transactions by month using the EXTRACT function.

### Query 5 – LIKE operator
This query filters visitors whose last name starts with a specific letter.

### Query 6 – ILIKE operator
Same as Query 5 but case-insensitive.

### Query 7 – Average calculation
This query calculates the average number of transactions per visitor using a subquery.

### Query 8 – HAVING clause
This query shows visitors who made more than 5 transactions using GROUP BY and HAVING.

---

## UPDATE QUERIES

We performed updates to demonstrate modification of existing records:

- Updated a visitor email to test data modification.
- Updated membership type for a specific record.
- Increased ticket prices by a percentage.

We verified results before and after each update using SELECT queries.

---

## DELETE QUERIES

We tested deletion operations:

- Deleted old transactions based on date condition.
- Deleted a specific visitor record.
- Removed invalid or NULL-related membership data.

Each delete operation was verified before and after execution.

---

## TRANSACTION CONTROL (COMMIT & ROLLBACK)

We demonstrated database transaction control:

- A rollback operation was used to undo changes and restore previous state.
- A commit operation was used to permanently save changes to the database.

This shows understanding of safe database operations.

---

## CONSTRAINTS

We added constraints using ALTER TABLE to improve data integrity:
- Ensured valid data formats
- Prevented invalid or duplicate values
- Enforced relationships between tables

We tested constraints by attempting invalid inserts, which correctly failed.

---

## INDEXES

We created indexes on frequently used columns:
- Visitor last name
- Transaction date
- Visitor ID

We measured query performance before and after indexing and observed improved execution time for filtered queries.

---

## Conclusion
This stage improved our understanding of SQL querying, database optimization, and safe data manipulation techniques.