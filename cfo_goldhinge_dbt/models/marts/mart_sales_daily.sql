{{ config(
    materialized='table'
) }}

SELECT

    order_date,

    currency,

    orders,

    subtotal_sales,

    discounts,

    taxes,

    gross_order_value

FROM {{ ref('int_daily_sales') }}