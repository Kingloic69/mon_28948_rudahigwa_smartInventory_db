# Dashboard Specifications

## Smart Inventory Theft-Detection & Real-Time Stock Monitoring System

### Overview

This document specifies the design and requirements for Business Intelligence dashboards. Each dashboard serves specific stakeholder needs and provides actionable insights for decision-making.

---

## 1. Executive Summary Dashboard

### Purpose
High-level overview for business owners and executives to monitor overall inventory health and business performance.

### Key Metrics (KPI Cards)

1. **Total Inventory Value**
   - Current value in currency
   - Trend indicator (↑/↓ vs. last month)
   - Color coding: Green (within budget), Yellow (approaching limit), Red (over budget)

2. **Active Theft Alerts**
   - Count of unresolved alerts
   - Trend indicator
   - Color coding: Green (0-2), Yellow (3-5), Red (6+)

3. **Inventory Accuracy Rate**
   - Percentage value
   - Trend indicator
   - Color coding: Green (>95%), Yellow (90-95%), Red (<90%)

4. **Stock Turnover Ratio**
   - Average ratio across all categories
   - Trend indicator
   - Benchmark comparison

5. **Audit Compliance Rate**
   - Percentage of compliant operations
   - Trend indicator
   - Color coding: Green (>98%), Yellow (95-98%), Red (<95%)

### Charts and Visualizations

1. **Inventory Value Trend (Line Chart)**
   - X-axis: Time (last 12 months)
   - Y-axis: Total inventory value
   - Multiple lines: By category (optional)

2. **Theft Alerts by Severity (Pie Chart)**
   - Segments: High, Medium, Low severity
   - Percentage and count labels

3. **Top 5 Categories by Value (Bar Chart)**
   - Horizontal bars
   - Value labels on bars
   - Color gradient by value

4. **Monthly Movement Summary (Stacked Bar Chart)**
   - X-axis: Months
   - Y-axis: Movement count
   - Stacked by: Movement type (IN, OUT, ADJUSTMENT)

5. **Compliance Trend (Area Chart)**
   - X-axis: Time (last 30 days)
   - Y-axis: Compliance percentage
   - Target line overlay

### Filters
- Date range (default: Last 30 days)
- Category filter
- Location filter (if applicable)

### Update Frequency
- Real-time for KPI cards
- Daily refresh for charts

---

## 2. Audit Dashboard

### Purpose
Monitor system compliance, track violations, and analyze audit patterns for security and operations teams.

### Key Metrics (KPI Cards)

1. **Total Operations Today**
   - Count of all operations
   - Comparison with yesterday

2. **Denied Operations**
   - Count of denied operations
   - Percentage of total
   - Color coding: Red if > 5%

3. **Compliance Rate**
   - Percentage of successful operations
   - Trend indicator

4. **Unique Active Users**
   - Count of users with operations today
   - Comparison with average

5. **Weekend Operations**
   - Count of operations on weekends (allowed)
   - Percentage of total

### Charts and Visualizations

1. **Operations by Day of Week (Bar Chart)**
   - X-axis: Day of week
   - Y-axis: Operation count
   - Stacked by: Status (SUCCESS, DENIED)
   - Highlight weekdays vs. weekends

2. **Denied Operations Trend (Line Chart)**
   - X-axis: Time (last 30 days)
   - Y-axis: Count of denied operations
   - Separate lines: Weekday denials, Holiday denials

3. **Operations by Hour (Heatmap)**
   - X-axis: Hour of day (0-23)
   - Y-axis: Day of week
   - Color intensity: Operation count
   - Highlight business hours

4. **Denial Reasons (Pie Chart)**
   - Segments: Weekday restriction, Holiday restriction, Other
   - Percentage labels

5. **User Activity Ranking (Bar Chart)**
   - Top 10 users by operation count
   - Horizontal bars
   - Color by compliance rate

6. **Operations by Table (Donut Chart)**
   - Segments: Each table name
   - Percentage and count labels
   - Outer ring: Total operations

### Tables

1. **Recent Denied Operations**
   - Columns: Timestamp, User, Table, Operation Type, Reason
   - Sortable, filterable
   - Max 50 rows

2. **Audit Log Summary**
   - Columns: Date, Total Operations, Successful, Denied, Compliance Rate
   - Sortable by date
   - Last 30 days

### Filters
- Date range
- User filter
- Table filter
- Status filter (SUCCESS, DENIED)
- Operation type filter

### Update Frequency
- Real-time for recent operations
- Hourly refresh for charts

---

## 3. Performance Dashboard

### Purpose
Monitor system performance, resource usage, and operational efficiency for IT and operations teams.

### Key Metrics (KPI Cards)

1. **System Uptime**
   - Percentage value
   - Current status indicator
   - Trend (last 30 days)

2. **Average Query Response Time**
   - Time in milliseconds
   - Trend indicator
   - Target: < 500ms

3. **Total Stock Movements Today**
   - Count value
   - Comparison with average

4. **Database Size**
   - Size in GB
   - Growth trend
   - Available space indicator

5. **Active Connections**
   - Current connection count
   - Maximum capacity indicator

### Charts and Visualizations

1. **Query Performance Trend (Line Chart)**
   - X-axis: Time (last 24 hours)
   - Y-axis: Response time (ms)
   - Multiple lines: By query type
   - Target line overlay

2. **System Resource Usage (Area Chart)**
   - X-axis: Time (last 24 hours)
   - Y-axis: Percentage usage
   - Multiple areas: CPU, Memory, Disk I/O
   - Stacked visualization

3. **Operations Volume by Type (Stacked Area Chart)**
   - X-axis: Time (last 30 days)
   - Y-axis: Operation count
   - Stacked by: Operation type

4. **Database Growth (Line Chart)**
   - X-axis: Time (last 12 months)
   - Y-axis: Database size (GB)
   - Trend line with projection

5. **Peak Usage Hours (Bar Chart)**
   - X-axis: Hour of day
   - Y-axis: Average operation count
   - Highlight peak hours

### Tables

1. **Slow Queries**
   - Columns: Query, Execution Time, Frequency, Last Executed
   - Sortable by execution time
   - Top 20 slowest queries

2. **Table Statistics**
   - Columns: Table Name, Row Count, Size, Last Updated
   - Sortable
   - All tables

### Filters
- Date range
- Resource type filter
- Performance threshold filter

### Update Frequency
- Real-time for current metrics
- 5-minute refresh for charts

---

## 4. Theft Detection Dashboard

### Purpose
Monitor theft alerts, analyze patterns, and track resolution for security and warehouse management teams.

### Key Metrics (KPI Cards)

1. **Active Alerts**
   - Count of unresolved alerts
   - Trend indicator
   - Color coding by severity

2. **Alerts Resolved Today**
   - Count value
   - Comparison with average

3. **Average Resolution Time**
   - Time in hours
   - Trend indicator
   - Target: < 24 hours

4. **Theft Loss Value (This Month)**
   - Monetary value
   - Comparison with last month

5. **False Positive Rate**
   - Percentage value
   - Trend indicator
   - Target: < 10%

### Charts and Visualizations

1. **Alert Trend (Line Chart)**
   - X-axis: Time (last 30 days)
   - Y-axis: Alert count
   - Multiple lines: By severity (High, Medium, Low)
   - Resolution line overlay

2. **Alerts by Category (Bar Chart)**
   - X-axis: Item category
   - Y-axis: Alert count
   - Color by average severity
   - Sortable

3. **Resolution Time Distribution (Histogram)**
   - X-axis: Resolution time buckets (0-6h, 6-12h, 12-24h, 24h+)
   - Y-axis: Alert count
   - Color gradient

4. **Alert Status Breakdown (Pie Chart)**
   - Segments: Active, Resolved, False Positive, Under Investigation
   - Percentage labels

5. **Top Items by Alert Count (Bar Chart)**
   - Top 10 items
   - Horizontal bars
   - Value labels

6. **Alert Heatmap by Day/Hour (Heatmap)**
   - X-axis: Hour of day
   - Y-axis: Day of week
   - Color intensity: Alert count
   - Identify patterns

### Tables

1. **Active Alerts**
   - Columns: Alert ID, Item, Severity, Date, Status, Assigned To
   - Sortable, filterable
   - Action buttons: View Details, Resolve

2. **Recent Resolutions**
   - Columns: Alert ID, Item, Resolution Date, Resolution Time, Outcome
   - Sortable by resolution date
   - Last 50 resolutions

3. **Alert Statistics by Employee**
   - Columns: Employee, Alert Count, Average Resolution Time, False Positive Rate
   - Sortable
   - All employees with alerts

### Filters
- Date range
- Severity filter
- Status filter
- Category filter
- Item filter
- Employee filter

### Update Frequency
- Real-time for active alerts
- Hourly refresh for charts

---

## 5. Inventory Management Dashboard

### Purpose
Monitor stock levels, track movements, and manage inventory operations for warehouse managers and supervisors.

### Key Metrics (KPI Cards)

1. **Items Below Reorder Level**
   - Count value
   - Urgency indicator
   - Color coding: Red if > 10 items

2. **Total Stock Value**
   - Monetary value
   - Trend indicator

3. **Stock Movements Today**
   - Count value
   - Comparison with average

4. **Inventory Accuracy**
   - Percentage value
   - Trend indicator

5. **Fast-Moving Items**
   - Count of items with high turnover
   - Trend indicator

### Charts and Visualizations

1. **Stock Level Status (Gauge Chart)**
   - Overall inventory health
   - Green (healthy), Yellow (attention needed), Red (critical)

2. **Category Distribution (Treemap)**
   - Size: Total value
   - Color: Stock level status
   - Interactive drill-down

3. **Movement Trends (Line Chart)**
   - X-axis: Time (last 30 days)
   - Y-axis: Movement count
   - Multiple lines: By movement type

4. **Reorder Recommendations (Bar Chart)**
   - Top 20 items needing reorder
   - Horizontal bars
   - Quantity needed labels

5. **Stock Level Distribution (Histogram)**
   - X-axis: Stock level percentage (0-20%, 20-40%, etc.)
   - Y-axis: Item count
   - Highlight critical ranges

6. **Turnover by Category (Bar Chart)**
   - X-axis: Category
   - Y-axis: Turnover ratio
   - Color gradient
   - Benchmark line

### Tables

1. **Items Below Reorder Level**
   - Columns: Item Name, Category, Current Stock, Reorder Level, Shortage, Unit Price, Total Value
   - Sortable by shortage
   - Action: Generate Purchase Order

2. **Recent Stock Movements**
   - Columns: Date, Item, Type, Quantity, Employee, Location
   - Sortable by date
   - Last 100 movements
   - Filterable by type

3. **Stock Level Summary by Category**
   - Columns: Category, Item Count, Total Value, Average Stock Level, Items Below Reorder
   - Sortable
   - All categories

### Filters
- Date range
- Category filter
- Location filter
- Stock status filter (Above/Below reorder level)
- Movement type filter

### Update Frequency
- Real-time for stock levels
- 15-minute refresh for movements
- Daily refresh for summaries

---

## Dashboard Design Guidelines

### Color Scheme
- **Primary Colors:** Blue (#1E88E5), Green (#43A047), Red (#E53935), Yellow (#FDD835)
- **Status Colors:**
  - Success/Healthy: Green (#43A047)
  - Warning/Attention: Yellow (#FDD835)
  - Error/Critical: Red (#E53935)
  - Info/Neutral: Blue (#1E88E5)

### Typography
- **Headers:** Arial/Helvetica, 18-24pt, Bold
- **Body Text:** Arial/Helvetica, 12-14pt, Regular
- **Labels:** Arial/Helvetica, 10-12pt, Regular

### Layout
- Responsive grid layout
- KPI cards: 4-5 per row (desktop), 2 per row (tablet), 1 per row (mobile)
- Charts: Full width or 50% width depending on importance
- Consistent spacing and padding

### Interactivity
- Hover tooltips for all data points
- Click-to-drill-down on charts
- Export functionality (PDF, Excel)
- Print-friendly layouts

---

## Implementation Notes

- Dashboards will be designed as mockups using tools like Figma, Canva, or PowerPoint
- SQL queries for each dashboard metric are available in `queries/analytics_queries.sql`
- Future implementation can use tools like Tableau, Power BI, or Oracle Analytics Cloud
- All dashboards should be accessible via web interface with role-based access control

