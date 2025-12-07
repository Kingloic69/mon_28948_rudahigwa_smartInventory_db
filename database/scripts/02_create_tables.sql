CREATE SEQUENCE seq_inventory_items
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_stock_levels
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_stock_movements
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_employees
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_theft_alerts
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_audit_log
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_holidays
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE inventory_items (
    item_id NUMBER(10) PRIMARY KEY,
    item_name VARCHAR2(100) NOT NULL,
    item_code VARCHAR2(50) UNIQUE NOT NULL,
    category VARCHAR2(50) NOT NULL,
    description VARCHAR2(500),
    unit_price NUMBER(10, 2) NOT NULL CHECK (unit_price >= 0),
    supplier VARCHAR2(100),
    is_active CHAR(1) DEFAULT 'Y' CHECK (is_active IN ('Y', 'N')),
    created_date DATE DEFAULT SYSDATE,
    last_updated DATE DEFAULT SYSDATE
);

CREATE TABLE stock_levels (
    stock_id NUMBER(10) PRIMARY KEY,
    item_id NUMBER(10) NOT NULL,
    current_quantity NUMBER(10) NOT NULL CHECK (current_quantity >= 0),
    reorder_level NUMBER(10) NOT NULL CHECK (reorder_level >= 0),
    maximum_level NUMBER(10) CHECK (maximum_level >= reorder_level),
    location VARCHAR2(100),
    last_updated DATE DEFAULT SYSDATE,
    CONSTRAINT fk_stock_item FOREIGN KEY (item_id) 
        REFERENCES inventory_items(item_id) ON DELETE CASCADE
);

CREATE TABLE employees (
    employee_id NUMBER(10) PRIMARY KEY,
    employee_name VARCHAR2(100) NOT NULL,
    employee_code VARCHAR2(50) UNIQUE NOT NULL,
    department VARCHAR2(50) NOT NULL,
    position VARCHAR2(50),
    email VARCHAR2(100),
    phone VARCHAR2(20),
    is_active CHAR(1) DEFAULT 'Y' CHECK (is_active IN ('Y', 'N')),
    created_date DATE DEFAULT SYSDATE
);

CREATE TABLE stock_movements (
    movement_id NUMBER(10) PRIMARY KEY,
    item_id NUMBER(10) NOT NULL,
    movement_type VARCHAR2(20) NOT NULL 
        CHECK (movement_type IN ('IN', 'OUT', 'ADJUSTMENT', 'STOCK_CHECK', 'RETURN')),
    quantity NUMBER(10) NOT NULL,
    movement_date DATE DEFAULT SYSDATE NOT NULL,
    employee_id NUMBER(10),
    reference_number VARCHAR2(50),
    notes VARCHAR2(500),
    location VARCHAR2(100),
    CONSTRAINT fk_movement_item FOREIGN KEY (item_id) 
        REFERENCES inventory_items(item_id) ON DELETE CASCADE,
    CONSTRAINT fk_movement_employee FOREIGN KEY (employee_id) 
        REFERENCES employees(employee_id) ON DELETE SET NULL
);

CREATE TABLE theft_alerts (
    alert_id NUMBER(10) PRIMARY KEY,
    item_id NUMBER(10) NOT NULL,
    alert_date DATE DEFAULT SYSDATE NOT NULL,
    alert_severity VARCHAR2(20) NOT NULL 
        CHECK (alert_severity IN ('HIGH', 'MEDIUM', 'LOW')),
    suspected_quantity NUMBER(10) NOT NULL,
    employee_id NUMBER(10),
    status VARCHAR2(20) DEFAULT 'ACTIVE' 
        CHECK (status IN ('ACTIVE', 'RESOLVED', 'FALSE_POSITIVE', 'UNDER_INVESTIGATION')),
    resolution_date DATE,
    outcome VARCHAR2(50),
    resolution_notes VARCHAR2(1000),
    CONSTRAINT fk_alert_item FOREIGN KEY (item_id) 
        REFERENCES inventory_items(item_id) ON DELETE CASCADE,
    CONSTRAINT fk_alert_employee FOREIGN KEY (employee_id) 
        REFERENCES employees(employee_id) ON DELETE SET NULL
);

CREATE TABLE audit_log (
    audit_id NUMBER(10) PRIMARY KEY,
    table_name VARCHAR2(50) NOT NULL,
    operation_type VARCHAR2(20) NOT NULL 
        CHECK (operation_type IN ('INSERT', 'UPDATE', 'DELETE')),
    operation_date DATE DEFAULT SYSDATE NOT NULL,
    user_name VARCHAR2(100) NOT NULL,
    old_values CLOB,
    new_values CLOB,
    ip_address VARCHAR2(50),
    status VARCHAR2(20) NOT NULL 
        CHECK (status IN ('SUCCESS', 'DENIED')),
    error_message VARCHAR2(500)
);

CREATE TABLE holidays (
    holiday_id NUMBER(10) PRIMARY KEY,
    holiday_name VARCHAR2(100) NOT NULL,
    holiday_date DATE NOT NULL,
    is_recurring CHAR(1) DEFAULT 'N' CHECK (is_recurring IN ('Y', 'N')),
    created_date DATE DEFAULT SYSDATE,
    CONSTRAINT uk_holiday_date UNIQUE (holiday_date)
);

CREATE INDEX idx_items_category ON inventory_items(category);
CREATE INDEX idx_items_code ON inventory_items(item_code);
CREATE INDEX idx_items_active ON inventory_items(is_active);

CREATE INDEX idx_stock_item ON stock_levels(item_id);
CREATE INDEX idx_stock_location ON stock_levels(location);

CREATE INDEX idx_movements_item ON stock_movements(item_id);
CREATE INDEX idx_movements_date ON stock_movements(movement_date);
CREATE INDEX idx_movements_type ON stock_movements(movement_type);
CREATE INDEX idx_movements_employee ON stock_movements(employee_id);

CREATE INDEX idx_alerts_item ON theft_alerts(item_id);
CREATE INDEX idx_alerts_date ON theft_alerts(alert_date);
CREATE INDEX idx_alerts_status ON theft_alerts(status);
CREATE INDEX idx_alerts_severity ON theft_alerts(alert_severity);

CREATE INDEX idx_audit_table ON audit_log(table_name);
CREATE INDEX idx_audit_date ON audit_log(operation_date);
CREATE INDEX idx_audit_user ON audit_log(user_name);
CREATE INDEX idx_audit_status ON audit_log(status);

CREATE INDEX idx_holiday_date ON holidays(holiday_date);

COMMENT ON TABLE inventory_items IS 'Master table for all inventory items';
COMMENT ON TABLE stock_levels IS 'Current stock levels for each item';
COMMENT ON TABLE employees IS 'Employee information and access control';
COMMENT ON TABLE stock_movements IS 'All inventory transactions and movements';
COMMENT ON TABLE theft_alerts IS 'Theft detection alerts and resolutions';
COMMENT ON TABLE audit_log IS 'Comprehensive audit trail for all operations';
COMMENT ON TABLE holidays IS 'Public holidays for business rule enforcement';

SELECT table_name, num_rows 
FROM user_tables 
ORDER BY table_name;

SELECT index_name, table_name 
FROM user_indexes 
WHERE table_name LIKE '%INVENTORY%' 
   OR table_name LIKE '%STOCK%' 
   OR table_name LIKE '%THEFT%' 
   OR table_name LIKE '%AUDIT%'
   OR table_name LIKE '%EMPLOYEE%'
   OR table_name LIKE '%HOLIDAY%'
ORDER BY table_name, index_name;
