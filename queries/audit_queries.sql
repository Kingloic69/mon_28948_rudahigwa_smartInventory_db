SELECT 
    audit_id,
    table_name,
    operation_type,
    operation_date,
    user_name,
    old_values,
    new_values,
    ip_address,
    status
FROM audit_log
ORDER BY operation_date DESC;

SELECT 
    audit_id,
    operation_type,
    operation_date,
    user_name,
    old_values,
    new_values,
    status
FROM audit_log
WHERE table_name = 'STOCK_MOVEMENTS'
ORDER BY operation_date DESC;

SELECT 
    audit_id,
    table_name,
    operation_type,
    operation_date,
    user_name,
    status,
    error_message
FROM audit_log
WHERE status = 'DENIED'
ORDER BY operation_date DESC;

SELECT 
    operation_type,
    COUNT(*) AS operation_count,
    COUNT(CASE WHEN status = 'SUCCESS' THEN 1 END) AS successful_operations,
    COUNT(CASE WHEN status = 'DENIED' THEN 1 END) AS denied_operations
FROM audit_log
GROUP BY operation_type
ORDER BY operation_count DESC;

SELECT 
    user_name,
    COUNT(*) AS total_operations,
    COUNT(CASE WHEN status = 'SUCCESS' THEN 1 END) AS successful,
    COUNT(CASE WHEN status = 'DENIED' THEN 1 END) AS denied,
    MIN(operation_date) AS first_operation,
    MAX(operation_date) AS last_operation
FROM audit_log
GROUP BY user_name
ORDER BY total_operations DESC;

SELECT 
    audit_id,
    table_name,
    operation_type,
    operation_date,
    user_name,
    status
FROM audit_log
WHERE operation_date >= SYSDATE - 1
ORDER BY operation_date DESC;

SELECT 
    TO_CHAR(operation_date, 'DY') AS day_of_week,
    COUNT(*) AS operation_count,
    COUNT(CASE WHEN status = 'DENIED' THEN 1 END) AS denied_count,
    ROUND(COUNT(CASE WHEN status = 'DENIED' THEN 1 END) * 100.0 / COUNT(*), 2) AS denial_percentage
FROM audit_log
GROUP BY TO_CHAR(operation_date, 'DY')
ORDER BY 
    CASE TO_CHAR(operation_date, 'DY')
        WHEN 'MON' THEN 1
        WHEN 'TUE' THEN 2
        WHEN 'WED' THEN 3
        WHEN 'THU' THEN 4
        WHEN 'FRI' THEN 5
        WHEN 'SAT' THEN 6
        WHEN 'SUN' THEN 7
    END;

SELECT 
    TO_CHAR(operation_date, 'HH24') AS hour_of_day,
    COUNT(*) AS operation_count,
    COUNT(CASE WHEN status = 'DENIED' THEN 1 END) AS denied_count
FROM audit_log
GROUP BY TO_CHAR(operation_date, 'HH24')
ORDER BY hour_of_day;

SELECT 
    audit_id,
    table_name,
    operation_type,
    operation_date,
    user_name,
    TO_CHAR(operation_date, 'DY') AS day_of_week,
    error_message
FROM audit_log
WHERE status = 'DENIED'
  AND TO_CHAR(operation_date, 'DY') IN ('MON', 'TUE', 'WED', 'THU', 'FRI')
ORDER BY operation_date DESC;

SELECT 
    audit_id,
    table_name,
    operation_type,
    operation_date,
    user_name,
    error_message
FROM audit_log
WHERE status = 'DENIED'
  AND error_message LIKE '%holiday%'
ORDER BY operation_date DESC;

SELECT 
    audit_id,
    table_name,
    operation_type,
    operation_date,
    user_name,
    TO_CHAR(operation_date, 'DY') AS day_of_week
FROM audit_log
WHERE status = 'SUCCESS'
  AND TO_CHAR(operation_date, 'DY') IN ('SAT', 'SUN')
ORDER BY operation_date DESC;

SELECT 
    TRUNC(operation_date) AS operation_day,
    COUNT(*) AS total_operations,
    COUNT(CASE WHEN status = 'SUCCESS' THEN 1 END) AS successful,
    COUNT(CASE WHEN status = 'DENIED' THEN 1 END) AS denied,
    COUNT(DISTINCT user_name) AS unique_users,
    COUNT(DISTINCT table_name) AS tables_affected
FROM audit_log
GROUP BY TRUNC(operation_date)
ORDER BY operation_day DESC;

SELECT 
    table_name,
    COUNT(*) AS audit_count,
    COUNT(CASE WHEN operation_type = 'INSERT' THEN 1 END) AS inserts,
    COUNT(CASE WHEN operation_type = 'UPDATE' THEN 1 END) AS updates,
    COUNT(CASE WHEN operation_type = 'DELETE' THEN 1 END) AS deletes
FROM audit_log
GROUP BY table_name
ORDER BY audit_count DESC;

SELECT 
    user_name,
    COUNT(*) AS total_attempts,
    COUNT(CASE WHEN status = 'SUCCESS' THEN 1 END) AS successful_attempts,
    COUNT(CASE WHEN status = 'DENIED' THEN 1 END) AS denied_attempts,
    ROUND(COUNT(CASE WHEN status = 'SUCCESS' THEN 1 END) * 100.0 / COUNT(*), 2) AS success_rate
FROM audit_log
GROUP BY user_name
HAVING COUNT(*) > 0
ORDER BY success_rate DESC, total_attempts DESC;

SELECT 
    al.audit_id,
    al.operation_type,
    al.operation_date,
    al.user_name,
    al.old_values,
    al.new_values,
    al.status
FROM audit_log al
WHERE al.table_name = 'STOCK_MOVEMENTS'
  AND (al.old_values LIKE '%"item_id":%' OR al.new_values LIKE '%"item_id":%')
ORDER BY al.operation_date DESC;
