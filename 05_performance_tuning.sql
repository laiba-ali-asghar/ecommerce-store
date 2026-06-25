/* ============================================================================
   File: 05_performance_tuning.sql
   Purpose: Demonstrates database performance & tuning skills:
            B-tree / composite / function-based / bitmap indexes, range
            partitioning, materialized views, and reading an execution plan.
   Run AFTER 01-04. NOTE: the partitioned-table section recreates ORDERS,
   so run it against a copy/sandbox schema if you want to keep your original
   ORDERS table from script 01 untouched.
   ============================================================================ */

----------------------------------------------------------------------------
-- 1. STANDARD B-TREE INDEXES ON FOREIGN KEYS
--    Oracle does NOT auto-index FK columns (unlike the PK side) - omitting
--    these is one of the most common real-world performance mistakes,
--    causing full table scans / table locks on parent-key DML.
----------------------------------------------------------------------------
CREATE INDEX ix_addr_customer        ON customer_addresses(customer_id);
CREATE INDEX ix_prod_category        ON products(category_id);
CREATE INDEX ix_prod_supplier        ON products(supplier_id);
CREATE INDEX ix_orders_customer      ON orders(customer_id);
CREATE INDEX ix_orders_employee      ON orders(employee_id);
CREATE INDEX ix_orders_address       ON orders(shipping_address_id);
CREATE INDEX ix_oi_order             ON order_items(order_id);
CREATE INDEX ix_oi_product           ON order_items(product_id);
CREATE INDEX ix_pay_order            ON payments(order_id);
CREATE INDEX ix_rev_product          ON reviews(product_id);
CREATE INDEX ix_rev_customer         ON reviews(customer_id);
CREATE INDEX ix_log_product          ON inventory_log(product_id);

----------------------------------------------------------------------------
-- 2. COMPOSITE INDEX
--    Speeds up the extremely common "this customer's order history,
--    most recent first" lookup (Q3 / customer order history queries).
--    Column order matters: lead with the equality predicate (customer_id),
--    then the range/sort column (order_date).
----------------------------------------------------------------------------
CREATE INDEX ix_orders_cust_date ON orders(customer_id, order_date DESC);

----------------------------------------------------------------------------
-- 3. FUNCTION-BASED INDEX
--    Supports case-insensitive customer search (WHERE UPPER(last_name) = ...)
--    without it, Oracle cannot use an index on a column wrapped in a function.
----------------------------------------------------------------------------
CREATE INDEX ix_cust_lastname_upper ON customers (UPPER(last_name));

----------------------------------------------------------------------------
-- 4. BITMAP INDEX
--    Best suited to LOW-CARDINALITY columns (few distinct values) in
--    read-heavy / reporting workloads - e.g. order status has only 5 values.
--    TRADE-OFF: bitmap indexes use row-level locking implicitly and are a
--    poor fit for tables with heavy concurrent single-row OLTP updates;
--    here ORDERS.status changes infrequently per row, so the trade-off is
--    acceptable and the read speed-up for status-filtered reports is large.
----------------------------------------------------------------------------
CREATE BITMAP INDEX ix_orders_status_bmp ON orders(status);

----------------------------------------------------------------------------
-- 5. GATHER OPTIMIZER STATISTICS
--    The cost-based optimizer needs current statistics to choose good plans.
----------------------------------------------------------------------------
BEGIN
    DBMS_STATS.GATHER_SCHEMA_STATS(
        ownname          => USER,
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
        cascade          => TRUE
    );
END;
/

----------------------------------------------------------------------------
-- 6. READING AN EXECUTION PLAN (before/after comparison)
--    Run this BEFORE creating ix_orders_cust_date to see a FULL TABLE SCAN
--    on ORDERS, then again AFTER to see an INDEX RANGE SCAN instead.
----------------------------------------------------------------------------
EXPLAIN PLAN FOR
SELECT order_id, order_date, total_amount
FROM   orders
WHERE  customer_id = 1
ORDER BY order_date DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
/*
  How to read the output:
  - "Cost" estimates relative work; lower is better for the same query.
  - Look for "TABLE ACCESS FULL" on ORDERS -> means no usable index;
    Oracle scans every row in the table.
  - After ix_orders_cust_date exists, re-run EXPLAIN PLAN: the line should
    change to "INDEX RANGE SCAN" on IX_ORDERS_CUST_DATE followed by
    "TABLE ACCESS BY INDEX ROWID" - far fewer logical reads on large tables.
*/

----------------------------------------------------------------------------
-- 7. RANGE PARTITIONING BY ORDER DATE (Oracle-specific, INTERVAL partitioning)
--    For a high-volume orders table, partitioning by month lets Oracle
--    prune partitions for date-range queries/reports and makes archiving
--    old data (DROP PARTITION) nearly instantaneous compared to DELETE.
--    Demonstrated on a copy table so the working ORDERS table is untouched.
----------------------------------------------------------------------------
CREATE TABLE orders_partitioned (
    order_id              NUMBER         NOT NULL,
    customer_id            NUMBER         NOT NULL,
    employee_id            NUMBER,
    shipping_address_id    NUMBER         NOT NULL,
    order_date              DATE           DEFAULT SYSDATE NOT NULL,
    status                   VARCHAR2(15)   DEFAULT 'PENDING' NOT NULL,
    total_amount            NUMBER(10,2)   DEFAULT 0 NOT NULL
)
PARTITION BY RANGE (order_date)
INTERVAL (NUMTOYMINTERVAL(1,'MONTH'))   -- auto-creates a new monthly partition as data arrives
(
    PARTITION p_initial VALUES LESS THAN (DATE '2024-01-01')
);

INSERT INTO orders_partitioned SELECT * FROM orders;
COMMIT;

-- Partition pruning in action: this query only touches the March-2024 partition
SELECT * FROM orders_partitioned
WHERE  order_date BETWEEN DATE '2024-03-01' AND DATE '2024-03-31';

-- See partitions Oracle created automatically
SELECT partition_name, high_value
FROM   user_tab_partitions
WHERE  table_name = 'ORDERS_PARTITIONED'
ORDER BY partition_position;

----------------------------------------------------------------------------
-- 8. MATERIALIZED VIEW
--    Pre-computes an expensive aggregation (monthly sales by category) so
--    dashboards/reports read instantly instead of re-joining/aggregating
--    millions of order_items rows on every page load.
----------------------------------------------------------------------------
CREATE MATERIALIZED VIEW mv_monthly_category_sales
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
SELECT  TO_CHAR(o.order_date, 'YYYY-MM') AS sales_month,
        cat.category_name,
        SUM(oi.quantity * oi.unit_price) AS revenue,
        SUM(oi.quantity)                 AS units_sold
FROM    orders o
JOIN    order_items oi ON oi.order_id   = o.order_id
JOIN    products p     ON p.product_id = oi.product_id
JOIN    categories cat ON cat.category_id = p.category_id
WHERE   o.status <> 'CANCELLED'
GROUP BY TO_CHAR(o.order_date, 'YYYY-MM'), cat.category_name;

-- Dashboard query now hits the pre-aggregated MV instead of 4 joined tables
SELECT * FROM mv_monthly_category_sales ORDER BY sales_month, revenue DESC;

-- Refresh after new orders are loaded (run nightly via DBMS_SCHEDULER in production)
BEGIN
    DBMS_MVIEW.REFRESH('MV_MONTHLY_CATEGORY_SALES', 'C');
END;
/
