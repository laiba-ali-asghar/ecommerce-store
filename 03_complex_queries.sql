/* ============================================================================
   File: 03_complex_queries.sql
   Purpose: A curated set of analytical queries demonstrating SQL proficiency:
            multi-table joins, correlated/uncorrelated subqueries, Oracle
            analytic (window) functions, hierarchical (CONNECT BY) queries,
            CTEs, and PIVOT. Each query is commented with its business intent
            and the SQL technique it showcases.
   Run AFTER 01_schema_ddl.sql and 02_sample_data.sql.
   ============================================================================ */

----------------------------------------------------------------------------
-- SECTION A: MULTI-TABLE JOINS & AGGREGATION
----------------------------------------------------------------------------

-- Q1. Top 10 best-selling products by total revenue
-- Technique: INNER JOIN + GROUP BY + ORDER BY + FETCH FIRST (Oracle 12c row-limiting clause)
SELECT  p.product_id,
        p.product_name,
        SUM(oi.quantity)               AS units_sold,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM    products p
JOIN    order_items oi ON oi.product_id = p.product_id
JOIN    orders o        ON o.order_id   = oi.order_id
WHERE   o.status <> 'CANCELLED'
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
FETCH FIRST 10 ROWS ONLY;

-- Q2. Monthly revenue trend for the current year
-- Technique: TO_CHAR date truncation + GROUP BY + ORDER BY
SELECT  TO_CHAR(o.order_date, 'YYYY-MM') AS sales_month,
        COUNT(DISTINCT o.order_id)        AS order_count,
        SUM(o.total_amount)               AS monthly_revenue
FROM    orders o
WHERE   o.status <> 'CANCELLED'
GROUP BY TO_CHAR(o.order_date, 'YYYY-MM')
ORDER BY sales_month;

-- Q3. Full order detail report (customer + product + shipping city)
-- Technique: 4-table join, demonstrates resolving a many-to-many relationship
SELECT  o.order_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        p.product_name,
        oi.quantity,
        oi.unit_price,
        oi.line_total,
        ca.city AS ship_to_city
FROM    orders o
JOIN    customers c          ON c.customer_id = o.customer_id
JOIN    order_items oi       ON oi.order_id   = o.order_id
JOIN    products p           ON p.product_id  = oi.product_id
JOIN    customer_addresses ca ON ca.address_id = o.shipping_address_id
ORDER BY o.order_id;

-- Q4. Revenue contribution by category (with parent category rolled up)
-- Technique: self-join on CATEGORIES to resolve parent name, then aggregate
SELECT  NVL(parent.category_name, child.category_name) AS top_level_category,
        SUM(oi.quantity * oi.unit_price)                AS category_revenue
FROM    order_items oi
JOIN    products p     ON p.product_id  = oi.product_id
JOIN    categories child ON child.category_id = p.category_id
LEFT JOIN categories parent ON parent.category_id = child.parent_category_id
GROUP BY NVL(parent.category_name, child.category_name)
ORDER BY category_revenue DESC;

----------------------------------------------------------------------------
-- SECTION B: SUBQUERIES
----------------------------------------------------------------------------

-- Q5. Customers whose total spend is above the average customer spend
-- Technique: correlated aggregate subquery compared against a scalar subquery
SELECT  c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        SUM(o.total_amount)                 AS total_spent
FROM    customers c
JOIN    orders o ON o.customer_id = c.customer_id
WHERE   o.status = 'DELIVERED'
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING  SUM(o.total_amount) > (
            SELECT AVG(order_totals.cust_total)
            FROM (
                SELECT customer_id, SUM(total_amount) AS cust_total
                FROM   orders
                WHERE  status = 'DELIVERED'
                GROUP BY customer_id
            ) order_totals
        )
ORDER BY total_spent DESC;

-- Q6. Products that have never been ordered (dead stock candidates)
-- Technique: NOT EXISTS (generally outperforms NOT IN with NULLs in Oracle)
SELECT  p.product_id, p.product_name, p.stock_quantity
FROM    products p
WHERE   NOT EXISTS (
            SELECT 1 FROM order_items oi WHERE oi.product_id = p.product_id
        );

-- Q7. Customers with more orders than the average number of orders per customer
-- Technique: subquery inside HAVING, comparing grouped counts to a global average
SELECT  customer_id, COUNT(*) AS order_count
FROM    orders
GROUP BY customer_id
HAVING  COUNT(*) > (
            SELECT AVG(cnt) FROM (
                SELECT COUNT(*) AS cnt FROM orders GROUP BY customer_id
            )
        )
ORDER BY order_count DESC;

----------------------------------------------------------------------------
-- SECTION C: ANALYTIC (WINDOW) FUNCTIONS  -- a core Oracle strength
----------------------------------------------------------------------------

-- Q8. Rank products by revenue WITHIN their own category
-- Technique: RANK() OVER (PARTITION BY ... ORDER BY ...)
SELECT  cat.category_name,
        p.product_name,
        SUM(oi.quantity * oi.unit_price) AS product_revenue,
        RANK() OVER (PARTITION BY cat.category_name
                      ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS rank_in_category
FROM    order_items oi
JOIN    products p   ON p.product_id  = oi.product_id
JOIN    categories cat ON cat.category_id = p.category_id
GROUP BY cat.category_name, p.product_name
ORDER BY cat.category_name, rank_in_category;

-- Q9. Running (cumulative) daily revenue total
-- Technique: SUM() OVER (ORDER BY ... ROWS UNBOUNDED PRECEDING)
SELECT  order_date,
        daily_revenue,
        SUM(daily_revenue) OVER (ORDER BY order_date
                                  ROWS UNBOUNDED PRECEDING) AS running_total
FROM (
    SELECT TRUNC(order_date) AS order_date, SUM(total_amount) AS daily_revenue
    FROM   orders
    WHERE  status <> 'CANCELLED'
    GROUP BY TRUNC(order_date)
)
ORDER BY order_date;

-- Q10. Segment customers into quartiles by total spend
-- Technique: NTILE() for equal-sized bucket segmentation (common in marketing analytics)
SELECT  c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        SUM(o.total_amount) AS total_spent,
        NTILE(4) OVER (ORDER BY SUM(o.total_amount) DESC) AS spend_quartile
FROM    customers c
JOIN    orders o ON o.customer_id = c.customer_id
WHERE   o.status <> 'CANCELLED'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- Q11. Month-over-month revenue growth
-- Technique: LAG() to access the previous row's value without a self-join
SELECT  sales_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (ORDER BY sales_month) AS prev_month_revenue,
        ROUND( (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY sales_month))
               / LAG(monthly_revenue) OVER (ORDER BY sales_month) * 100, 1) AS pct_growth
FROM (
    SELECT TO_CHAR(order_date,'YYYY-MM') AS sales_month, SUM(total_amount) AS monthly_revenue
    FROM   orders
    WHERE  status <> 'CANCELLED'
    GROUP BY TO_CHAR(order_date,'YYYY-MM')
)
ORDER BY sales_month;

----------------------------------------------------------------------------
-- SECTION D: HIERARCHICAL QUERIES  -- Oracle-specific CONNECT BY syntax
----------------------------------------------------------------------------

-- Q12. Full category tree with indentation showing depth
-- Technique: CONNECT BY PRIOR (Oracle's native recursive/hierarchical query syntax)
SELECT  LPAD(' ', 2*(LEVEL-1)) || category_name AS category_tree,
        LEVEL AS depth
FROM    categories
START WITH parent_category_id IS NULL
CONNECT BY PRIOR category_id = parent_category_id
ORDER SIBLINGS BY category_name;

-- Q13. Employee management chain (who reports to whom, with chain path)
-- Technique: CONNECT BY + SYS_CONNECT_BY_PATH to materialize the full reporting line
SELECT  employee_id,
        first_name || ' ' || last_name AS employee_name,
        LEVEL AS org_depth,
        SYS_CONNECT_BY_PATH(first_name, ' -> ') AS reporting_chain
FROM    employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id
ORDER SIBLINGS BY last_name;

----------------------------------------------------------------------------
-- SECTION E: CTE (WITH CLAUSE) & PIVOT
----------------------------------------------------------------------------

-- Q14. Repeat customers (2+ delivered orders) and their lifetime value
-- Technique: WITH clause (CTE) to stage an aggregate before filtering
WITH customer_orders AS (
    SELECT  customer_id,
            COUNT(*)            AS order_count,
            SUM(total_amount)   AS lifetime_value
    FROM    orders
    WHERE   status = 'DELIVERED'
    GROUP BY customer_id
)
SELECT  c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        co.order_count,
        co.lifetime_value
FROM    customer_orders co
JOIN    customers c ON c.customer_id = co.customer_id
WHERE   co.order_count >= 2
ORDER BY co.lifetime_value DESC;

-- Q15. Quarterly revenue by top-level category, pivoted into columns
-- Technique: PIVOT operator (Oracle 11g+) - turns rows into columns
SELECT * FROM (
    SELECT  cat.category_name,
            'Q' || TO_CHAR(o.order_date, 'Q') AS quarter,
            oi.quantity * oi.unit_price        AS revenue
    FROM    order_items oi
    JOIN    orders o     ON o.order_id    = oi.order_id
    JOIN    products p   ON p.product_id  = oi.product_id
    JOIN    categories cat ON cat.category_id = p.category_id
    WHERE   o.status <> 'CANCELLED'
)
PIVOT (
    SUM(revenue) FOR quarter IN ('Q1' AS Q1, 'Q2' AS Q2, 'Q3' AS Q3, 'Q4' AS Q4)
)
ORDER BY category_name;
