


INSERT INTO employees (employee_id, employee_name, employee_code, department, position, email, phone) VALUES
(seq_employees.NEXTVAL, 'John Smith', 'EMP001', 'Warehouse', 'Manager', 'john.smith@company.com', '555-0101'),
(seq_employees.NEXTVAL, 'Sarah Johnson', 'EMP002', 'Warehouse', 'Supervisor', 'sarah.johnson@company.com', '555-0102'),
(seq_employees.NEXTVAL, 'Michael Brown', 'EMP003', 'Warehouse', 'Stock Clerk', 'michael.brown@company.com', '555-0103'),
(seq_employees.NEXTVAL, 'Emily Davis', 'EMP004', 'Security', 'Security Officer', 'emily.davis@company.com', '555-0104'),
(seq_employees.NEXTVAL, 'David Wilson', 'EMP005', 'Warehouse', 'Stock Clerk', 'david.wilson@company.com', '555-0105'),
(seq_employees.NEXTVAL, 'Lisa Anderson', 'EMP006', 'Inventory', 'Inventory Analyst', 'lisa.anderson@company.com', '555-0106'),
(seq_employees.NEXTVAL, 'Robert Taylor', 'EMP007', 'Warehouse', 'Forklift Operator', 'robert.taylor@company.com', '555-0107'),
(seq_employees.NEXTVAL, 'Jennifer Martinez', 'EMP008', 'Security', 'Security Supervisor', 'jennifer.martinez@company.com', '555-0108'),
(seq_employees.NEXTVAL, 'William Thomas', 'EMP009', 'Warehouse', 'Stock Clerk', 'william.thomas@company.com', '555-0109'),
(seq_employees.NEXTVAL, 'Maria Garcia', 'EMP010', 'Inventory', 'Inventory Coordinator', 'maria.garcia@company.com', '555-0110');

INSERT INTO inventory_items (item_id, item_name, item_code, category, description, unit_price, supplier) VALUES
(seq_inventory_items.NEXTVAL, 'Laptop Dell XPS 15', 'IT-LAP-001', 'Electronics', 'High-performance laptop for business use', 1299.99, 'Dell Inc.'),
(seq_inventory_items.NEXTVAL, 'Wireless Mouse Logitech MX', 'IT-ACC-002', 'Electronics', 'Ergonomic wireless mouse', 79.99, 'Logitech'),
(seq_inventory_items.NEXTVAL, 'Office Chair Ergonomic', 'FUR-CHA-003', 'Furniture', 'Adjustable ergonomic office chair', 299.99, 'Office Depot'),
(seq_inventory_items.NEXTVAL, 'Printer HP LaserJet Pro', 'IT-PRT-004', 'Electronics', 'Black and white laser printer', 249.99, 'HP Inc.'),
(seq_inventory_items.NEXTVAL, 'Desk Lamp LED', 'FUR-LAM-005', 'Furniture', 'Adjustable LED desk lamp', 45.99, 'IKEA'),
(seq_inventory_items.NEXTVAL, 'Monitor Samsung 27 inch', 'IT-MON-006', 'Electronics', '27-inch 4K UHD monitor', 399.99, 'Samsung'),
(seq_inventory_items.NEXTVAL, 'Keyboard Mechanical RGB', 'IT-ACC-007', 'Electronics', 'Mechanical gaming keyboard with RGB', 129.99, 'Corsair'),
(seq_inventory_items.NEXTVAL, 'Filing Cabinet 4-Drawer', 'FUR-CAB-008', 'Furniture', 'Metal filing cabinet with lock', 189.99, 'HON'),
(seq_inventory_items.NEXTVAL, 'USB-C Hub Multiport', 'IT-ACC-009', 'Electronics', '7-in-1 USB-C hub adapter', 59.99, 'Anker'),
(seq_inventory_items.NEXTVAL, 'Standing Desk Adjustable', 'FUR-DES-010', 'Furniture', 'Electric height-adjustable standing desk', 599.99, 'FlexiSpot');

INSERT INTO stock_levels (stock_id, item_id, current_quantity, reorder_level, maximum_level, location) VALUES
(seq_stock_levels.NEXTVAL, 1, 50, 20, 100, 'Warehouse A - Section 1'),
(seq_stock_levels.NEXTVAL, 2, 150, 50, 200, 'Warehouse A - Section 2'),
(seq_stock_levels.NEXTVAL, 3, 30, 10, 50, 'Warehouse B - Section 1'),
(seq_stock_levels.NEXTVAL, 4, 25, 10, 40, 'Warehouse A - Section 3'),
(seq_stock_levels.NEXTVAL, 5, 80, 30, 120, 'Warehouse B - Section 2'),
(seq_stock_levels.NEXTVAL, 6, 40, 15, 60, 'Warehouse A - Section 1'),
(seq_stock_levels.NEXTVAL, 7, 60, 20, 100, 'Warehouse A - Section 2'),
(seq_stock_levels.NEXTVAL, 8, 20, 5, 30, 'Warehouse B - Section 3'),
(seq_stock_levels.NEXTVAL, 9, 100, 40, 150, 'Warehouse A - Section 3'),
(seq_stock_levels.NEXTVAL, 10, 15, 5, 25, 'Warehouse B - Section 1');

INSERT INTO stock_movements (movement_id, item_id, movement_type, quantity, movement_date, employee_id, reference_number, notes, location) VALUES
(seq_stock_movements.NEXTVAL, 1, 'IN', 100, SYSDATE - 30, 1, 'PO-2025-001', 'Initial stock receipt from supplier', 'Warehouse A - Section 1'),
(seq_stock_movements.NEXTVAL, 2, 'IN', 200, SYSDATE - 25, 2, 'PO-2025-002', 'Bulk order received', 'Warehouse A - Section 2'),
(seq_stock_movements.NEXTVAL, 3, 'OUT', 5, SYSDATE - 20, 3, 'SO-2025-001', 'Sales order fulfillment', 'Warehouse B - Section 1'),
(seq_stock_movements.NEXTVAL, 4, 'IN', 30, SYSDATE - 15, 1, 'PO-2025-003', 'New printer stock', 'Warehouse A - Section 3'),
(seq_stock_movements.NEXTVAL, 5, 'ADJUSTMENT', -2, SYSDATE - 10, 6, 'ADJ-2025-001', 'Damaged items removed', 'Warehouse B - Section 2'),
(seq_stock_movements.NEXTVAL, 6, 'OUT', 10, SYSDATE - 7, 5, 'SO-2025-002', 'Bulk sale to corporate client', 'Warehouse A - Section 1'),
(seq_stock_movements.NEXTVAL, 7, 'IN', 50, SYSDATE - 5, 2, 'PO-2025-004', 'Restocking keyboards', 'Warehouse A - Section 2'),
(seq_stock_movements.NEXTVAL, 8, 'STOCK_CHECK', 20, SYSDATE - 3, 6, 'CHK-2025-001', 'Monthly inventory count', 'Warehouse B - Section 3'),
(seq_stock_movements.NEXTVAL, 9, 'RETURN', 5, SYSDATE - 2, 3, 'RET-2025-001', 'Customer return processed', 'Warehouse A - Section 3'),
(seq_stock_movements.NEXTVAL, 10, 'OUT', 2, SYSDATE - 1, 5, 'SO-2025-003', 'Standing desk delivery', 'Warehouse B - Section 1');

INSERT INTO theft_alerts (alert_id, item_id, alert_date, alert_severity, suspected_quantity, employee_id, status, outcome, resolution_notes) VALUES
(seq_theft_alerts.NEXTVAL, 1, SYSDATE - 5, 'HIGH', 15, NULL, 'ACTIVE', NULL, NULL),
(seq_theft_alerts.NEXTVAL, 2, SYSDATE - 8, 'MEDIUM', 10, NULL, 'RESOLVED', 'FALSE_POSITIVE', 'System error - stock count corrected'),
(seq_theft_alerts.NEXTVAL, 3, SYSDATE - 12, 'LOW', 3, 3, 'RESOLVED', 'CONFIRMED_THEFT', 'Employee theft confirmed, disciplinary action taken'),
(seq_theft_alerts.NEXTVAL, 4, SYSDATE - 15, 'HIGH', 8, NULL, 'UNDER_INVESTIGATION', NULL, 'Security team reviewing CCTV footage'),
(seq_theft_alerts.NEXTVAL, 5, SYSDATE - 18, 'MEDIUM', 5, NULL, 'RESOLVED', 'FALSE_POSITIVE', 'Items found in wrong location'),
(seq_theft_alerts.NEXTVAL, 6, SYSDATE - 20, 'HIGH', 12, NULL, 'ACTIVE', NULL, NULL),
(seq_theft_alerts.NEXTVAL, 7, SYSDATE - 22, 'LOW', 4, 5, 'RESOLVED', 'FALSE_POSITIVE', 'Data entry error corrected'),
(seq_theft_alerts.NEXTVAL, 8, SYSDATE - 25, 'MEDIUM', 2, NULL, 'RESOLVED', 'CONFIRMED_THEFT', 'Theft confirmed, police report filed'),
(seq_theft_alerts.NEXTVAL, 9, SYSDATE - 28, 'LOW', 3, NULL, 'UNDER_INVESTIGATION', NULL, 'Reviewing transaction logs'),
(seq_theft_alerts.NEXTVAL, 10, SYSDATE - 30, 'HIGH', 1, NULL, 'ACTIVE', NULL, NULL);

INSERT INTO holidays (holiday_id, holiday_name, holiday_date, is_recurring) VALUES
(seq_holidays.NEXTVAL, 'New Year', TO_DATE('2026-01-01', 'YYYY-MM-DD'), 'Y'),
(seq_holidays.NEXTVAL, 'Independence Day', TO_DATE('2026-07-04', 'YYYY-MM-DD'), 'Y'),
(seq_holidays.NEXTVAL, 'Christmas Day', TO_DATE('2026-12-25', 'YYYY-MM-DD'), 'Y'),
(seq_holidays.NEXTVAL, 'Thanksgiving', TO_DATE('2026-11-27', 'YYYY-MM-DD'), 'Y'),
(seq_holidays.NEXTVAL, 'Labor Day', TO_DATE('2026-09-01', 'YYYY-MM-DD'), 'Y');

SELECT 'Employees' AS table_name, COUNT(*) AS record_count FROM employees
UNION ALL
SELECT 'Inventory Items', COUNT(*) FROM inventory_items
UNION ALL
SELECT 'Stock Levels', COUNT(*) FROM stock_levels
UNION ALL
SELECT 'Stock Movements', COUNT(*) FROM stock_movements
UNION ALL
SELECT 'Theft Alerts', COUNT(*) FROM theft_alerts
UNION ALL
SELECT 'Holidays', COUNT(*) FROM holidays
UNION ALL
SELECT 'Audit Log', COUNT(*) FROM audit_log;

SELECT 
    'Items without stock levels' AS check_type,
    COUNT(*) AS issue_count
FROM inventory_items i
LEFT JOIN stock_levels s ON i.item_id = s.item_id
WHERE s.stock_id IS NULL;

SELECT 
    'Movements with invalid items' AS check_type,
    COUNT(*) AS issue_count
FROM stock_movements sm
LEFT JOIN inventory_items i ON sm.item_id = i.item_id
WHERE i.item_id IS NULL;

COMMIT;
