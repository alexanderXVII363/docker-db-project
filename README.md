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
