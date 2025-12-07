# Smart Inventory Theft-Detection & Real-Time Stock Monitoring System

## Project Overview

**Project Title:** Smart Inventory Theft-Detection & Real-Time Stock Monitoring System  
**Course:** Database Development with PL/SQL (INSY 8311)  
**Academic Year:** 2025-2026 | Semester: I  
**Lecturer:** Eric Maniraguha | eric.maniraguha@auca.ac.rw  
**Institution:** Adventist University of Central Africa (AUCA)  
**Project Completion Date:** December 7, 2025

## Problem Statement

The Smart Inventory Theft-Detection & Real-Time Stock Monitoring System addresses the critical need for automated inventory management with real-time theft detection capabilities. Traditional inventory systems lack real-time monitoring and automated anomaly detection, leading to significant losses from theft, misplacement, and inventory discrepancies. This system provides continuous stock monitoring, automated theft detection algorithms, and comprehensive audit trails to ensure inventory integrity and minimize losses.

**Target Users:** Warehouse managers, inventory supervisors, security personnel, and business owners  
**Context:** Retail stores, warehouses, distribution centers, and inventory-intensive businesses

## Key Objectives

1. **Real-Time Monitoring:** Track inventory movements in real-time with automated alerts
2. **Theft Detection:** Implement intelligent algorithms to detect suspicious inventory patterns
3. **Audit Trail:** Maintain comprehensive logs of all inventory transactions
4. **Business Intelligence:** Provide analytical dashboards for inventory insights and decision-making
5. **Security:** Enforce business rules preventing unauthorized modifications during business hours

## Project Structure

```
Smart Inventory Theft-Detection System/
    |—- README.md (this file)
    |—- database/
        |—- scripts/ (all SQL: CREATE, INSERT, procedures, triggers)
        |—- documentation/ (ER diagrams, data dictionary, design docs)
    |—- queries/
        |—- data_retrieval.sql
        |—- analytics_queries.sql
        |—- audit_queries.sql
    |—- business_intelligence/
        |—- bi_requirements.md
        |—- dashboards.md
        |—- kpi_definitions.md
    |—- screenshots/
        |—- oem_monitoring/
        |—- database_objects/
```

## Quick Start Instructions

1. **Database Setup:**
   - Create Oracle PDB following naming convention: `mon_28948_rudahigwa_smartInventory_db`
   - Run database creation scripts from `database/scripts/`
   - Configure tablespaces and users

2. **Table Implementation:**
   - Execute CREATE TABLE scripts
   - Load test data using INSERT scripts
   - Validate data integrity

3. **PL/SQL Development:**
   - Deploy procedures and functions
   - Implement packages
   - Test all components

4. **Advanced Features:**
   - Deploy triggers for business rules
   - Set up audit logging
   - Test restriction rules (weekdays/holidays)

## Technology Stack

- **Database:** Oracle Database (Pluggable Database - PDB)
- **Language:** PL/SQL
- **Tools:** SQL Developer, Oracle Enterprise Manager
- **Version Control:** GitHub

## Key Features

- Real-time stock level monitoring
- Automated theft detection algorithms
- Comprehensive audit logging
- Business rule enforcement (weekday/holiday restrictions)
- Business Intelligence dashboards
- Advanced analytics with window functions

## Links to Documentation

- [Data Dictionary](database/documentation/data_dictionary.md)
- [Business Process Model](database/documentation/business_process.md)
- [Business Process Explanation](database/documentation/business_process_explanation.md)
- [ER Diagram](database/documentation/er_diagram.md)
- [BI Requirements](business_intelligence/bi_requirements.md)

## Project Phases

- ✅ Phase I: Problem Statement & Presentation
- ✅ Phase II: Business Process Modeling
- ✅ Phase III: Logical Model Design
- ✅ Phase IV: Database Creation
- ✅ Phase V: Table Implementation & Data Insertion
- ✅ Phase VI: Database Interaction & Transactions
- ✅ Phase VII: Advanced Programming & Auditing
- ✅ Phase VIII: Documentation, BI & Presentation

## Notes

- All code must be original and tested
- Screenshots must include project name
- Follow strict naming conventions
- Maintain comprehensive documentation
- Submit before deadline: December 7, 2025

---

**Student Information:**  
- **Student Name:** Rudahigwa Mparabanyi Loic
- **Student ID:** 28948
- **Group Name:** mon
- **Database Name:** mon_28948_rudahigwa_smartInventory_db

**GitHub Repository:**  
*https://github.com/Kingloic69/mon_28948_rudahigwa_smartInventory_db*

