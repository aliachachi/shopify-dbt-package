{{ config(
    materialized='view'
) }}

WITH source AS (

    SELECT *
    FROM {{ source('shopify', 'shopify_products') }}

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

    CAST(id AS STRING) AS product_id,

    title AS product_name,

    handle,

    vendor,

    product_type,

    status,

    tags,

    created_at,

    updated_at,

    published_at,

    deleted_at,

    is_gift_card,

    tracks_inventory,

    total_variants,

    total_inventory,

    online_store_url,

    _airbyte_extracted_at,

    _airbyte_raw_id

FROM deduplicated