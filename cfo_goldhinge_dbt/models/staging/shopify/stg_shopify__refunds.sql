{{ config(
    materialized='view'
) }}

WITH source AS (

    SELECT *
    FROM {{ source('shopify', 'shopify_order_refunds') }}

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

    CAST(id AS STRING) AS refund_id,

    CAST(order_id AS STRING) AS order_id,

    created_at,

    processed_at,

    note,

    restock,

    refund_line_items,

    transactions,

    order_adjustments,

    total_duties_set,

    _airbyte_extracted_at,

    _airbyte_raw_id

FROM deduplicated