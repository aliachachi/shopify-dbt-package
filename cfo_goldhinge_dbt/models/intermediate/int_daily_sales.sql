{{ config(
    materialized='table'
) }}

SELECT

    order_date,

    currency,

    COUNT(DISTINCT shopify_order_id) AS orders,

    SUM(subtotal_price) AS subtotal_sales,

    SUM(total_discounts) AS discounts,

    SUM(total_tax) AS taxes,

    SUM(total_price) AS gross_order_value

FROM {{ ref('fct_order') }}

WHERE COALESCE(test, FALSE) = FALSE

GROUP BY

    order_date,

    currency