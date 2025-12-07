SELECT * FROM inventory_items;

SELECT * FROM stock_movements;

SELECT * FROM theft_alerts;

SELECT * FROM audit_log;

SELECT 
    i.item_id,
    i.item_name,
    i.category,
    i.unit_price,
    s.current_quantity,
    s.reorder_level,
    s.location
FROM inventory_items i
JOIN stock_levels s ON i.item_id = s.item_id;

SELECT 
    sm.movement_id,
    sm.movement_date,
    i.item_name,
    sm.movement_type,
    sm.quantity,
    sm.employee_id,
    e.employee_name
FROM stock_movements sm
JOIN inventory_items i ON sm.item_id = i.item_id
LEFT JOIN employees e ON sm.employee_id = e.employee_id
ORDER BY sm.movement_date DESC;

SELECT 
    ta.alert_id,
    ta.alert_date,
    i.item_name,
    ta.suspected_quantity,
    ta.alert_severity,
    e.employee_name,
    ta.status
FROM theft_alerts ta
JOIN inventory_items i ON ta.item_id = i.item_id
LEFT JOIN employees e ON ta.employee_id = e.employee_id
WHERE ta.status = 'ACTIVE'
ORDER BY ta.alert_date DESC;

SELECT 
    i.category,
    COUNT(*) AS item_count,
    SUM(s.current_quantity * i.unit_price) AS total_value
FROM inventory_items i
JOIN stock_levels s ON i.item_id = s.item_id
GROUP BY i.category
ORDER BY total_value DESC;

SELECT 
    movement_type,
    COUNT(*) AS movement_count,
    SUM(quantity) AS total_quantity,
    MIN(movement_date) AS first_movement,
    MAX(movement_date) AS last_movement
FROM stock_movements
GROUP BY movement_type;

SELECT 
    alert_severity,
    COUNT(*) AS alert_count,
    COUNT(CASE WHEN status = 'ACTIVE' THEN 1 END) AS active_alerts,
    COUNT(CASE WHEN status = 'RESOLVED' THEN 1 END) AS resolved_alerts
FROM theft_alerts
GROUP BY alert_severity;

SELECT 
    i.item_name,
    s.current_quantity,
    s.reorder_level,
    (s.reorder_level - s.current_quantity) AS shortage
FROM inventory_items i
JOIN stock_levels s ON i.item_id = s.item_id
WHERE s.current_quantity < s.reorder_level
ORDER BY shortage DESC;

SELECT 
    i.item_name,
    COUNT(ta.alert_id) AS alert_count
FROM inventory_items i
JOIN theft_alerts ta ON i.item_id = ta.item_id
GROUP BY i.item_name
HAVING COUNT(ta.alert_id) > 0
ORDER BY alert_count DESC;

SELECT 
    e.employee_name,
    COUNT(sm.movement_id) AS movement_count,
    SUM(sm.quantity) AS total_quantity_moved
FROM employees e
JOIN stock_movements sm ON e.employee_id = sm.employee_id
GROUP BY e.employee_name
ORDER BY movement_count DESC;

SELECT 
    i.item_name,
    sm.movement_type,
    sm.quantity,
    sm.movement_date
FROM stock_movements sm
JOIN inventory_items i ON sm.item_id = i.item_id
WHERE sm.movement_date >= SYSDATE - 30
ORDER BY sm.movement_date DESC;

SELECT 
    ta.alert_id,
    i.item_name,
    ta.alert_date,
    ta.alert_severity,
    ta.status
FROM theft_alerts ta
JOIN inventory_items i ON ta.item_id = i.item_id
WHERE ta.alert_date >= SYSDATE - 7
ORDER BY ta.alert_date DESC;
