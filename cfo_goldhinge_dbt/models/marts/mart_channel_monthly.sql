{{ config(
    materialized='table'
) }}

SELECT

    DATE_TRUNC(
        order_date,
        MONTH
    ) AS month,

    source_name,

    COUNT(DISTINCT shopify_order_id)
        AS orders,

    SUM(total_price)
        AS revenue,

    SUM(total_discounts)
        AS discounts,

    SUM(total_tax)
        AS taxes

FROM {{ ref('fct_order') }}

WHERE COALESCE(test, FALSE) = FALSE

GROUP BY

    month,

    source_name