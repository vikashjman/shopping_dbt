-- Configuration Block
-- Tags: mart
{{ config(
    tags=['mart']
) }}

-- Extracting Staging Data: Products
WITH 
    stg_products AS (
        SELECT * FROM {{ ref('stg_products') }}
    )

-- Final Output: Staging Products
SELECT * FROM stg_products;
