-- Configuration Block
-- Tags: basic, staging
{{ config(
    tags=['basic', 'staging']
) }}

-- Extracting Required Fields
WITH required_fields AS (
    SELECT
        product_category AS category,
        product_sub_category AS sub_category,
        prod_id
    FROM {{ source('online_shopping', 'product') }}
)

-- Converting Data Types and Adjusting Naming
, datatype_conversion AS (
    SELECT
        category,
        sub_category,
        LOWER(prod_id) AS product_id
    FROM required_fields
)

-- Final Output: Converted Product Data
SELECT * FROM datatype_conversion;
