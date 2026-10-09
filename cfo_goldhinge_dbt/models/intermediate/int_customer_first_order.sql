{{ config(
    materialized='table'
) }}

SELECT

    customer_key,

    MIN(order_date) AS first_order_date,

    MIN(
        created_at
    ) AS first_order_created_at

FROM {{ ref('fct_order') }}

WHERE customer_key IS NOT NULL

GROUP BY customer_key