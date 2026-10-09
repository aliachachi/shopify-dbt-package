{{ config(
    materialized='table'
) }}

WITH monthly AS (

    SELECT

        month,

        COUNT(DISTINCT customer_key)
            AS active_customers,

        SUM(new_customer_orders)
            AS new_customer_orders,

        SUM(returning_customer_orders)
            AS returning_customer_orders,

        SUM(revenue)
            AS revenue,

        SUM(orders)
            AS orders

    FROM {{ ref('mart_customer_monthly') }}

    GROUP BY month

)

SELECT

    month,

    active_customers,

    new_customer_orders,

    returning_customer_orders,

    revenue,

    orders,

    SAFE_DIVIDE(
        revenue,
        orders
    ) AS aov

FROM monthly