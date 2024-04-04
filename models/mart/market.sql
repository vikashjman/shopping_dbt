-- Configuration Block
-- Tags: mart
{{ config(
    tags=['mart']
) }}

-- Extracting Staging Data: Products and Markets
WITH 
    stg_products AS (
        SELECT * FROM {{ ref('stg_products') }}
    ),

    stg_markets AS (
        SELECT * FROM {{ ref('stg_markets') }}
    ),

    stg_customer AS (
        SELECT * FROM {{ref('stg_customers')}}
    ),

    filtered_stg_markets AS (
        SELECT sm.*
        FROM stg_markets sm
        JOIN stg_customer sc ON sm.customer_id = sc.customer_id
        WHERE sc.region <> 'NUNAVUT'
    ), -- Corrected the comma here

-- Enriching Market Data with Sub-Category Information
enriched_market_data AS (
    SELECT 
        m.*, 
        p.category AS product_category, 
        p.sub_category AS product_sub_category
    FROM  
        filtered_stg_markets m
    LEFT JOIN 
        stg_products p ON m.product_id = p.product_id
)

-- Final Output: Enriched Market Data with Sub-Category Information
SELECT * FROM enriched_market_data;
