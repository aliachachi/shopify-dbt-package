{{ config(
    materialized='view'
) }}

WITH source AS (

    SELECT *
    FROM {{ source('shopify', 'shopify_product_variants') }}

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

    CAST(id AS STRING) AS variant_id,

    CAST(product_id AS STRING) AS product_id,

    sku,

    title AS variant_title,

    display_name,

    SAFE_CAST(price AS NUMERIC) AS price,

    SAFE_CAST(compare_at_price AS NUMERIC)
        AS compare_at_price,

    inventory_quantity,

    inventory_item_id,

    inventory_policy,

    available_for_sale,

    requires_shipping,

    grams,

    created_at,

    updated_at,

    _airbyte_extracted_at,

    _airbyte_raw_id

FROM deduplicated