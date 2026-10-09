{{ config(
    materialized='table'
) }}

SELECT

    month,

    product_id,

    variant_id,

    sku,

    orders,

    units_sold,

    gross_sales,

    discounts,

    net_sales,

    SAFE_DIVIDE(
        net_sales,
        units_sold
    ) AS average_selling_price

FROM {{ ref('mart_product_monthly') }}