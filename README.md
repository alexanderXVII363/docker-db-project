
---

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
10. [Stage 2 – Queries, Constraints & Indexes](#stage-2-queries-constraints--indexes)

---

## Project Overview

This project implements a robust database system using **PostgreSQL** and **pgAdmin** orchestrated via **Docker containers**.

The system models a **Ticket & Visitor Management System**, tracking visitors, employees, ticket types, transactions, and memberships. It is designed to handle the complex data requirements of a high-traffic venue, such as a theme park or zoo.

The schema is strictly normalized to **3NF** to eliminate data redundancy and ensure referential integrity. The environment is managed through a containerized pgAdmin instance, providing a professional interface for database administration and performance monitoring.

The UI mockup was designed using Google AI Studio:

🔗 [View UI Mockup](https://ai.studio/apps/e3a41d20-422a-404f-9456-cf01e27ff37b)

---

## Technologies Used

* **Docker & Docker Compose**: System containerization and service orchestration.
* **PostgreSQL**: Relational database engine.
* **pgAdmin 4**: Database administration and visualization.
* **SQL**: For schema definition (DDL) and complex querying (DML).
* **Mockaroo**: Bulk dataset generation.
* **Git / GitHub**: Source control and documentation.

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

A full database dump was created for backup verification: `backup_2026.sql`.

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
│   ├── ERD/                   # Entity Relationship Diagrams
│   ├── Screenshots1/          # Execution evidence for Stage 1
│   ├── stage1-ui.html         # UI Prototype
│   └── MockarooFiles/         # Raw CSV/SQL datasets
│
└── Stage2
    ├── Queries.sql            # SELECT, UPDATE, DELETE logic
    ├── Constraints.sql        # Data integrity rules
    ├── Index.sql              # Performance optimizations
    ├── RollbackCommit.sql     # Transaction control demos
    ├── backup2.sql            # Final stage backup
    └── screenshots/           # Evidence for Stage 2 (EXPLAIN ANALYZE results)

```

---

## Stage 1 Tag

`stage1`

---

## Stage 2 – Queries, Constraints & Indexes

### SELECT Queries

We analyzed 8 queries, focusing on execution plans and performance trade-offs between different SQL approaches.

#### 🔷 JOIN vs. Correlated Subquery (Q1 vs. Q2)

* **Performance Insight**: While the Subquery approach is often more readable, the **JOIN is typically more efficient** for larger datasets. The query planner can optimize a JOIN to scan both tables simultaneously, whereas a correlated subquery often forces the engine to execute a separate lookup for every row.

#### 🔷 Date Comparison vs. EXTRACT (Q3 vs. Q4)

* **Performance Insight**: Direct date comparison is **generally superior** because it is "SARGable" (Search Argumentable), allowing PostgreSQL to utilize B-tree indexes. Using the `EXTRACT` function transforms the column value, which prevents index usage and usually triggers a full table scan.

#### 🔷 LIKE vs. ILIKE (Q5 vs. Q6)

* **Performance Insight**: `LIKE` is case-sensitive and utilizes standard B-tree indexes. `ILIKE` improves user experience by being case-insensitive, but requires a specialized index (such as a functional index or `citext`) to maintain high performance on large tables.

---

### Constraints

To ensure data integrity at the database level, we implemented:

* **Check Constraints**: Enforced `base_price > 0` and restricted the `category` column to a pre-defined set of valid strings.
* **Unique Constraints**: Applied to the `phone` column to prevent duplicate visitor records.

---

### Indexes

1. **idx_transactions_date**: Optimized chronological filtering and reporting.
2. **idx_transactions_visitor_id**: Accelerated foreign key lookups during JOIN operations.
3. **idx_visitors_last_name**: Dramatically improved search speeds for surnames in the point-of-sale system.

---

## Conclusion

Stage 2 focused on transforming a structured database into an optimized, production-ready system. By applying 3NF normalization, strategic indexing, and strict integrity constraints, we have developed a system that is efficient, scalable, and resilient to data entry errors.

---

## Stage 2 Tag

`stage2`