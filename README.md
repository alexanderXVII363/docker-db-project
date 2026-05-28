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

The UI mockup was designed using Google AI Studio:
🔗 [View UI Mockup](https://ai.studio/apps/e3a41d20-422a-404f-9456-cf01e27ff37b)

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

| Field Name  | Type         | Description                            |
| ----------- | ------------ | -------------------------------------- |
| employee_id | INT          | Unique identifier (Primary Key)        |
| first_name  | VARCHAR(20)  | Employee's first name                  |
| last_name   | VARCHAR(20)  | Employee's last name                   |
| hire_date   | DATE         | Employment commencement date           |

**Relationships:** Referenced by `transactions.employee_id`.

---

### 👤 visitors

**Description:** Stores registered customer data.

| Field Name        | Type         | Description                            |
| ----------------- | ------------ | -------------------------------------- |
| visitor_id        | INT          | Unique identifier (Primary Key)        |
| first_name        | VARCHAR(20)  | Visitor's first name                   |
| last_name         | VARCHAR(20)  | Visitor's last name                    |
| phone             | VARCHAR(20)  | Contact number (Unique Constraint)     |
| date_of_birth     | DATE         | Visitor's date of birth                |
| email             | VARCHAR(50)  | Primary contact email address          |
| registration_date | DATE         | Profile creation date                  |

**Relationships:** Referenced by `transactions.visitor_id` and `memberships.visitor_id`.

---

### 🎟️ ticket_types

**Description:** Inventory of ticket products and associated rules.

| Field Name   | Type           | Description                                      |
| ------------ | -------------- | ------------------------------------------------ |
| ticket_id    | INT            | Unique identifier (Primary Key)                  |
| ticket_name  | VARCHAR(100)   | Product name (e.g., VIP, General)                |
| max_capacity | INT            | Sales limit per ticket type                      |
| base_price   | NUMERIC(10,2)  | Default unit price (Constraint: > 0)             |
| category     | VARCHAR(50)    | Classification (e.g., Student, Senior, Child)    |

**Relationships:** Referenced by `transaction_items.ticket_id`.

---

### 💳 transactions

**Description:** Records of financial exchanges.

| Field Name       | Type           | Description                                |
| ---------------- | -------------- | ------------------------------------------ |
| transaction_id   | INT            | Unique identifier (Primary Key)            |
| transaction_date | DATE           | Date the transaction occurred              |
| total_amount     | NUMERIC(10,2)  | Final amount paid                          |
| payment_method   | VARCHAR(50)    | Payment method (e.g., Credit, Cash)        |
| employee_id      | INT            | Processing staff member (Foreign Key)      |
| visitor_id       | INT            | Purchasing visitor (Foreign Key)           |

**Relationships:** Referenced by `transaction_items.transaction_id`.

---

### 🧾 transaction_items

**Description:** Line-item details for each sale, mapping products to transactions.

| Field Name    | Type           | Description                                      |
| ------------- | -------------- | ------------------------------------------------ |
| item_id       | INT            | Item sequence (Composite Primary Key)            |
| transaction_id| INT            | Parent transaction (Composite PK / Foreign Key)  |
| ticket_id     | INT            | Specific ticket product (Foreign Key)            |
| quantity      | INT            | Number of units purchased                        |
| price_at_sale | NUMERIC(10,2)  | Historical price captured at time of sale        |

---

### 🏅 memberships

**Description:** Active subscription status for visitors.

| Field Name    | Type  | Description                             |
| ------------- | ----- | --------------------------------------- |
| membership_id | INT   | Unique identifier (Primary Key)         |
| start_date    | DATE  | Activation date                         |
| expiry_date   | DATE  | Validity expiration date                |
| visitor_id    | INT   | Associated customer (Foreign Key)       |

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

1. **Manual SQL DML**: Targeted `INSERT` statements for verifying constraints. See `Stage1/insertTables.sql`.
2. **Mockaroo**: Generation of ~500 rows per table. Files saved in `Stage1/MockarooFiles/`.
3. **pgAdmin GUI**: Interactive entry for rapid administrative changes. Screenshots in `Stage1/Screenshots1/`.

**Row counts:**

| Table             | Rows   |
| ----------------- | ------ |
| employees         | 500    |
| visitors          | 500    |
| ticket_types      | 500    |
| transactions      | 20,000 |
| transaction_items | 20,000 |
| memberships       | 500    |

---

## Backup

A full database dump was created for backup verification: `Stage2/backup.sql`.

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
│   ├── ERD/                    # Entity Relationship Diagrams
│   ├── Screenshots1/           # Execution evidence for Stage 1
│   ├── stage1-ui.html          # UI Prototype
│   └── MockarooFiles/          # Generated SQL datasets
│       ├── employees.sql
│       ├── visitors.sql
│       ├── ticket_types.sql
│       ├── transactions.sql
│       ├── transaction_items.sql
│       └── memberships.sql
│
├── init-db/                    # Auto-executed on container start
│   ├── 01-create-tables.sql
│   ├── 02-employees.sql
│   ├── 03-visitors.sql
│   ├── 04-ticket_types.sql
│   ├── 05-transactions.sql
│   ├── 06-transaction_items.sql
│   └── 07-seed-data.sql
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

### Overview

In this stage we queried the database, enforced data integrity using constraints, optimized performance using indexes, and demonstrated transaction control using COMMIT and ROLLBACK.

---

### SELECT QUERIES

We implemented 8 SELECT queries. 4 of them were written in two versions to compare efficiency.

---

#### 🔷 Query 1 – JOIN: מבקרים ומספר העסקאות שלהם (גרסה ראשונה)

**תיאור בעברית:**
שאילתא זו מחזירה את כל המבקרים יחד עם מספר העסקאות שביצע כל אחד מהם. השאילתא משתמשת ב-JOIN בין טבלת visitors לטבלת transactions ומקבצת את התוצאות לפי מבקר.

```sql
SELECT v.visitor_id, v.first_name, v.last_name,
       COUNT(tr.transaction_id) AS total_transactions
FROM visitors v
JOIN transactions tr ON v.visitor_id = tr.visitor_id
GROUP BY v.visitor_id, v.first_name, v.last_name
ORDER BY total_transactions DESC;
```

📸 Screenshot: `Q1_JOIN.png`

---

#### 🔷 Query 2 – Correlated Subquery: מבקרים ומספר העסקאות שלהם (גרסה שנייה)

**תיאור בעברית:**
שאילתא זו מחזירה את אותה תוצאה כמו שאילתא 1, אך משתמשת בתת-שאילתא מתואמת (correlated subquery) במקום JOIN — לכל שורה בטבלת visitors מתבצעת שאילתא נפרדת.

```sql
SELECT v.visitor_id, v.first_name, v.last_name,
    (SELECT COUNT(*) FROM transactions tr WHERE tr.visitor_id = v.visitor_id) AS total_transactions
FROM visitors v
ORDER BY total_transactions DESC;
```

📸 Screenshot: `Q2_SUBQUERY.png`

#### ⚖️ השוואת יעילות: JOIN לעומת Correlated Subquery

| גרסה | יתרון | חיסרון |
|------|-------|---------|
| JOIN (Q1) | PostgreSQL מבצע סריקה אחת של שתי הטבלאות — יעיל יותר | קוד מעט ארוך יותר |
| Subquery (Q2) | קריא יותר לעיתים | מריץ correlated subquery נפרדת לכל שורה — איטי יותר |

**מסקנה:** גרסת ה-JOIN יעילה יותר. ה-correlated subquery מריצה שאילתא נוספת עבור כל מבקר בנפרד, מה שהופך אותה לאיטית יותר על מסדי נתונים גדולים.

---

#### 🔷 Query 3 – DATE: עסקאות מ-30 הימים האחרונים (גרסה ראשונה)

**תיאור בעברית:**
שאילתא זו מחזירה את כל העסקאות שבוצעו ב-30 הימים האחרונים באמצעות השוואת תאריכים ישירה.

```sql
SELECT transaction_id, visitor_id, employee_id,
       transaction_date, total_amount, payment_method
FROM transactions
WHERE transaction_date >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY transaction_date DESC;
```

📸 Screenshot: `Q3_DATE.png`

---

#### 🔷 Query 4 – EXTRACT: עסקאות לפי חודש ושנה (גרסה שנייה)

**תיאור בעברית:**
שאילתא זו מחזירה עסקאות שבוצעו בחודש הנוכחי באמצעות פונקציית EXTRACT לפירוק התאריך לחלקיו — יום, חודש ושנה.

```sql
SELECT transaction_id, visitor_id, employee_id,
       transaction_date, total_amount,
       EXTRACT(DAY   FROM transaction_date) AS day,
       EXTRACT(MONTH FROM transaction_date) AS month,
       EXTRACT(YEAR  FROM transaction_date) AS year
FROM transactions
WHERE EXTRACT(MONTH FROM transaction_date) = EXTRACT(MONTH FROM CURRENT_DATE)
  AND EXTRACT(YEAR  FROM transaction_date) = EXTRACT(YEAR  FROM CURRENT_DATE)
ORDER BY transaction_date DESC;
```

📸 Screenshot: `Q4_EXTRACT.png`

#### ⚖️ השוואת יעילות: השוואת תאריך ישירה לעומת EXTRACT

| גרסה | יתרון | חיסרון |
|------|-------|---------|
| השוואה ישירה (Q3) | SARGable — יכולה להשתמש באינדקס על transaction_date | פחות גמישה לפילטרים לפי חלקי תאריך |
| EXTRACT (Q4) | מאפשרת פילטור לפי יום/חודש/שנה בנפרד | שוברת את האינדקס — גורמת ל-Seq Scan |

**מסקנה:** השוואת התאריך הישירה (Q3) יעילה יותר כי היא מאפשרת שימוש באינדקס. EXTRACT מחשבת ערך חדש לכל שורה ומונעת שימוש באינדקס.

---

#### 🔷 Query 5 – LIKE: חיפוש מבקרים לפי שם משפחה (גרסה ראשונה)

**תיאור בעברית:**
שאילתא זו מחזירה את כל המבקרים ששם משפחתם מתחיל באות 'A'. השאילתא תלויה באותיות גדולות וקטנות (case-sensitive).

```sql
SELECT visitor_id, first_name, last_name, email, phone
FROM visitors
WHERE last_name LIKE 'A%'
ORDER BY last_name;
```

📸 Screenshot: `Q5_LIKE.png`

---

#### 🔷 Query 6 – ILIKE: חיפוש מבקרים ללא תלות בגודל אות (גרסה שנייה)

**תיאור בעברית:**
שאילתא זו זהה לשאילתא 5 אך אינה מבחינה בין אותיות גדולות וקטנות — תמצא גם 'alex' וגם 'Alex'.

```sql
SELECT visitor_id, first_name, last_name, email, phone
FROM visitors
WHERE last_name ILIKE 'a%'
ORDER BY last_name;
```

📸 Screenshot: `Q6_ILIKE.png`

#### ⚖️ השוואת יעילות: LIKE לעומת ILIKE

| גרסה | יתרון | חיסרון |
|------|-------|---------|
| LIKE (Q5) | יכולה להשתמש באינדקס B-tree על last_name — מהירה יותר | תלויה באותיות גדולות/קטנות |
| ILIKE (Q6) | נוחה יותר למשתמש — מוצאת 'alex' ו-'Alex' | דורשת אינדקס מיוחד לביצועים אופטימליים |

**מסקנה:** LIKE מהירה יותר כי היא תואמת לאינדקס על last_name. ILIKE נוחה יותר למשתמש אבל איטית יותר ללא אינדקס מיוחד.

---

#### 🔷 Query 7 – AVG: ממוצע עסקאות למבקר

**תיאור בעברית:**
שאילתא זו מחשבת את המספר הממוצע של עסקאות שביצע כל מבקר, באמצעות תת-שאילתא ופונקציית AVG.

```sql
SELECT AVG(transaction_count) AS avg_transactions_per_visitor
FROM (
    SELECT visitor_id, COUNT(*) AS transaction_count
    FROM transactions
    GROUP BY visitor_id
) sub;
```

📸 Screenshot: `Q7_AVG.png`

---

#### 🔷 Query 8 – HAVING: מבקרים עם יותר מ-5 עסקאות

**תיאור בעברית:**
שאילתא זו מחזירה רק את המבקרים שביצעו יותר מ-5 עסקאות, תוך שימוש ב-GROUP BY ו-HAVING לסינון לאחר הקיבוץ.

```sql
SELECT v.visitor_id, v.first_name, v.last_name,
       COUNT(tr.transaction_id) AS total_transactions
FROM visitors v
JOIN transactions tr ON v.visitor_id = tr.visitor_id
GROUP BY v.visitor_id, v.first_name, v.last_name
HAVING COUNT(tr.transaction_id) > 5
ORDER BY total_transactions DESC;
```

📸 Screenshot: `Q8_HAVING.png`

---

### UPDATE QUERIES

#### 🔶 Update 1 – עדכון שם סוג כרטיס

**תיאור:** עדכון שם סוג הכרטיס בטבלת ticket_types עבור רשומה ספציפית.

```sql
-- לפני
SELECT * FROM ticket_types WHERE ticket_id = 1;

UPDATE ticket_types
SET ticket_name = 'VIP Experience'
WHERE ticket_id = 1;

-- אחרי
SELECT * FROM ticket_types WHERE ticket_id = 1;
```

📸 Screenshots: `UPDATE_BEFORE.png`, `UPDATE_AFTER.png`

---

#### 🔶 Update 2 – עדכון אימייל מבקר

**תיאור:** עדכון כתובת האימייל של מבקר ספציפי לפי מזהה.

```sql
-- לפני
SELECT * FROM visitors WHERE visitor_id = 1;

UPDATE visitors
SET email = 'updated@email.com'
WHERE visitor_id = 1;

-- אחרי
SELECT * FROM visitors WHERE visitor_id = 1;
```

---

#### 🔶 Update 3 – העלאת מחירי כרטיסים

**תיאור:** העלאת מחיר הבסיס של כל סוגי הכרטיסים ב-10%.

```sql
-- לפני
SELECT * FROM ticket_types;

UPDATE ticket_types
SET base_price = base_price * 1.1;

-- אחרי
SELECT * FROM ticket_types;
```

---

### DELETE QUERIES

#### 🔴 Delete 1 – מחיקת עסקאות ישנות

**תיאור:** מחיקת עסקאות שבוצעו לפני שנת 2022.

```sql
-- לפני
SELECT * FROM transactions WHERE transaction_date < '2022-01-01' LIMIT 5;

DELETE FROM transactions
WHERE transaction_date < '2022-01-01';

-- אחרי
SELECT * FROM transactions WHERE transaction_date < '2022-01-01';
```

📸 Screenshots: `DELETE_BEFORE.png`, `DELETE_AFTER.png`

---

#### 🔴 Delete 2 – מחיקת מבקר ספציפי

**תיאור:** מחיקת מבקר לפי מזהה ספציפי.

```sql
-- לפני
SELECT * FROM visitors WHERE visitor_id = 9999;

DELETE FROM visitors
WHERE visitor_id = 9999;

-- אחרי
SELECT * FROM visitors WHERE visitor_id = 9999;
```

---

#### 🔴 Delete 3 – מחיקת פריטי עסקה ישנים

**תיאור:** מחיקת פריטים מטבלת transaction_items שהעסקה שלהם בוצעה לפני 2022.

```sql
-- לפני
SELECT ti.* FROM transaction_items ti
JOIN transactions tr ON ti.transaction_id = tr.transaction_id
WHERE tr.transaction_date < '2022-01-01' LIMIT 5;

DELETE FROM transaction_items
WHERE transaction_id IN (
    SELECT transaction_id FROM transactions
    WHERE transaction_date < '2022-01-01'
);

-- אחרי
SELECT * FROM transaction_items LIMIT 5;
```

---

### TRANSACTION CONTROL (COMMIT & ROLLBACK)

#### Rollback Demo

**תיאור:** ביצוע עדכון, הצגת המצב החדש, ולאחר מכן ביטול השינוי עם ROLLBACK.

```sql
-- Step 1: Check current state
SELECT visitor_id, email FROM visitors WHERE visitor_id = 1;

-- Step 2: Begin transaction and update
BEGIN;

UPDATE visitors
SET email = 'rollback_test@email.com'
WHERE visitor_id = 1;

-- Step 3: State after update (change visible inside transaction)
SELECT visitor_id, email FROM visitors WHERE visitor_id = 1;

-- Step 4: Undo all changes
ROLLBACK;

-- Step 5: State after rollback (original value restored)
SELECT visitor_id, email FROM visitors WHERE visitor_id = 1;
```

📸 Screenshots: `Rollback_Step1_Empty.jpeg`, `Rollback_Step2_Restored.jpeg`

---

#### Commit Demo

**תיאור:** ביצוע עדכון, הצגת המצב החדש, ולאחר מכן שמירה קבועה עם COMMIT.

```sql
-- Step 1: Check current state
SELECT visitor_id, email FROM visitors WHERE visitor_id = 2;

-- Step 2: Begin transaction and update
BEGIN;

UPDATE visitors
SET email = 'commit_test@email.com'
WHERE visitor_id = 2;

-- Step 3: State after update
SELECT visitor_id, email FROM visitors WHERE visitor_id = 2;

-- Step 4: Save permanently
COMMIT;

-- Step 5: State after commit (change permanently saved)
SELECT visitor_id, email FROM visitors WHERE visitor_id = 2;
```

📸 Screenshot: `Commit_Success.jpeg`

---

### CONSTRAINTS

#### ✅ Constraint 1 – מחיר חיובי לכרטיס

**תיאור:** הוספת אילוץ CHECK שמבטיח שמחיר הכרטיס תמיד גדול מאפס.

```sql
ALTER TABLE ticket_types
ADD CONSTRAINT chk_base_price CHECK (base_price > 0);
```

**מוטיבציה:** מניעת הכנסת כרטיסים עם מחיר שלילי או אפס שאינו הגיוני עסקית.

📸 Screenshots: `Constraint1_Add_Success.jpeg`, `Constraint1_Trigger_Error.jpeg`

---

#### ✅ Constraint 2 – ייחודיות מספר טלפון

**תיאור:** הוספת אילוץ UNIQUE על עמודת phone של המבקרים.

```sql
ALTER TABLE visitors
ADD CONSTRAINT uq_visitor_phone UNIQUE (phone);
```

**מוטיבציה:** מניעת רישום אותו מספר טלפון פעמיים, מבטיח שכל מבקר ייחודי במערכת.

📸 Screenshots: `Constraint2_Add_Success.jpeg`, `Constraint2_Trigger_Error.jpeg`, `Constraint2_Valid_Insert_Moshe.jpeg`

---

#### ✅ Constraint 3 – קטגוריית כרטיס חוקית

**תיאור:** הוספת אילוץ CHECK שמגביל את עמודת category לערכים מוגדרים מראש.

```sql
ALTER TABLE ticket_types
ADD CONSTRAINT chk_category CHECK (category IN ('Regular', 'Child', 'Student', 'Senior', 'VIP'));
```

**מוטיבציה:** מניעת הכנסת קטגוריות לא חוקיות שעלולות לגרום לשגיאות בהמשך במערכת.

📸 Screenshots: `Constraint3_Add_Success.jpeg`, `Constraint3_Trigger_Error.jpeg`, `Constraint3_Valid_Insert.jpeg`

---

### INDEXES

#### ⚡ Index 1 – תאריך עסקה

```sql
CREATE INDEX idx_transactions_date ON transactions(transaction_date);
```

**מוטיבציה:** שאילתות רבות מסננות לפי transaction_date. האינדקס מאפשר Index Scan במקום Seq Scan.

**תוצאות:** שיפור בזמן ריצה נצפה בתוצאות EXPLAIN ANALYZE לפני ואחרי יצירת האינדקס.

📸 Screenshots: `Index1_Before_Execution.jpeg`, `Index1_After_Execution.jpeg`, `Index1_Create_Success.jpeg`

---

#### ⚡ Index 2 – מזהה מבקר בעסקאות

```sql
CREATE INDEX idx_transactions_visitor_id ON transactions(visitor_id);
```

**מוטיבציה:** שאילתות JOIN בין visitors לטבלת transactions מבוצעות לפי visitor_id. האינדקס מאיץ את החיבור בין הטבלאות.

**תוצאות:** שיפור בזמן ריצה של שאילתות JOIN על מסדי נתונים גדולים.

📸 Screenshots: `Index2_Before_Execution.jpeg`, `Index2_After_Execution.jpeg`, `Index2_Create_Success.jpeg`

---

#### ⚡ Index 3 – שם משפחה של מבקר

```sql
CREATE INDEX idx_visitors_last_name ON visitors(last_name);
```

**מוטיבציה:** חיפוש מבקרים לפי last_name (LIKE 'A%') הוא פעולה נפוצה בקופת הכרטיסים. האינדקס תומך בחיפושי קידומת ביעילות.

**תוצאות:** שאילתות LIKE עם קידומת קבועה הפכו מהירות יותר לאחר יצירת האינדקס.

📸 Screenshots: `Index3_Before_Execution.jpeg`, `Index3_After_Execution.jpeg`, `Index3_Create_Success.jpeg`, `Index3_Mass_Data_Insert.jpeg`

---

## Conclusion

Stage 2 focused on transforming a structured relational schema into an optimized, production-ready system. By applying 3NF normalization, strategic indexing, and strict integrity constraints, we developed a system that is scalable, efficient, and resilient to data entry errors.

---

## Stage 2 Tag

`stage2`

---

# Stage 3 – Integration & Views

## Overview

In this stage we integrated our Ticket & Visitor Management System with another team's Zoo Admin Project Management System. The integration connects the two systems through the employee-manager relationship, creating a unified database that combines visitor ticketing data with project management data.

---

## The Other Team's System

The Zoo Admin system manages the administrative side of the zoo with 6 tables:

| Table | Description |
|-------|-------------|
| manager | Zoo managers with seniority levels |
| project | Projects with budgets, dates and status |
| task | Tasks linked to projects with priority levels |
| report | Management reports per department |
| kpi | KPI metrics measured per project |
| audit | Audit findings per project and manager |

---

## Reverse Engineering Algorithm

To reconstruct the ERD from the other team's schema, we followed these steps:

1. **Identify entities** — each table becomes an entity in the ERD
2. **Identify primary keys** — single PKs become simple identifiers; composite PKs indicate weak entities or relationship tables
3. **Identify foreign keys** — each FK represents a relationship between two entities; the FK side is "many", the referenced side is "one"
4. **Determine cardinality** — from FK constraints: `manager → project` is 1:N, `project → task` is 1:N, etc.
5. **Identify weak entities** — tables that cannot exist without another table (e.g. task cannot exist without project)
6. **Reconstruct the ERD** — draw entities, relationships, and cardinalities based on the above analysis

---

## Integration Design Decisions

| Decision | Reasoning |
|----------|-----------|
| Link `employees` to `manager` via `manager_id` | Both systems have staff — our employees report to their managers |
| Divide 500 employees across 3 managers | Even distribution: manager 1 → IDs 1-166, manager 2 → 167-333, manager 3 → 334-500 |
| Keep all original tables unchanged | Instructions require ALTER TABLE, not recreating tables |
| Use `IF NOT EXISTS` for new tables | Safe to run multiple times without errors |

---

## Integration SQL

The integration was performed using `Integrate.sql` which:
1. Creates the other team's 6 tables
2. Inserts their data (managers, projects, tasks, reports, KPIs, audits)
3. Adds `manager_id` column to our `employees` table
4. Links employees to managers via foreign key
5. Updates all 500 employees with their assigned manager

---

## Combined Row Counts After Integration

| Table | Rows |
|-------|------|
| employees | 500 |
| visitors | 500 |
| ticket_types | 500 |
| transactions | 20,000 |
| transaction_items | 20,000 |
| memberships | 500 |
| manager | 3 |
| project | 3 |
| task | 3 |
| report | 3 |
| kpi | 3 |
| audit | 3 |

---

## Views

### 👁️ View 1: view_employee_manager
**Our system's perspective** — joins our `employees` table with the other team's `manager` and `project` tables. Shows each employee alongside their manager's details and the project that manager is responsible for.

```sql
CREATE OR REPLACE VIEW view_employee_manager AS
SELECT
    e.employee_id,
    e.first_name        AS employee_first_name,
    e.last_name         AS employee_last_name,
    e.hire_date,
    m.manager_id,
    m.first_name        AS manager_first_name,
    m.last_name         AS manager_last_name,
    m.seniority_level,
    p.project_name,
    p.status            AS project_status,
    p.budget
FROM employees e
JOIN manager m ON e.manager_id = m.manager_id
JOIN project p ON p.manager_id = m.manager_id;
```

#### Query 1.1 – Number of employees per manager
Shows how many employees each manager supervises, along with their seniority level. Useful for understanding management load across the organization.

```sql
SELECT
    manager_first_name || ' ' || manager_last_name AS manager_name,
    seniority_level,
    COUNT(DISTINCT employee_id) AS total_employees
FROM view_employee_manager
GROUP BY manager_name, seniority_level
ORDER BY total_employees DESC;
```

📸 Screenshot: `view1_query1.png`

#### Query 1.2 – Recently hired employees and their manager's project
Returns all employees hired after January 2022, showing which manager they report to and which project that manager is running. Useful for onboarding reports and project staffing overview.

```sql
SELECT
    employee_first_name || ' ' || employee_last_name AS employee_name,
    hire_date,
    manager_first_name || ' ' || manager_last_name AS manager_name,
    project_name,
    project_status
FROM view_employee_manager
WHERE hire_date >= '2022-01-01'
ORDER BY hire_date DESC
LIMIT 10;
```

📸 Screenshot: `view1_query2.png`

---

### 👁️ View 2: view_project_transactions
**Other team's perspective** — connects the other team's project management system with our ticketing system. Shows how visitor transactions relate to active projects through the employee-manager link, giving a full picture of revenue generated under each project.

```sql
CREATE OR REPLACE VIEW view_project_transactions AS
SELECT
    p.project_id,
    p.project_name,
    p.status            AS project_status,
    p.budget,
    m.first_name || ' ' || m.last_name AS manager_name,
    m.seniority_level,
    e.employee_id,
    e.first_name        AS employee_first_name,
    e.last_name         AS employee_last_name,
    t.transaction_id,
    t.transaction_date,
    t.total_amount,
    t.payment_method,
    v.first_name        AS visitor_first_name,
    v.last_name         AS visitor_last_name
FROM project p
JOIN manager m      ON m.manager_id     = p.manager_id
JOIN employees e    ON e.manager_id     = m.manager_id
JOIN transactions t ON t.employee_id    = e.employee_id
JOIN visitors v     ON v.visitor_id     = t.visitor_id;
```

#### Query 2.1 – Total revenue per project
Calculates the total number of transactions and total revenue generated under each project, by tracing which employees handled the transactions and which project their manager is responsible for.

```sql
SELECT
    project_name,
    project_status,
    COUNT(transaction_id)   AS total_transactions,
    SUM(total_amount)       AS total_revenue
FROM view_project_transactions
GROUP BY project_name, project_status
ORDER BY total_revenue DESC;
```

📸 Screenshot: `view2_query1.png`

#### Query 2.2 – Average transaction amount per manager
Shows the average transaction value handled by employees under each manager, grouped by manager name and seniority level. Useful for evaluating manager performance and identifying which teams process higher-value transactions.

```sql
SELECT
    manager_name,
    seniority_level,
    COUNT(transaction_id)       AS total_transactions,
    ROUND(AVG(total_amount), 2) AS avg_transaction_amount
FROM view_project_transactions
GROUP BY manager_name, seniority_level
ORDER BY avg_transaction_amount DESC;
```

📸 Screenshot: `view2_query2.png`

---

## Stage 3 Tag

`stage3`

---

# Stage 4 – PL/pgSQL Programming

## Overview

In this stage we implemented PL/pgSQL programs including functions, procedures, triggers, and main programs. All programs operate on the integrated database created in Stage 3.

---

## Database Changes (AlterTable.sql)

The following columns and tables were added to support the programs:

```sql
ALTER TABLE visitors ADD COLUMN IF NOT EXISTS loyalty_points INT DEFAULT 0;
ALTER TABLE visitors ADD COLUMN IF NOT EXISTS last_activity_date DATE;
ALTER TABLE employees ADD COLUMN IF NOT EXISTS bonus_amount NUMERIC(10,2) DEFAULT 0;
ALTER TABLE memberships ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT TRUE;
CREATE TABLE IF NOT EXISTS ticket_price_log (
    log_id      SERIAL PRIMARY KEY,
    ticket_id   INT NOT NULL,
    old_price   NUMERIC(10,2),
    new_price   NUMERIC(10,2),
    changed_at  TIMESTAMP DEFAULT NOW()
);
```

---

## FUNCTION 1: get_visitor_summary

**Description:**
This function receives a visitor_id and returns a summary of that visitor including their full name, total number of transactions, total amount spent, loyalty points, and membership status. It uses an explicit cursor to loop through transactions, updates the visitor's loyalty points in the database, and handles exceptions gracefully.

**Elements used:** Explicit cursor, record, DML (UPDATE), branches (IF/ELSIF/ELSE), loop, exception handling.

```sql
CREATE OR REPLACE FUNCTION get_visitor_summary(p_visitor_id INT)
RETURNS TABLE (
    visitor_name        TEXT,
    total_transactions  BIGINT,
    total_spent         NUMERIC,
    loyalty_points      INT,
    membership_status   TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_record        visitors%ROWTYPE;
    v_trans_count   BIGINT := 0;
    v_total_spent   NUMERIC := 0;
    v_loyalty       INT := 0;
    v_membership    TEXT := 'No Membership';
    cur_transactions CURSOR FOR
        SELECT total_amount FROM transactions WHERE visitor_id = p_visitor_id;
    v_trans_row RECORD;
BEGIN
    BEGIN
        SELECT * INTO STRICT v_record FROM visitors WHERE visitor_id = p_visitor_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE EXCEPTION 'Visitor with ID % not found', p_visitor_id;
    END;
    OPEN cur_transactions;
    LOOP
        FETCH cur_transactions INTO v_trans_row;
        EXIT WHEN NOT FOUND;
        v_trans_count := v_trans_count + 1;
        v_total_spent := v_total_spent + v_trans_row.total_amount;
    END LOOP;
    CLOSE cur_transactions;
    v_loyalty := v_trans_count * 10;
    UPDATE visitors SET loyalty_points = v_loyalty, last_activity_date = CURRENT_DATE
    WHERE visitor_id = p_visitor_id;
    IF EXISTS (SELECT 1 FROM memberships WHERE visitor_id = p_visitor_id AND is_active = TRUE AND expiry_date >= CURRENT_DATE) THEN
        v_membership := 'Active Member';
    ELSIF EXISTS (SELECT 1 FROM memberships WHERE visitor_id = p_visitor_id) THEN
        v_membership := 'Expired Member';
    ELSE
        v_membership := 'No Membership';
    END IF;
    RETURN QUERY SELECT v_record.first_name || ' ' || v_record.last_name, v_trans_count, v_total_spent, v_loyalty, v_membership;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in get_visitor_summary: %', SQLERRM;
END;
$$;
```

📸 Screenshot: `func1_created.png`

---

## FUNCTION 2: get_employee_report

**Description:**
This function returns a REF CURSOR containing a full performance report for all employees. It loops through every employee using an explicit cursor, counts their transactions, calculates total revenue handled, classifies their performance level (Excellent/Good/Average/Low), and stores results in a temp table. The ref cursor is opened on that temp table and returned.

**Elements used:** Explicit cursor, ref cursor (returned), record, DML (INSERT), branches, loop, exception handling.

```sql
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
    cur_employees CURSOR FOR
        SELECT e.employee_id, e.first_name, e.last_name, e.hire_date, e.bonus_amount,
               COALESCE(m.first_name || ' ' || m.last_name, 'No Manager') AS manager_name
        FROM employees e
        LEFT JOIN manager m ON e.manager_id = m.manager_id
        ORDER BY e.employee_id;
BEGIN
    DROP TABLE IF EXISTS temp_employee_report;
    CREATE TEMP TABLE temp_employee_report (
        employee_id INT, employee_name TEXT, hire_date DATE,
        manager_name TEXT, total_transactions INT,
        total_revenue NUMERIC, bonus_amount NUMERIC, performance TEXT
    );
    OPEN cur_employees;
    LOOP
        FETCH cur_employees INTO v_emp_record;
        EXIT WHEN NOT FOUND;
        SELECT COUNT(*), COALESCE(SUM(total_amount), 0)
        INTO v_trans_count, v_total_revenue
        FROM transactions WHERE employee_id = v_emp_record.employee_id;
        IF v_trans_count >= 100 THEN v_performance := 'Excellent';
        ELSIF v_trans_count >= 50 THEN v_performance := 'Good';
        ELSIF v_trans_count >= 10 THEN v_performance := 'Average';
        ELSE v_performance := 'Low';
        END IF;
        INSERT INTO temp_employee_report VALUES (
            v_emp_record.employee_id, v_emp_record.first_name || ' ' || v_emp_record.last_name,
            v_emp_record.hire_date, v_emp_record.manager_name,
            v_trans_count, v_total_revenue, v_emp_record.bonus_amount, v_performance
        );
    END LOOP;
    CLOSE cur_employees;
    OPEN ref_cur FOR SELECT * FROM temp_employee_report ORDER BY total_revenue DESC;
    RETURN ref_cur;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in get_employee_report: %', SQLERRM;
END;
$$;
```

📸 Screenshot: `func2_created.png`

---

## PROCEDURE 1: update_employee_bonuses

**Description:**
This procedure loops through all employees and calculates a bonus based on the total revenue they handled in transactions. Employees with revenue above 100,000 get 5%, above 50,000 get 3%, above 10,000 get 1%, and others get no bonus. It updates the bonus_amount column for each employee and prints a summary using RAISE NOTICE.

**Elements used:** Explicit cursor, record, DML (UPDATE), branches (bonus tiers), loop, exception handling.

```sql
CREATE OR REPLACE PROCEDURE update_employee_bonuses()
LANGUAGE plpgsql
AS $$
DECLARE
    v_emp_record    RECORD;
    v_revenue       NUMERIC;
    v_bonus         NUMERIC;
    v_updated_count INT := 0;
    cur_emp CURSOR FOR
        SELECT employee_id, first_name, last_name FROM employees ORDER BY employee_id;
BEGIN
    OPEN cur_emp;
    LOOP
        FETCH cur_emp INTO v_emp_record;
        EXIT WHEN NOT FOUND;
        SELECT COALESCE(SUM(total_amount), 0) INTO v_revenue
        FROM transactions WHERE employee_id = v_emp_record.employee_id;
        IF v_revenue >= 100000 THEN v_bonus := v_revenue * 0.05;
        ELSIF v_revenue >= 50000 THEN v_bonus := v_revenue * 0.03;
        ELSIF v_revenue >= 10000 THEN v_bonus := v_revenue * 0.01;
        ELSE v_bonus := 0;
        END IF;
        UPDATE employees SET bonus_amount = v_bonus WHERE employee_id = v_emp_record.employee_id;
        v_updated_count := v_updated_count + 1;
        IF v_bonus > 0 THEN
            RAISE NOTICE 'Employee % % received bonus: %', v_emp_record.first_name, v_emp_record.last_name, v_bonus;
        END IF;
    END LOOP;
    CLOSE cur_emp;
    RAISE NOTICE 'Bonus update complete. % employees processed.', v_updated_count;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in update_employee_bonuses: %', SQLERRM;
END;
$$;
```

📸 Screenshot: `proc1_created.png`

---

## PROCEDURE 2: expire_old_memberships

**Description:**
This procedure loops through all memberships and checks if each one has passed its expiry date. If expired and still marked active, it sets is_active to FALSE and deducts 50 loyalty points from the visitor as a penalty. It prints a summary of how many memberships were expired during the run.

**Elements used:** Explicit cursor, record, DML (UPDATE x2), branches, loop, exception handling.

```sql
CREATE OR REPLACE PROCEDURE expire_old_memberships()
LANGUAGE plpgsql
AS $$
DECLARE
    v_mem_record    RECORD;
    v_expired_count INT := 0;
    v_already_count INT := 0;
    cur_memberships CURSOR FOR
        SELECT m.membership_id, m.visitor_id, m.expiry_date, m.is_active,
               v.first_name || ' ' || v.last_name AS visitor_name
        FROM memberships m JOIN visitors v ON m.visitor_id = v.visitor_id
        ORDER BY m.membership_id;
BEGIN
    OPEN cur_memberships;
    LOOP
        FETCH cur_memberships INTO v_mem_record;
        EXIT WHEN NOT FOUND;
        IF v_mem_record.expiry_date < CURRENT_DATE AND v_mem_record.is_active = TRUE THEN
            UPDATE memberships SET is_active = FALSE WHERE membership_id = v_mem_record.membership_id;
            UPDATE visitors SET loyalty_points = GREATEST(0, loyalty_points - 50) WHERE visitor_id = v_mem_record.visitor_id;
            v_expired_count := v_expired_count + 1;
            RAISE NOTICE 'Membership % for visitor % has been expired.', v_mem_record.membership_id, v_mem_record.visitor_name;
        ELSIF v_mem_record.is_active = FALSE THEN
            v_already_count := v_already_count + 1;
        END IF;
    END LOOP;
    CLOSE cur_memberships;
    RAISE NOTICE 'Expiry process complete. Newly expired: %, Already inactive: %.', v_expired_count, v_already_count;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in expire_old_memberships: %', SQLERRM;
END;
$$;
```

📸 Screenshot: `proc2_created.png`

---

## TRIGGER 1: trg_update_loyalty_points

**Description:**
This trigger fires AFTER INSERT on the transactions table. When a new transaction is added, it automatically adds 10 loyalty points to the visitor who made the transaction and updates their last_activity_date to today. This ensures loyalty points are always up to date without needing to call a function manually.

**Trigger type:** AFTER INSERT on transactions

```sql
CREATE OR REPLACE FUNCTION trg_fn_update_loyalty_points()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
    v_current_points INT;
BEGIN
    SELECT loyalty_points INTO v_current_points FROM visitors WHERE visitor_id = NEW.visitor_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Visitor % not found when updating loyalty points', NEW.visitor_id;
    END IF;
    UPDATE visitors
    SET loyalty_points = COALESCE(v_current_points, 0) + 10, last_activity_date = CURRENT_DATE
    WHERE visitor_id = NEW.visitor_id;
    RAISE NOTICE 'Loyalty points updated for visitor %. New total: %', NEW.visitor_id, COALESCE(v_current_points, 0) + 10;
    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN RAISE EXCEPTION 'Error in trg_update_loyalty_points: %', SQLERRM;
END;
$$;

DROP TRIGGER IF EXISTS trg_update_loyalty_points ON transactions;
CREATE TRIGGER trg_update_loyalty_points
AFTER INSERT ON transactions FOR EACH ROW
EXECUTE FUNCTION trg_fn_update_loyalty_points();
```

📸 Screenshot: `trg1_created.png`

---

## TRIGGER 2: trg_log_price_change

**Description:**
This trigger fires AFTER UPDATE on the ticket_types table. When a ticket's base_price is changed, the trigger logs the old and new price into the ticket_price_log table, providing a full audit trail of all price changes. If the price did not actually change, the trigger skips the log entry.

**Trigger type:** AFTER UPDATE on ticket_types

```sql
CREATE OR REPLACE FUNCTION trg_fn_log_price_change()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF OLD.base_price <> NEW.base_price THEN
        INSERT INTO ticket_price_log (ticket_id, old_price, new_price, changed_at)
        VALUES (NEW.ticket_id, OLD.base_price, NEW.base_price, NOW());
        RAISE NOTICE 'Price change logged for ticket %. Old: %, New: %', NEW.ticket_id, OLD.base_price, NEW.base_price;
    ELSE
        RAISE NOTICE 'No price change detected for ticket %. Skipping log.', NEW.ticket_id;
    END IF;
    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN RAISE EXCEPTION 'Error in trg_log_price_change: %', SQLERRM;
END;
$$;

DROP TRIGGER IF EXISTS trg_log_price_change ON ticket_types;
CREATE TRIGGER trg_log_price_change
AFTER UPDATE ON ticket_types FOR EACH ROW
EXECUTE FUNCTION trg_fn_log_price_change();
```

📸 Screenshot: `trg2_created.png`

---

## MAIN PROGRAM 1

**Description:**
This main program demonstrates Function 1 (get_visitor_summary) and Procedure 1 (update_employee_bonuses). It calls the function to get a summary for visitor 1, prints the result using RAISE NOTICE, then calls the procedure to update all employee bonuses and shows the top 5 earners.

📸 Screenshot: `main1_output.png`

---

## MAIN PROGRAM 2

**Description:**
This main program demonstrates Procedure 2 (expire_old_memberships) and Function 2 (get_employee_report). It first calls the procedure to expire old memberships, then calls the function which returns a ref cursor, fetches the results row by row, and prints the top 10 employees by revenue.

📸 Screenshot: `main2_output.png`

---

## Stage 4 Tag

`stage4`

---

# Stage 5 – Graphical User Interface

## Overview

In this stage we built a full graphical user interface (GUI) for the Zoo Ticket & Visitor Management System using **Python** and **Tkinter**. The application connects directly to the PostgreSQL database running in Docker and supports all CRUD operations, query execution, and function/procedure invocation.

---

## Technologies Used

- **Python 3.12** — application language
- **Tkinter** — GUI framework (built into Python)
- **psycopg2** — PostgreSQL database connector
- **Docker** — database runs in container as before

---

## How to Run

### Step 1 – Install dependency
```bash
pip3 install psycopg2-binary --break-system-packages
```

### Step 2 – Start Docker
```bash
docker-compose up -d
```

### Step 3 – Run the application
```bash
cd Stage5
python3 app.py
```

### Step 4 – Login
- Username: `admin`
- Password: `admin`

---

## Application Screens

### 🔐 Login Screen
Clean login screen with username and password fields. Verifies database connectivity on login.

📸 Screenshot: `screen_login.png`

---

### 🏠 Dashboard
Overview of the entire system showing live row counts for all 6 main tables: Visitors, Employees, Transactions, Ticket Types, Memberships, and Managers.

📸 Screenshot: `screen_dashboard.png`

---

### 📋 Table Screens (CRUD)
Every table in the database is accessible from the sidebar. Each table screen supports:

- **View** — displays all records in a clean table with real names instead of IDs (foreign keys are joined and displayed as names)
- **Insert** — form to add a new record
- **Update** — enter the record ID, click Load Record to populate fields, edit and save
- **Delete** — enter the record ID to delete with confirmation dialog
- **Refresh** — reload data from database

Tables available: Visitors, Employees, Ticket Types, Transactions, Transaction Items, Memberships, Managers, Projects, Tasks, Reports, KPIs, Audit

📸 Screenshots: `screen_visitors.png`, `screen_insert.png`, `screen_update.png`, `screen_delete.png`

---

### ⚡ Queries Screen
Run Stage 2 SELECT queries directly from the interface. Select a query from the dropdown and click Run Query to see results in a live table.

Queries available:
- Q1 – Visitors & Transaction Count (JOIN)
- Q3 – Transactions in Last 30 Days
- Q7 – Average Transactions Per Visitor
- Q8 – Visitors With More Than 5 Transactions (HAVING)

📸 Screenshot: `screen_queries.png`

---

### ⚙️ Functions & Procedures Screen
Run Stage 4 PL/pgSQL programs directly from the interface. Four cards are shown:

- **get_visitor_summary** — enter a visitor ID and get their full summary (name, transactions, spent, loyalty points, membership status)
- **update_employee_bonuses** — run the procedure to update all employee bonuses based on revenue
- **expire_old_memberships** — run the procedure to expire outdated memberships
- **get_employee_report** — run the function to get the full employee performance report

📸 Screenshot: `screen_functions.png`

---

## Stage 5 Tag

`stage5`