# Business Process Model

## Smart Inventory Theft-Detection & Real-Time Stock Monitoring System

### Overview

This document describes the business process model using BPMN (Business Process Model and Notation) with swimlanes to represent different actors and departments involved in the inventory management and theft detection system.

---

## Process Actors (Swimlanes)

### 1. Warehouse Employee
- **Role:** Performs day-to-day inventory operations
- **Responsibilities:** Stock receipt, stock movement, stock checks, data entry

### 2. Inventory Supervisor
- **Role:** Oversees inventory operations and validates transactions
- **Responsibilities:** Approve adjustments, review discrepancies, manage stock levels

### 3. Security Personnel
- **Role:** Handles security alerts and theft investigations
- **Responsibilities:** Investigate alerts, resolve theft cases, generate security reports

### 4. System (Automated)
- **Role:** Automated processes and business rules
- **Responsibilities:** Theft detection, audit logging, business rule enforcement, alert generation

### 5. Warehouse Manager
- **Role:** Strategic oversight and decision-making
- **Responsibilities:** Review reports, make strategic decisions, approve major adjustments

---

## Main Business Processes

### Process 1: Stock Receipt Process

**Swimlane: Warehouse Employee → System → Inventory Supervisor**

```
[Start] → [Receive Goods from Supplier]
    ↓
[Scan/Enter Item Details] → [System: Validate Item Code]
    ↓
[Enter Quantity Received] → [System: Check Business Rules]
    ↓
{Is Weekday or Holiday?}
    ├─ Yes → [System: DENY Operation] → [Log to Audit] → [End - Error]
    └─ No → [System: ALLOW Operation]
        ↓
[System: Create Stock Movement (IN)] → [System: Update Stock Levels]
    ↓
[System: Log to Audit] → [System: Check Reorder Level]
    ↓
{Stock Below Reorder?}
    ├─ Yes → [System: Generate Reorder Alert] → [Notify Supervisor]
    └─ No → [Continue]
        ↓
[Supervisor: Review Transaction] → [Approve/Reject]
    ↓
[End - Success]
```

---

### Process 2: Stock Movement/Transfer Process

**Swimlane: Warehouse Employee → System → Inventory Supervisor**

```
[Start] → [Employee: Initiate Movement Request]
    ↓
[Enter Item, Quantity, Movement Type] → [System: Validate Item Exists]
    ↓
[System: Check Current Stock] → {Sufficient Stock?}
    ├─ No → [System: DENY - Insufficient Stock] → [Log to Audit] → [End - Error]
    └─ Yes → [System: Check Business Rules]
        ↓
{Is Weekday or Holiday?}
    ├─ Yes → [System: DENY Operation] → [Log to Audit] → [End - Error]
    └─ No → [System: ALLOW Operation]
        ↓
[System: Create Stock Movement] → [System: Update Stock Levels]
    ↓
[System: Log to Audit] → [System: Run Theft Detection Algorithm]
    ↓
{Anomaly Detected?}
    ├─ Yes → [System: Generate Theft Alert] → [Notify Security] → [Process 3]
    └─ No → [Continue]
        ↓
[Supervisor: Review Movement] → [Approve/Reject]
    ↓
[End - Success]
```

---

### Process 3: Theft Detection & Alert Resolution Process

**Swimlane: System → Security Personnel → Inventory Supervisor → Warehouse Manager**

```
[Start: Alert Generated] → [System: Create Theft Alert Record]
    ↓
[System: Assign Alert Severity]
    ├─ HIGH → [Immediate Notification]
    ├─ MEDIUM → [Standard Notification]
    └─ LOW → [Queue for Review]
        ↓
[Security: Receive Alert] → [Review Alert Details]
    ↓
[Security: Investigate]
    ├─ [Check Stock Movement History]
    ├─ [Review Employee Activity]
    ├─ [Check Audit Logs]
    └─ [Physical Stock Verification]
        ↓
[Security: Determine Outcome]
    ├─ [Confirmed Theft] → [Update Alert Status: RESOLVED]
    │   ↓
    │   [Calculate Loss Value] → [Generate Incident Report]
    │   ↓
    │   [Notify Warehouse Manager] → [End]
    │
    ├─ [False Positive] → [Update Alert Status: FALSE_POSITIVE]
    │   ↓
    │   [Document Reason] → [Update System Parameters]
    │   ↓
    │   [End]
    │
    └─ [Under Investigation] → [Update Alert Status: UNDER_INVESTIGATION]
        ↓
        [Schedule Follow-up] → [End]
```

---

### Process 4: Stock Check/Audit Process

**Swimlane: Warehouse Employee → System → Inventory Supervisor**

```
[Start] → [Employee: Initiate Stock Check]
    ↓
[Select Item/Location] → [Enter Physical Count]
    ↓
[System: Retrieve System Count] → [System: Calculate Variance]
    ↓
{Variance Detected?}
    ├─ No → [System: Update Last Check Date] → [Log to Audit] → [End]
    └─ Yes → [System: Check Variance Threshold]
        ↓
        {Variance > Threshold?}
            ├─ Yes → [System: Generate Theft Alert] → [Process 3]
            └─ No → [System: Create Adjustment Movement]
                ↓
                [System: Check Business Rules]
                    ↓
                    {Is Weekday or Holiday?}
                        ├─ Yes → [System: DENY] → [Log to Audit] → [End - Error]
                        └─ No → [System: ALLOW]
                            ↓
                            [Supervisor: Review Adjustment] → [Approve/Reject]
                            ↓
                            [System: Update Stock Levels] → [Log to Audit]
                            ↓
                            [End]
```

---

### Process 5: Daily Reporting Process

**Swimlane: System → Warehouse Manager → Inventory Supervisor**

```
[Start: Scheduled Daily] → [System: Generate Reports]
    ↓
[System: Calculate KPIs]
    ├─ [Inventory Value]
    ├─ [Items Below Reorder]
    ├─ [Active Theft Alerts]
    ├─ [Stock Turnover]
    └─ [Compliance Rate]
        ↓
[System: Generate Dashboard Data] → [System: Create Summary Report]
    ↓
[Warehouse Manager: Review Dashboard] → [Identify Issues]
    ↓
{Action Required?}
    ├─ Yes → [Manager: Assign Tasks]
    │   ├─ [To Supervisor: Review Discrepancies]
    │   ├─ [To Security: Investigate Alerts]
    │   └─ [To Employee: Adjust Stock]
    │       ↓
    │       [End]
    └─ No → [End]
```

---

## Decision Points & Business Rules

### Decision Point 1: Weekday/Holiday Check
- **Rule:** Employees CANNOT INSERT/UPDATE/DELETE on weekdays (Monday-Friday) or public holidays
- **Action:** System automatically checks current date and holiday table
- **Outcome:** DENY operation and log to audit if violation

### Decision Point 2: Stock Availability Check
- **Rule:** Stock movements (OUT, TRANSFER) require sufficient available stock
- **Action:** System validates current_quantity >= movement_quantity
- **Outcome:** DENY if insufficient stock

### Decision Point 3: Theft Detection Threshold
- **Rule:** Variance > 10% or absolute difference > 50 units triggers alert
- **Action:** System compares physical count vs system count
- **Outcome:** Generate alert if threshold exceeded

### Decision Point 4: Reorder Level Check
- **Rule:** When stock falls below reorder_level, generate reorder alert
- **Action:** System checks current_quantity < reorder_level after each movement
- **Outcome:** Create reorder notification

---

## Data Flows

### Input Data Sources:
1. **Supplier Deliveries** → Stock Receipt Process
2. **Physical Counts** → Stock Check Process
3. **Movement Requests** → Stock Movement Process
4. **Holiday Calendar** → Business Rule Enforcement

### Output Data Flows:
1. **Stock Movements** → Stock Levels Table
2. **Theft Alerts** → Security Personnel
3. **Audit Logs** → Audit Log Table
4. **Reports** → Management Dashboards
5. **Reorder Alerts** → Inventory Supervisor

---

## Key Entities & Relationships

### Entities:
- **Inventory Items:** Master data for all products
- **Stock Levels:** Current inventory quantities
- **Stock Movements:** All transactions (IN, OUT, ADJUSTMENT)
- **Employees:** Users performing operations
- **Theft Alerts:** Security incidents and resolutions
- **Audit Log:** Complete operation history
- **Holidays:** Public holidays for rule enforcement

### Relationships:
- Employee → Stock Movements (1:Many)
- Item → Stock Movements (1:Many)
- Item → Stock Levels (1:1)
- Item → Theft Alerts (1:Many)
- Stock Movement → Audit Log (1:1)

---

## Process Metrics & KPIs

### Process Performance Indicators:
1. **Stock Receipt Time:** Average time from receipt to system update
2. **Alert Resolution Time:** Time from alert generation to resolution
3. **Stock Check Accuracy:** Percentage of checks with zero variance
4. **Process Compliance Rate:** Percentage of operations following business rules
5. **False Positive Rate:** Percentage of alerts that are false positives

---

## Integration Points

### System Integrations:
1. **Barcode Scanner Integration:** For item code input
2. **Email Notification System:** For alert notifications
3. **Reporting Engine:** For dashboard generation
4. **Audit System:** For compliance logging

---

## Exception Handling

### Exception Scenarios:
1. **System Downtime:** Operations queued, processed when system recovers
2. **Invalid Item Code:** Validation error, operation denied
3. **Concurrent Updates:** Database locking prevents conflicts
4. **Network Issues:** Local logging, sync when connection restored

---

## Process Improvements & Analytics Opportunities

### Analytics Opportunities:
1. **Movement Pattern Analysis:** Identify peak times and optimize staffing
2. **Theft Prediction:** Machine learning on historical patterns
3. **Inventory Optimization:** Predictive reorder point calculation
4. **Employee Performance:** Activity analysis and training needs
5. **Supplier Performance:** Delivery accuracy and timing analysis

---

## BPMN Diagram Structure

### Recommended Diagram Layout:

```
┌─────────────────────────────────────────────────────────────────┐
│                    START EVENT                                  │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  SWIMLANE 1: Warehouse Employee                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐        │
│  │ Task: Receive│→ │ Task: Enter  │→ │ Task: Submit │        │
│  │    Goods     │  │    Details   │  │    Request   │        │
│  └──────────────┘  └──────────────┘  └──────────────┘        │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  SWIMLANE 2: System (Automated)                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐        │
│  │ Validate     │→ │ Check Rules  │→ │{Decision:    │        │
│  │   Input      │  │              │  │ Weekday?}    │        │
│  └──────────────┘  └──────────────┘  └──────────────┘        │
│                              ↓                                 │
│                    ┌──────────────┐                           │
│                    │ Update Stock │                           │
│                    │   & Log      │                           │
│                    └──────────────┘                           │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  SWIMLANE 3: Inventory Supervisor                              │
│  ┌──────────────┐  ┌──────────────┐                           │
│  │ Review       │→ │ Approve/     │                           │
│  │ Transaction  │  │ Reject       │                           │
│  └──────────────┘  └──────────────┘                           │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                    END EVENT                                    │
└─────────────────────────────────────────────────────────────────┘
```

---

## Notes for Diagram Creation

When creating the actual BPMN diagram in Lucidchart, draw.io, or Canva:

1. **Use Proper BPMN Symbols:**
   - ⭕ Start/End Events (circles)
   - ▭ Tasks (rectangles with rounded corners)
   - ◇ Gateways/Decisions (diamonds)
   - → Sequence Flows (arrows)
   - ═ Message Flows (dashed arrows between swimlanes)

2. **Swimlane Organization:**
   - Horizontal swimlanes for different actors
   - Clear separation between manual and automated tasks
   - Color coding: Blue (System), Green (Employee), Yellow (Supervisor), Red (Security)

3. **Decision Points:**
   - Use exclusive gateways (XOR) for yes/no decisions
   - Label all branches clearly
   - Show error paths in red

4. **Data Objects:**
   - Show data stores (database icons) for persistent data
   - Show data objects (document icons) for temporary data

5. **Annotations:**
   - Add notes explaining complex logic
   - Include business rule references
   - Document exception handling

---

**Document Version:** 1.0  
**Last Updated:** December 7, 2025  
**Author:** Rudahigwa (Student ID: 28948)

