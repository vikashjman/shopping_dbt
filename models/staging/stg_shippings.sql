-- Configuration Block
-- Tags: basic, staging
{{ config(
    tags=['basic', 'staging']
) }}

-- Extracting Required Shipping Fields
WITH shipping_data AS (
    SELECT
        order_id,
        ship_mode,
        ship_date,
        ship_id
    FROM {{ source('online_shopping', 'shipping') }}
),

-- Converting Data Types and Adjusting Naming
converted_shipping_data AS (
    SELECT
        order_id,
        ship_mode,
        CONVERT(DATE, ship_date, 105) AS ship_date,
        LOWER(ship_id) AS ship_id
    FROM shipping_data
)

-- Final Output: Converted Shipping Data
SELECT * FROM converted_shipping_data;
