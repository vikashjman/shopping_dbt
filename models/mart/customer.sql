-- Configuration Block
-- Tags: mart
{{ config(
    tags=['mart']
) }}

-- Extracting Staging Data: Customers, Orders, and Markets
WITH 
    stg_customer AS (
        SELECT * FROM {{ ref('stg_customers') }}
        WHERE region != 'NUNAVUT'
    ),

    stg_orders AS (
        SELECT * FROM {{ ref('stg_orders') }}
    ),

    stg_markets AS (
        SELECT * FROM {{ ref('stg_markets') }}
    ),

-- Analyzing Customer Order Data
customer_order_data AS (
    SELECT 
        sc.customer_id, 
        sc.customer_name, 
        sc.region,  -- Include the 'region' field
        MIN(so.order_date) AS first_ordered_date, 
        MAX(so.order_date) AS last_ordered_date,
        SUM(sm.sales) as total_amount_spent, 
        COUNT(*) as total_orders
    FROM 
        stg_customer sc
    LEFT JOIN
        stg_markets sm ON sm.customer_id = sc.customer_id
    JOIN
        stg_orders so ON so.ord_id = sm.ord_id
    GROUP BY
        sc.customer_id, sc.customer_name, sc.region
)

-- Final Output: Customer Order Analysis
SELECT * FROM customer_order_data;
