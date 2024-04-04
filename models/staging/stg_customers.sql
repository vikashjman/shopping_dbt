-- Configuration Block
-- Tags: basic, staging
{{ config(
    tags=['basic', 'staging']
) }}

-- Extracting Required Fields
WITH customer_data AS (
    SELECT
        cust_id AS customer_id,
        customer_name,
        province,
        region,
        customer_segment
    FROM {{ source('online_shopping', 'customer') }}
),

-- Converting Data Types and Adjusting Naming
converted_customer_data AS (
    SELECT
        LOWER(customer_id) AS customer_id,
        customer_name,
        province,
        region,
        customer_segment
    FROM customer_data
)

-- Final Output: Converted Customer Data
SELECT * FROM converted_customer_data;
