-- =====================================================
-- Retail Sales Dashboard — Supporting SQL Queries
-- Databricks AI/BI Dashboard (Databricks Academy guided lab)
-- =====================================================

-- Dataset 1: Sales by Loyalty Segment
-- Joins customer loyalty segment data with sales transactions
-- Used to power the Product Category x Loyalty Segment heatmap
SELECT
    product_category,
    loyalty_segment,
    total_price
FROM
    databricks_simulated_retail_customer_data.v01.sales
    JOIN databricks_simulated_retail_customer_data.v01.customers
    ON sales.customer_id = customers.customer_id;


-- Dataset 2: Sales and Orders by Day
-- Combines total daily sales value with total daily order count
-- Used to power the dual-axis "Total Orders vs Total Sales" line chart
WITH sales_data AS (
    SELECT
        date_format(order_date, "dd") AS day,
        SUM(total_price) AS total_sales
    FROM databricks_simulated_retail_customer_data.v01.sales
    GROUP BY day
),
orders_data AS (
    SELECT
        CASE
            WHEN try_cast(sales_orders.order_datetime AS BIGINT) IS NOT NULL
            THEN DAY(FROM_UNIXTIME(sales_orders.order_datetime))
            ELSE NULL
        END AS day,
        COUNT(order_number) AS total_orders
    FROM databricks_simulated_retail_customer_data.v01.sales_orders
    GROUP BY day
)
SELECT
    CAST(s.day AS INT) AS day,
    s.total_sales,
    o.total_orders
FROM sales_data s
JOIN orders_data o ON s.day = o.day
ORDER BY s.day;
