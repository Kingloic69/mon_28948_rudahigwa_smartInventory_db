# Data Dictionary

## Smart Inventory Theft-Detection & Real-Time Stock Monitoring System

### Overview

This document provides a comprehensive data dictionary for all tables, columns, constraints, and relationships in the database.

---

## Table: INVENTORY_ITEMS

**Purpose:** Master table storing all inventory item information.

| Column       | Type          | Constraints                     | Purpose                                      |
| ------------ | ------------- | ------------------------------- | -------------------------------------------- |
| item_id      | NUMBER(10)    | PK, NOT NULL                    | Unique identifier for each item              |
| item_name    | VARCHAR2(100) | NOT NULL                        | Name of the inventory item                   |
| item_code    | VARCHAR2(50)  | UNIQUE, NOT NULL                | Unique code for item identification          |
| category     | VARCHAR2(50)  | NOT NULL                        | Item category (Electronics, Furniture, etc.) |
| description  | VARCHAR2(500) | NULL                            | Detailed description of the item             |
| unit_price   | NUMBER(10,2)  | NOT NULL, CHECK >= 0            | Price per unit of the item                   |
| supplier     | VARCHAR2(100) | NULL                            | Supplier name                                |
| is_active    | CHAR(1)       | DEFAULT 'Y', CHECK IN ('Y','N') | Active status flag                           |
| created_date | DATE          | DEFAULT SYSDATE                 | Record creation timestamp                    |
| last_updated | DATE          | DEFAULT SYSDATE                 | Last update timestamp                        |

**Indexes:**

- Primary Key: item_id
- Unique: item_code
- Index: category, is_active

**Relationships:**

- One-to-Many with STOCK_LEVELS
- One-to-Many with STOCK_MOVEMENTS
- One-to-Many with THEFT_ALERTS

---

## Table: STOCK_LEVELS

**Purpose:** Current stock levels and reorder information for each item.

| Column           | Type          | Constraints                  | Purpose                            |
| ---------------- | ------------- | ---------------------------- | ---------------------------------- |
| stock_id         | NUMBER(10)    | PK, NOT NULL                 | Unique identifier for stock record |
| item_id          | NUMBER(10)    | FK, NOT NULL                 | Reference to inventory item        |
| current_quantity | NUMBER(10)    | NOT NULL, CHECK >= 0         | Current stock quantity             |
| reorder_level    | NUMBER(10)    | NOT NULL, CHECK >= 0         | Minimum stock level before reorder |
| maximum_level    | NUMBER(10)    | NULL, CHECK >= reorder_level | Maximum stock capacity             |
| location         | VARCHAR2(100) | NULL                         | Physical storage location          |
| last_updated     | DATE          | DEFAULT SYSDATE              | Last update timestamp              |

**Indexes:**

- Primary Key: stock_id
- Foreign Key: item_id → inventory_items(item_id)
- Index: item_id, location

**Relationships:**

- Many-to-One with INVENTORY_ITEMS

---

## Table: EMPLOYEES

**Purpose:** Employee information for access control and movement tracking.

| Column        | Type          | Constraints                     | Purpose                        |
| ------------- | ------------- | ------------------------------- | ------------------------------ |
| employee_id   | NUMBER(10)    | PK, NOT NULL                    | Unique identifier for employee |
| employee_name | VARCHAR2(100) | NOT NULL                        | Full name of employee          |
| employee_code | VARCHAR2(50)  | UNIQUE, NOT NULL                | Unique employee code           |
| department    | VARCHAR2(50)  | NOT NULL                        | Department name                |
| position      | VARCHAR2(50)  | NULL                            | Job position/title             |
| email         | VARCHAR2(100) | NULL                            | Email address                  |
| phone         | VARCHAR2(20)  | NULL                            | Phone number                   |
| is_active     | CHAR(1)       | DEFAULT 'Y', CHECK IN ('Y','N') | Active status flag             |
| created_date  | DATE          | DEFAULT SYSDATE                 | Record creation timestamp      |

**Indexes:**

- Primary Key: employee_id
- Unique: employee_code

**Relationships:**

- One-to-Many with STOCK_MOVEMENTS
- One-to-Many with THEFT_ALERTS

---

## Table: STOCK_MOVEMENTS

**Purpose:** All inventory transactions and movements (IN, OUT, ADJUSTMENT, etc.).

| Column           | Type          | Constraints                                                         | Purpose                               |
| ---------------- | ------------- | ------------------------------------------------------------------- | ------------------------------------- |
| movement_id      | NUMBER(10)    | PK, NOT NULL                                                        | Unique identifier for movement        |
| item_id          | NUMBER(10)    | FK, NOT NULL                                                        | Reference to inventory item           |
| movement_type    | VARCHAR2(20)  | NOT NULL, CHECK IN ('IN','OUT','ADJUSTMENT','STOCK_CHECK','RETURN') | Type of movement                      |
| quantity         | NUMBER(10)    | NOT NULL                                                            | Quantity moved (positive or negative) |
| movement_date    | DATE          | DEFAULT SYSDATE, NOT NULL                                           | Date and time of movement             |
| employee_id      | NUMBER(10)    | FK, NULL                                                            | Employee who performed the movement   |
| reference_number | VARCHAR2(50)  | NULL                                                                | Reference number (PO, invoice, etc.)  |
| notes            | VARCHAR2(500) | NULL                                                                | Additional notes                      |
| location         | VARCHAR2(100) | NULL                                                                | Location of movement                  |

**Indexes:**

- Primary Key: movement_id
- Foreign Key: item_id → inventory_items(item_id)
- Foreign Key: employee_id → employees(employee_id)
- Index: item_id, movement_date, movement_type, employee_id

**Relationships:**

- Many-to-One with INVENTORY_ITEMS
- Many-to-One with EMPLOYEES

---

## Table: THEFT_ALERTS

**Purpose:** Theft detection alerts and their resolution status.

| Column             | Type           | Constraints                                                                             | Purpose                                 |
| ------------------ | -------------- | --------------------------------------------------------------------------------------- | --------------------------------------- |
| alert_id           | NUMBER(10)     | PK, NOT NULL                                                                            | Unique identifier for alert             |
| item_id            | NUMBER(10)     | FK, NOT NULL                                                                            | Reference to inventory item             |
| alert_date         | DATE           | DEFAULT SYSDATE, NOT NULL                                                               | Date and time alert was generated       |
| alert_severity     | VARCHAR2(20)   | NOT NULL, CHECK IN ('HIGH','MEDIUM','LOW')                                              | Severity level of alert                 |
| suspected_quantity | NUMBER(10)     | NOT NULL                                                                                | Quantity suspected to be stolen         |
| employee_id        | NUMBER(10)     | FK, NULL                                                                                | Employee associated with alert (if any) |
| status             | VARCHAR2(20)   | DEFAULT 'ACTIVE', CHECK IN ('ACTIVE','RESOLVED','FALSE_POSITIVE','UNDER_INVESTIGATION') | Current status of alert                 |
| resolution_date    | DATE           | NULL                                                                                    | Date alert was resolved                 |
| outcome            | VARCHAR2(50)   | NULL                                                                                    | Resolution outcome                      |
| resolution_notes   | VARCHAR2(1000) | NULL                                                                                    | Notes about resolution                  |

**Indexes:**

- Primary Key: alert_id
- Foreign Key: item_id → inventory_items(item_id)
- Foreign Key: employee_id → employees(employee_id)
- Index: item_id, alert_date, status, alert_severity

**Relationships:**

- Many-to-One with INVENTORY_ITEMS
- Many-to-One with EMPLOYEES

---

## Table: AUDIT_LOG

**Purpose:** Comprehensive audit trail for all database operations.

| Column         | Type          | Constraints                                     | Purpose                            |
| -------------- | ------------- | ----------------------------------------------- | ---------------------------------- |
| audit_id       | NUMBER(10)    | PK, NOT NULL                                    | Unique identifier for audit record |
| table_name     | VARCHAR2(50)  | NOT NULL                                        | Name of table being audited        |
| operation_type | VARCHAR2(20)  | NOT NULL, CHECK IN ('INSERT','UPDATE','DELETE') | Type of operation                  |
| operation_date | DATE          | DEFAULT SYSDATE, NOT NULL                       | Date and time of operation         |
| user_name      | VARCHAR2(100) | NOT NULL                                        | User who performed operation       |
| old_values     | CLOB          | NULL                                            | Previous values (JSON format)      |
| new_values     | CLOB          | NULL                                            | New values (JSON format)           |
| ip_address     | VARCHAR2(50)  | NULL                                            | IP address of user                 |
| status         | VARCHAR2(20)  | NOT NULL, CHECK IN ('SUCCESS','DENIED')         | Operation status                   |
| error_message  | VARCHAR2(500) | NULL                                            | Error message if denied            |

**Indexes:**

- Primary Key: audit_id
- Index: table_name, operation_date, user_name, status

**Relationships:**

- No foreign key relationships (standalone audit table)

---

## Table: HOLIDAYS

**Purpose:** Public holidays for business rule enforcement (weekday/holiday restrictions).

| Column       | Type          | Constraints                     | Purpose                         |
| ------------ | ------------- | ------------------------------- | ------------------------------- |
| holiday_id   | NUMBER(10)    | PK, NOT NULL                    | Unique identifier for holiday   |
| holiday_name | VARCHAR2(100) | NOT NULL                        | Name of the holiday             |
| holiday_date | DATE          | NOT NULL, UNIQUE                | Date of the holiday             |
| is_recurring | CHAR(1)       | DEFAULT 'N', CHECK IN ('Y','N') | Whether holiday recurs annually |
| created_date | DATE          | DEFAULT SYSDATE                 | Record creation timestamp       |

**Indexes:**

- Primary Key: holiday_id
- Unique: holiday_date
- Index: holiday_date

**Relationships:**

- No foreign key relationships (standalone reference table)

---

## Entity-Relationship Summary

### Primary Relationships:

1. **INVENTORY_ITEMS** → **STOCK_LEVELS** (1:1)

   - Each item has one stock level record

2. **INVENTORY_ITEMS** → **STOCK_MOVEMENTS** (1:Many)

   - Each item can have multiple movements

3. **INVENTORY_ITEMS** → **THEFT_ALERTS** (1:Many)

   - Each item can have multiple alerts

4. **EMPLOYEES** → **STOCK_MOVEMENTS** (1:Many)

   - Each employee can perform multiple movements

5. **EMPLOYEES** → **THEFT_ALERTS** (1:Many)
   - Each employee can be associated with multiple alerts

### Fact vs. Dimension Tables:

**Dimension Tables:**

- INVENTORY_ITEMS (product dimension)
- EMPLOYEES (employee dimension)
- HOLIDAYS (time dimension)

**Fact Tables:**

- STOCK_MOVEMENTS (transaction fact)
- THEFT_ALERTS (event fact)
- AUDIT_LOG (audit fact)

**Bridge Tables:**

- STOCK_LEVELS (current state snapshot)

---

## Data Types and Standards

### Number Types:

- IDs: NUMBER(10) - sufficient for up to 9,999,999,999 records
- Quantities: NUMBER(10) - supports up to 9,999,999,999 units
- Prices: NUMBER(10,2) - supports up to 99,999,999.99 with 2 decimal places

### String Types:

- Names: VARCHAR2(100) - sufficient for most names
- Codes: VARCHAR2(50) - standardized codes
- Descriptions: VARCHAR2(500) - brief descriptions
- Notes: VARCHAR2(1000) - detailed notes
- JSON Data: CLOB - for storing old/new values in audit log

### Date Types:

- All dates: DATE - includes both date and time
- Default: SYSDATE for creation timestamps

---

## Constraints Summary

### Primary Keys:

- All tables have a single-column primary key (ID column)

### Foreign Keys:

- STOCK_LEVELS.item_id → INVENTORY_ITEMS.item_id (ON DELETE CASCADE)
- STOCK_MOVEMENTS.item_id → INVENTORY_ITEMS.item_id (ON DELETE CASCADE)
- STOCK_MOVEMENTS.employee_id → EMPLOYEES.employee_id (ON DELETE SET NULL)
- THEFT_ALERTS.item_id → INVENTORY_ITEMS.item_id (ON DELETE CASCADE)
- THEFT_ALERTS.employee_id → EMPLOYEES.employee_id (ON DELETE SET NULL)

### Check Constraints:

- Prices and quantities: >= 0
- Status flags: IN ('Y', 'N')
- Movement types: IN ('IN', 'OUT', 'ADJUSTMENT', 'STOCK_CHECK', 'RETURN')
- Alert severity: IN ('HIGH', 'MEDIUM', 'LOW')
- Alert status: IN ('ACTIVE', 'RESOLVED', 'FALSE_POSITIVE', 'UNDER_INVESTIGATION')
- Operation types: IN ('INSERT', 'UPDATE', 'DELETE')
- Audit status: IN ('SUCCESS', 'DENIED')

### Unique Constraints:

- INVENTORY_ITEMS.item_code
- EMPLOYEES.employee_code
- HOLIDAYS.holiday_date

---

## Assumptions

1. **Item-Stock Relationship:** Assumes one-to-one relationship (each item has one stock level record)
2. **Movement Types:** Fixed set of movement types; no custom types allowed
3. **Alert Resolution:** Alerts can be resolved with various outcomes
4. **Audit Logging:** All operations are logged, including denied operations
5. **Holiday Management:** Holidays are managed for business rule enforcement
6. **Cascade Deletes:** Deleting an item cascades to stock levels, movements, and alerts
7. **Employee Deletes:** Deleting an employee sets employee_id to NULL in related tables
8. **Date Handling:** All dates include time component (DATE type)
9. **Currency:** Prices stored as NUMBER; currency symbol not stored
10. **Locations:** Location stored as VARCHAR2; no separate location table

---

## Normalization

The database is normalized to **Third Normal Form (3NF)**:

- **1NF:** All attributes are atomic (no repeating groups)
- **2NF:** All non-key attributes fully dependent on primary key
- **3NF:** No transitive dependencies (all attributes depend only on primary key)

### Denormalization Considerations:

- STOCK_LEVELS.location is denormalized for performance (could be in separate LOCATIONS table)
- Some redundant data in audit log (old_values, new_values) for historical accuracy

---

## Future Enhancements

1. **Location Table:** Separate table for locations with hierarchy
2. **Supplier Table:** Separate table for suppliers with contact information
3. **Category Table:** Separate table for categories with hierarchy
4. **User Table:** Separate table for system users (different from employees)
5. **Role-Based Access:** Additional tables for roles and permissions
6. **Slowly Changing Dimensions:** Type 2 SCD for historical tracking
7. **Partitioning:** Partition large tables (STOCK_MOVEMENTS, AUDIT_LOG) by date
