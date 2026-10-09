{{ config(
    materialized='view'
) }}

WITH source AS (

    SELECT *
    FROM {{ source('shopify', 'shopify_orders') }}

),

deduplicated AS (

    SELECT *
    FROM source

    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY id
        ORDER BY _airbyte_extracted_at DESC
    ) = 1

)

SELECT

    CAST(id AS STRING) AS order_id,

    name AS order_name,

    CAST(order_number AS STRING) AS order_number,

    CAST(
        JSON_VALUE(customer, '$.id')
        AS STRING
    ) AS customer_id,

    contact_email,

    created_at,

    updated_at,

    processed_at,

    cancelled_at,

    closed_at,

    financial_status,

    fulfillment_status,

    cancel_reason,

    currency,

    presentment_currency,

    SAFE_CAST(subtotal_price AS NUMERIC) AS subtotal_price,

    SAFE_CAST(total_price AS NUMERIC) AS total_price,

    SAFE_CAST(total_discounts AS NUMERIC) AS total_discounts,

    SAFE_CAST(total_tax AS NUMERIC) AS total_tax,

    SAFE_CAST(current_subtotal_price AS NUMERIC)
        AS current_subtotal_price,

    SAFE_CAST(current_total_price AS NUMERIC)
        AS current_total_price,

    SAFE_CAST(current_total_discounts AS NUMERIC)
        AS current_total_discounts,

    SAFE_CAST(current_total_tax AS NUMERIC)
        AS current_total_tax,

    SAFE_CAST(total_line_items_price AS NUMERIC)
        AS total_line_items_price,

    source_name,

    location_id,

    landing_site,

    referring_site,

    test,

    line_items,

    refunds,

    shipping_lines,

    fulfillments,

    _airbyte_extracted_at,

    _airbyte_raw_id

FROM deduplicated