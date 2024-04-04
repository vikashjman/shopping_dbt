-- Configuration Block
-- Tags: basic, staging
{{ config(
    tags=['basic', 'staging']
) }}

-- Extracting Required Fields
WITH market_data AS (
    SELECT
        ord_id,
        prod_id,
        ship_id,
        cust_id AS customer_id,
        sales,
        discount,
        order_quantity,
        profit,
        shipping_cost,
        product_base_margin
    FROM {{ source('online_shopping', 'market') }}
),

-- Converting Data Types and Adjusting Naming
converted_market_data AS (
    SELECT
        LOWER(ord_id) AS ord_id,
        LOWER(prod_id) AS product_id,
        LOWER(ship_id) AS ship_id,
        LOWER(customer_id) AS customer_id,
        sales,
        discount,
        order_quantity,
        profit,
        shipping_cost,
        CASE
            WHEN ISNUMERIC(product_base_margin) = 1 THEN CAST(product_base_margin AS FLOAT)
            ELSE NULL -- or any default value or appropriate handling
        END AS base_margin
    FROM market_data
)

-- Final Output: Converted Market Data
SELECT * FROM converted_market_data;
