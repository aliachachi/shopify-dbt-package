{{ config(
    materialized='table'
) }}

WITH orders AS (

    SELECT *

    FROM {{ ref('int_customer_orders') }}

)

SELECT

    customer_key,

    DATE_TRUNC(
        order_date,
        MONTH
    ) AS month,

    COUNT(DISTINCT shopify_order_id)
        AS orders,

    SUM(total_price)
        AS revenue,

    SUM(total_discounts)
        AS discounts,

    CASE

        WHEN COUNT(DISTINCT shopify_order_id) > 0

        THEN
            SUM(total_price)
            /
            COUNT(DISTINCT shopify_order_id)

        ELSE 0

    END AS aov,

    COUNTIF(
        customer_type = 'New Customer'
    ) AS new_customer_orders,

    COUNTIF(
        customer_type = 'Returning Customer'
    ) AS returning_customer_orders

FROM orders

WHERE customer_key IS NOT NULL

GROUP BY

    customer_key,

    month