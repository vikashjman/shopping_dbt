-- Configuration Block
-- Tags: mart
{{ config(
    tags=['mart']
) }}
WITH 
    stg_shippings AS (
        SELECT * FROM {{ ref('stg_shippings') }}
    ),
    stg_orders AS (
        SELECT * FROM {{ ref('stg_orders') }}
    ),
    stg_customers AS (
        SELECT * FROM {{ ref('stg_customers') }}
    ),
    stg_markets AS (
        SELECT * FROM {{ ref('stg_markets') }}
    ),

filtered_stg_orders AS (
    SELECT 
        o.*
    FROM stg_orders o
    JOIN stg_markets m ON o.ord_id = m.ord_id
    JOIN stg_customers c ON c.customer_id = m.customer_id
    WHERE c.region <> 'NUNAVUT '
),

ship_date_analysis AS (
    SELECT 
        ss.*, so.order_priority, DATEDIFF(DAY, so.order_date, ss.ship_date) AS delayed_in_days
    FROM 
        filtered_stg_orders so
    LEFT JOIN  
        stg_shippings ss ON ss.order_id = so.order_id
),
final AS (
    SELECT 
        i.*,
        CASE WHEN i.order_priority = 'HIGH' AND i.delayed_in_days <= 3 THEN 'true' ELSE 'false' END AS support
    FROM 
        ship_date_analysis i
)
SELECT * FROM final;

