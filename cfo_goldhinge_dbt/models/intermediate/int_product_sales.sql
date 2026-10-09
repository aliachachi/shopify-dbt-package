{{ config(
    materialized='table'
) }}

SELECT

    date_key,

    product_id,

    variant_id,

    sku,

    COUNT(DISTINCT shopify_order_id) AS orders,

    SUM(quantity) AS units_sold,

    SUM(gross_sales) AS gross_sales,

    SUM(discount_amount) AS discounts,

    SUM(net_line_sales) AS net_sales

FROM {{ ref('fct_order_line') }}

GROUP BY

    date_key,

    product_id,

    variant_id,

    sku