-- Configuration Block
-- Tags: basic, staging
{{ config(
    tags=['basic', 'staging']
) }}

-- Extracting Required Fields
WITH order_data AS (
    SELECT
        order_id,
        order_date,
        order_priority,
        ord_id
    FROM {{ source('online_shopping', 'order') }}
),

-- Converting Data Types and Adjusting Naming
converted_order_data AS (
    SELECT
        order_id,
        CONVERT(DATE, order_date, 105) AS order_date,
        order_priority,
        LOWER(ord_id) AS ord_id
    FROM order_data
)

-- Final Output: Converted Order Data
SELECT * FROM converted_order_data;
