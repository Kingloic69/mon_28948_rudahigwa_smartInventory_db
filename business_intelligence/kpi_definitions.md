# KPI Definitions

## Smart Inventory Theft-Detection & Real-Time Stock Monitoring System

### Overview

This document provides detailed definitions, formulas, and calculation methods for all Key Performance Indicators (KPIs) used in the Business Intelligence dashboards.

---

## Inventory Management KPIs

### 1. Inventory Accuracy Rate

**Definition:**  
Percentage of inventory items with stock levels that match physical counts within acceptable variance.

**Formula:**
```sql
Inventory Accuracy Rate = (Items with accurate counts / Total items) × 100
```

**Calculation Method:**
```sql
SELECT 
    ROUND(
        (COUNT(CASE WHEN ABS(physical_count - system_count) <= variance_threshold THEN 1 END) * 100.0 / 
         COUNT(*)), 
        2
    ) AS accuracy_rate
FROM stock_audits
WHERE audit_date >= SYSDATE - 30;
```

**Target:** > 95%  
**Update Frequency:** Daily  
**Data Source:** `stock_audits`, `stock_levels`  
**Variance Threshold:** 2% or 5 units (whichever is smaller)

---

### 2. Stock Turnover Ratio

**Definition:**  
Number of times inventory is sold or replaced during a specific period, indicating inventory efficiency.

**Formula:**
```sql
Stock Turnover Ratio = Total movements / Average stock level
```

**Calculation Method:**
```sql
SELECT 
    category,
    ROUND(
        SUM(ABS(quantity)) / 
        NULLIF(AVG(current_quantity), 0), 
        2
    ) AS turnover_ratio
FROM stock_movements sm
JOIN stock_levels sl ON sm.item_id = sl.item_id
JOIN inventory_items i ON sm.item_id = i.item_id
WHERE sm.movement_date >= SYSDATE - 90
GROUP BY category;
```

**Target:** Category-specific benchmarks (typically 4-12 per year)  
**Update Frequency:** Weekly  
**Data Source:** `stock_movements`, `stock_levels`, `inventory_items`

---

### 3. Reorder Level Compliance

**Definition:**  
Percentage of inventory items maintained above their reorder level, indicating adequate stock availability.

**Formula:**
```sql
Reorder Level Compliance = (Items above reorder level / Total items) × 100
```

**Calculation Method:**
```sql
SELECT 
    ROUND(
        (COUNT(CASE WHEN s.current_quantity >= s.reorder_level THEN 1 END) * 100.0 / 
         COUNT(*)), 
        2
    ) AS compliance_rate
FROM stock_levels s
JOIN inventory_items i ON s.item_id = i.item_id
WHERE i.is_active = 'Y';
```

**Target:** > 90%  
**Update Frequency:** Daily  
**Data Source:** `stock_levels`, `inventory_items`

---

### 4. Inventory Value

**Definition:**  
Total monetary value of current inventory across all items.

**Formula:**
```sql
Inventory Value = Σ(Item quantity × Unit price)
```

**Calculation Method:**
```sql
SELECT 
    SUM(s.current_quantity * i.unit_price) AS total_inventory_value,
    SUM(s.current_quantity * i.unit_price) - LAG(SUM(s.current_quantity * i.unit_price)) 
        OVER (ORDER BY TRUNC(SYSDATE)) AS value_change
FROM stock_levels s
JOIN inventory_items i ON s.item_id = i.item_id
WHERE i.is_active = 'Y';
```

**Target:** Budget-aligned  
**Update Frequency:** Real-time  
**Data Source:** `stock_levels`, `inventory_items`

---

## Theft Detection KPIs

### 5. Theft Alert Rate

**Definition:**  
Number of theft alerts generated per 1000 inventory items, indicating system sensitivity and theft frequency.

**Formula:**
```sql
Theft Alert Rate = (Total alerts / Total items) × 1000
```

**Calculation Method:**
```sql
SELECT 
    ROUND(
        (COUNT(ta.alert_id) * 1000.0 / 
         (SELECT COUNT(*) FROM inventory_items WHERE is_active = 'Y')), 
        2
    ) AS alert_rate
FROM theft_alerts ta
WHERE ta.alert_date >= SYSDATE - 30;
```

**Target:** < 5 alerts per 1000 items  
**Update Frequency:** Daily  
**Data Source:** `theft_alerts`, `inventory_items`

---

### 6. Alert Resolution Time

**Definition:**  
Average time taken to resolve theft alerts from detection to resolution.

**Formula:**
```sql
Alert Resolution Time = Average(Resolution date - Alert date)
```

**Calculation Method:**
```sql
SELECT 
    ROUND(
        AVG(
            EXTRACT(DAY FROM (resolution_date - alert_date)) * 24 + 
            EXTRACT(HOUR FROM (resolution_date - alert_date)) + 
            EXTRACT(MINUTE FROM (resolution_date - alert_date)) / 60.0
        ), 
        2
    ) AS avg_resolution_hours
FROM theft_alerts
WHERE status = 'RESOLVED'
  AND resolution_date IS NOT NULL
  AND alert_date >= SYSDATE - 90;
```

**Target:** < 24 hours  
**Update Frequency:** Weekly  
**Data Source:** `theft_alerts`

---

### 7. False Positive Rate

**Definition:**  
Percentage of theft alerts that are determined to be false positives upon investigation.

**Formula:**
```sql
False Positive Rate = (False alerts / Total alerts) × 100
```

**Calculation Method:**
```sql
SELECT 
    ROUND(
        (COUNT(CASE WHEN outcome = 'FALSE_POSITIVE' THEN 1 END) * 100.0 / 
         COUNT(*)), 
        2
    ) AS false_positive_rate
FROM theft_alerts
WHERE status = 'RESOLVED'
  AND alert_date >= SYSDATE - 90;
```

**Target:** < 10%  
**Update Frequency:** Weekly  
**Data Source:** `theft_alerts`

---

### 8. Theft Loss Value

**Definition:**  
Estimated monetary value of confirmed theft incidents.

**Formula:**
```sql
Theft Loss Value = Σ(Stolen quantity × Unit price)
```

**Calculation Method:**
```sql
SELECT 
    SUM(ta.suspected_quantity * i.unit_price) AS total_theft_value
FROM theft_alerts ta
JOIN inventory_items i ON ta.item_id = i.item_id
WHERE ta.outcome = 'CONFIRMED_THEFT'
  AND ta.alert_date >= TRUNC(SYSDATE, 'MM');  -- Current month
```

**Target:** Minimize  
**Update Frequency:** Monthly  
**Data Source:** `theft_alerts`, `inventory_items`

---

## Operational KPIs

### 9. Employee Activity Rate

**Definition:**  
Average number of stock movements performed per employee per day, indicating productivity and workload distribution.

**Formula:**
```sql
Employee Activity Rate = Total movements / (Employee count × Days)
```

**Calculation Method:**
```sql
SELECT 
    e.employee_id,
    e.employee_name,
    e.department,
    COUNT(sm.movement_id) AS total_movements,
    ROUND(
        COUNT(sm.movement_id) / 
        NULLIF(
            EXTRACT(DAY FROM (MAX(sm.movement_date) - MIN(sm.movement_date))), 
            0
        ), 
        2
    ) AS movements_per_day
FROM employees e
JOIN stock_movements sm ON e.employee_id = sm.employee_id
WHERE sm.movement_date >= SYSDATE - 30
GROUP BY e.employee_id, e.employee_name, e.department;
```

**Target:** Department-specific benchmarks  
**Update Frequency:** Weekly  
**Data Source:** `employees`, `stock_movements`

---

### 10. Audit Compliance Rate

**Definition:**  
Percentage of database operations that comply with business rules (not denied by triggers).

**Formula:**
```sql
Audit Compliance Rate = (Compliant operations / Total operations) × 100
```

**Calculation Method:**
```sql
SELECT 
    ROUND(
        (COUNT(CASE WHEN status = 'SUCCESS' THEN 1 END) * 100.0 / 
         COUNT(*)), 
        2
    ) AS compliance_rate
FROM audit_log
WHERE operation_date >= TRUNC(SYSDATE);
```

**Target:** > 98%  
**Update Frequency:** Daily  
**Data Source:** `audit_log`

---

### 11. System Uptime

**Definition:**  
Percentage of time the system is operational and accessible.

**Formula:**
```sql
System Uptime = (Operational time / Total time) × 100
```

**Calculation Method:**
```sql
-- This would typically be calculated from system monitoring logs
-- For database perspective, can use connection availability
SELECT 
    ROUND(
        (SUM(CASE WHEN connection_status = 'ACTIVE' THEN 1 ELSE 0 END) * 100.0 / 
         COUNT(*)), 
        2
    ) AS uptime_percentage
FROM system_monitoring
WHERE check_date >= SYSDATE - 30;
```

**Target:** > 99.5%  
**Update Frequency:** Real-time  
**Data Source:** System monitoring logs

---

## Composite KPIs

### 12. Inventory Health Score

**Definition:**  
Composite score (0-100) combining multiple inventory metrics to provide overall health indicator.

**Formula:**
```sql
Inventory Health Score = (
    (Inventory Accuracy Rate × 0.3) +
    (Reorder Level Compliance × 0.3) +
    (MIN(Stock Turnover Ratio / Target Ratio, 1) × 0.2) +
    (MIN(100, (100 - Theft Alert Rate × 10)) × 0.2)
)
```

**Target:** > 85  
**Update Frequency:** Weekly  
**Data Source:** Multiple tables

---

### 13. Operational Efficiency Index

**Definition:**  
Composite metric combining employee activity, compliance, and system performance.

**Formula:**
```sql
Operational Efficiency = (
    (Employee Activity Rate / Target Rate × 0.4) +
    (Audit Compliance Rate / 100 × 0.4) +
    (System Uptime / 100 × 0.2)
) × 100
```

**Target:** > 90  
**Update Frequency:** Weekly  
**Data Source:** Multiple tables

---

## KPI Calculation Views

### Recommended Database Views

Create materialized views or regular views for frequently accessed KPIs:

```sql
-- Example: Daily KPI Summary View
CREATE OR REPLACE VIEW v_daily_kpi_summary AS
SELECT 
    TRUNC(SYSDATE) AS report_date,
    -- Inventory Value
    (SELECT SUM(s.current_quantity * i.unit_price) 
     FROM stock_levels s 
     JOIN inventory_items i ON s.item_id = i.item_id 
     WHERE i.is_active = 'Y') AS total_inventory_value,
    
    -- Items Below Reorder
    (SELECT COUNT(*) 
     FROM stock_levels s 
     JOIN inventory_items i ON s.item_id = i.item_id 
     WHERE s.current_quantity < s.reorder_level 
       AND i.is_active = 'Y') AS items_below_reorder,
    
    -- Active Alerts
    (SELECT COUNT(*) 
     FROM theft_alerts 
     WHERE status = 'ACTIVE') AS active_alerts,
    
    -- Compliance Rate
    (SELECT ROUND(
        COUNT(CASE WHEN status = 'SUCCESS' THEN 1 END) * 100.0 / 
        NULLIF(COUNT(*), 0), 
        2
     )
     FROM audit_log 
     WHERE TRUNC(operation_date) = TRUNC(SYSDATE)) AS compliance_rate
FROM dual;
```

---

## KPI Thresholds and Alerts

### Alert Conditions

1. **Critical Alerts (Red):**
   - Inventory Accuracy Rate < 90%
   - Items Below Reorder Level > 20
   - Active Theft Alerts > 10
   - Compliance Rate < 95%
   - System Uptime < 99%

2. **Warning Alerts (Yellow):**
   - Inventory Accuracy Rate 90-95%
   - Items Below Reorder Level 10-20
   - Active Theft Alerts 5-10
   - Compliance Rate 95-98%
   - System Uptime 99-99.5%

3. **Normal Status (Green):**
   - All metrics within target ranges

---

## Notes

- All KPI calculations should handle NULL values appropriately
- Use ROUND() function to limit decimal places (typically 2)
- Consider creating stored functions for complex KPI calculations
- Cache frequently accessed KPIs using materialized views
- Document any assumptions or limitations for each KPI
- Update targets based on historical performance and business needs

