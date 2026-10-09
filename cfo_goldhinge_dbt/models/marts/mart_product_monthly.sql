{{ config(
    materialized='table'
) }}

SELECT

    DATE_TRUNC(
        PARSE_DATE(
            '%Y%m%d',
            CAST(date_key AS STRING)
        ),
        MONTH
    ) AS month,

    product_id,

    variant_id,

    sku,

    SUM(orders) AS orders,

    SUM(units_sold) AS units_sold,

    SUM(gross_sales) AS gross_sales,

    SUM(discounts) AS discounts,

    SUM(net_sales) AS net_sales

FROM {{ ref('int_product_sales') }}

GROUP BY

    month,

    product_id,

    variant_id,

    sku