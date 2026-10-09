{{ config(
    materialized='table'
) }}

WITH orders AS (

    SELECT *

    FROM {{ ref('fct_order') }}

),

staged_orders AS (

    SELECT *

    FROM {{ ref('stg_shopify__orders') }}

),

lines AS (

    SELECT

        so.order_id,

        line_item

    FROM staged_orders so,

    UNNEST(
        JSON_QUERY_ARRAY(so.line_items)
    ) AS line_item

)

SELECT

    {{ dbt_utils.generate_surrogate_key([
        'l.order_id',
        "JSON_VALUE(l.line_item, '$.id')"
    ]) }} AS order_line_key,

    o.order_key,

    o.customer_key,

    o.channel_key,

    o.date_key,

    o.shopify_order_id,

    CAST(
        JSON_VALUE(l.line_item, '$.id')
        AS STRING
    ) AS line_item_id,

    CAST(
        JSON_VALUE(l.line_item, '$.product_id')
        AS STRING
    ) AS product_id,

    CAST(
        JSON_VALUE(l.line_item, '$.variant_id')
        AS STRING
    ) AS variant_id,

    JSON_VALUE(
        l.line_item,
        '$.sku'
    ) AS sku,

    JSON_VALUE(
        l.line_item,
        '$.title'
    ) AS line_title,

    SAFE_CAST(
        JSON_VALUE(l.line_item, '$.quantity')
        AS INT64
    ) AS quantity,

    SAFE_CAST(
        JSON_VALUE(l.line_item, '$.price')
        AS NUMERIC
    ) AS unit_price,

    SAFE_CAST(
        JSON_VALUE(l.line_item, '$.total_discount')
        AS NUMERIC
    ) AS discount_amount,

    SAFE_CAST(
        JSON_VALUE(l.line_item, '$.quantity')
        AS NUMERIC
    )
    *
    SAFE_CAST(
        JSON_VALUE(l.line_item, '$.price')
        AS NUMERIC
    ) AS gross_sales,

    SAFE_CAST(
        JSON_VALUE(l.line_item, '$.quantity')
        AS NUMERIC
    )
    *
    SAFE_CAST(
        JSON_VALUE(l.line_item, '$.price')
        AS NUMERIC
    )
    -
    COALESCE(
        SAFE_CAST(
            JSON_VALUE(
                l.line_item,
                '$.total_discount'
            )
            AS NUMERIC
        ),
        0
    ) AS net_line_sales

FROM lines l

INNER JOIN orders o

    ON l.order_id = o.shopify_order_id