{{ config(
    materialized='table'
) }}

WITH orders AS (

    SELECT *

    FROM {{ ref('fct_order') }}

    WHERE COALESCE(test, FALSE) = FALSE

),

classified AS (

    SELECT

        *,

        ROW_NUMBER() OVER (
            PARTITION BY customer_key
            ORDER BY created_at, shopify_order_id
        ) AS customer_order_number

    FROM orders

    WHERE customer_key IS NOT NULL

)

SELECT

    *,

    CASE

        WHEN customer_order_number = 1
            THEN 'New Customer'

        ELSE 'Returning Customer'

    END AS customer_type

FROM classified