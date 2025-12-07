SELECT 
    item_name,
    category,
    current_quantity * unit_price AS total_value,
    RANK() OVER (ORDER BY current_quantity * unit_price DESC) AS value_rank
FROM inventory_items i
JOIN stock_levels s ON i.item_id = s.item_id;

SELECT 
    item_name,
    category,
    current_quantity * unit_price AS total_value,
    DENSE_RANK() OVER (PARTITION BY category ORDER BY current_quantity * unit_price DESC) AS category_rank
FROM inventory_items i
JOIN stock_levels s ON i.item_id = s.item_id;

SELECT 
    movement_id,
    item_id,
    movement_type,
    quantity,
    movement_date,
    ROW_NUMBER() OVER (PARTITION BY item_id ORDER BY movement_date DESC) AS movement_sequence
FROM stock_movements;

SELECT 
    item_id,
    movement_date,
    quantity,
    LAG(quantity) OVER (PARTITION BY item_id ORDER BY movement_date) AS previous_quantity,
    quantity - LAG(quantity) OVER (PARTITION BY item_id ORDER BY movement_date) AS quantity_change
FROM stock_movements
WHERE movement_type = 'STOCK_CHECK';

SELECT 
    item_id,
    movement_date,
    quantity,
    LEAD(quantity) OVER (PARTITION BY item_id ORDER BY movement_date) AS next_quantity,
    LEAD(quantity) OVER (PARTITION BY item_id ORDER BY movement_date) - quantity AS expected_change
FROM stock_movements
WHERE movement_type = 'STOCK_CHECK';

SELECT 
    item_id,
    movement_date,
    quantity,
    SUM(quantity) OVER (PARTITION BY item_id ORDER BY movement_date) AS running_total
FROM stock_movements
ORDER BY item_id, movement_date;

SELECT 
    movement_id,
    item_id,
    movement_type,
    quantity,
    AVG(quantity) OVER (PARTITION BY movement_type) AS avg_quantity_by_type,
    quantity - AVG(quantity) OVER (PARTITION BY movement_type) AS deviation_from_avg
FROM stock_movements;

SELECT 
    item_id,
    movement_date,
    quantity,
    AVG(quantity) OVER (
        PARTITION BY item_id 
        ORDER BY movement_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS seven_day_avg
FROM stock_movements
WHERE movement_type = 'STOCK_CHECK'
ORDER BY item_id, movement_date;

SELECT 
    i.item_name,
    sm1.movement_date AS check_date,
    sm1.quantity AS current_quantity,
    sm2.quantity AS previous_quantity,
    sm1.quantity - sm2.quantity AS quantity_drop,
    CASE 
        WHEN (sm1.quantity - sm2.quantity) < -100 THEN 'HIGH_RISK'
        WHEN (sm1.quantity - sm2.quantity) < -50 THEN 'MEDIUM_RISK'
        ELSE 'LOW_RISK'
    END AS risk_level
FROM stock_movements sm1
JOIN stock_movements sm2 ON sm1.item_id = sm2.item_id
JOIN inventory_items i ON sm1.item_id = i.item_id
WHERE sm1.movement_type = 'STOCK_CHECK'
  AND sm2.movement_type = 'STOCK_CHECK'
  AND sm2.movement_date = (
      SELECT MAX(movement_date)
      FROM stock_movements
      WHERE item_id = sm1.item_id
        AND movement_type = 'STOCK_CHECK'
        AND movement_date < sm1.movement_date
  )
  AND (sm1.quantity - sm2.quantity) < 0
ORDER BY quantity_drop ASC;

SELECT 
    i.category,
    COUNT(DISTINCT i.item_id) AS item_count,
    SUM(s.current_quantity) AS total_stock,
    SUM(sm.quantity) AS total_movements,
    ROUND(SUM(sm.quantity) / NULLIF(SUM(s.current_quantity), 0), 2) AS turnover_ratio,
    RANK() OVER (ORDER BY SUM(sm.quantity) / NULLIF(SUM(s.current_quantity), 0) DESC) AS turnover_rank
FROM inventory_items i
JOIN stock_levels s ON i.item_id = s.item_id
LEFT JOIN stock_movements sm ON i.item_id = sm.item_id
WHERE sm.movement_date >= SYSDATE - 90
GROUP BY i.category;

SELECT 
    e.employee_name,
    COUNT(sm.movement_id) AS movement_count,
    SUM(sm.quantity) AS total_quantity,
    PERCENT_RANK() OVER (ORDER BY COUNT(sm.movement_id)) AS activity_percentile,
    CASE 
        WHEN PERCENT_RANK() OVER (ORDER BY COUNT(sm.movement_id)) > 0.9 THEN 'HIGH_ACTIVITY'
        WHEN PERCENT_RANK() OVER (ORDER BY COUNT(sm.movement_id)) > 0.5 THEN 'MEDIUM_ACTIVITY'
        ELSE 'LOW_ACTIVITY'
    END AS activity_level
FROM employees e
JOIN stock_movements sm ON e.employee_id = sm.employee_id
WHERE sm.movement_date >= SYSDATE - 30
GROUP BY e.employee_name;

SELECT 
    item_id,
    movement_date,
    quantity,
    LAG(quantity, 1) OVER (PARTITION BY item_id ORDER BY movement_date) AS prev_quantity,
    LAG(quantity, 7) OVER (PARTITION BY item_id ORDER BY movement_date) AS week_ago_quantity,
    quantity - LAG(quantity, 7) OVER (PARTITION BY item_id ORDER BY movement_date) AS week_over_week_change,
    ROUND(
        ((quantity - LAG(quantity, 7) OVER (PARTITION BY item_id ORDER BY movement_date)) / 
         NULLIF(LAG(quantity, 7) OVER (PARTITION BY item_id ORDER BY movement_date), 0)) * 100, 
        2
    ) AS week_over_week_percent_change
FROM stock_movements
WHERE movement_type = 'STOCK_CHECK'
ORDER BY item_id, movement_date;
