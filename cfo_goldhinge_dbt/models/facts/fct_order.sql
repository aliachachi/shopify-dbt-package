{{ config(
    materialized='table'
) }}

SELECT

    {{ dbt_utils.generate_surrogate_key([
        'o.order_id'
    ]) }} AS order_key,

    o.order_id AS shopify_order_id,

    o.order_name,

    o.order_number,

    c.customer_key,

    ch.channel_key,

    CAST(
        FORMAT_DATE(
            '%Y%m%d',
            DATE(o.created_at)
        )
        AS INT64
    ) AS date_key,

    DATE(o.created_at) AS order_date,

    o.created_at,

    o.updated_at,

    o.processed_at,

    o.cancelled_at,

    o.closed_at,

    o.financial_status,

    o.fulfillment_status,

    o.cancel_reason,

    o.currency,

    o.presentment_currency,

    o.subtotal_price,

    o.total_price,

    o.total_discounts,

    o.total_tax,

    o.current_subtotal_price,

    o.current_total_price,

    o.current_total_discounts,

    o.current_total_tax,

    o.total_line_items_price,

    o.source_name,

    o.location_id,

    o.landing_site,

    o.referring_site,

    o.test,

    o._airbyte_extracted_at

FROM {{ ref('stg_shopify__orders') }} o

LEFT JOIN {{ ref('dim_customer') }} c

    ON o.customer_id = c.customer_id

LEFT JOIN {{ ref('dim_channel') }} ch

    ON o.source_name = ch.source_channel