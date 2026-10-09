{{ config(
    materialized='table'
) }}

SELECT

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

    SUM(total_tax)
        AS taxes,

    SAFE_DIVIDE(
        SUM(total_price),
        COUNT(DISTINCT shopify_order_id)
    ) AS aov

FROM {{ ref('fct_order') }}

WHERE COALESCE(test, FALSE) = FALSE

GROUP BY month