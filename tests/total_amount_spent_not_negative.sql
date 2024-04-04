SELECT 
    *
from {{ref('customer')}}
WHERE total_amount_spent < 0