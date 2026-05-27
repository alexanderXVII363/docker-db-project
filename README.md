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