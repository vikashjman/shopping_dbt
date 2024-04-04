-- Configuration Block
-- Tags: (Add your tags here)
{{ config(
    tags=['mart']
) }}

-- Extracting Staging Data: Orders and Markets
WITH 
    stg_orders AS (
        SELECT * FROM {{ ref('stg_orders') }}
    ),
    
    stg_markets AS (
        SELECT * FROM {{ ref('stg_markets') }}
    ),

    stg_customers AS (
        SELECT * FROM {{ ref("stg_customers") }}
    ),

-- Combining Orders and Markets Data
combined_order_market AS (
    SELECT
        o.*,
        m.profit AS outcome
    FROM 
        stg_orders o
    JOIN 
        stg_markets m ON o.ord_id = m.ord_id
    JOIN
        stg_customers c ON m.customer_id = c.customer_id
    WHERE 
        c.customer_id <> 'NUNAVUT '
)

-- Final Output: Combined Data with Outcome
SELECT * FROM combined_order_market;
