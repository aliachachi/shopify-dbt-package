{{ config(
    materialized='view'
) }}

WITH source AS (

    SELECT *
    FROM {{ source('shopify', 'shopify_customers') }}

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

    CAST(id AS STRING) AS customer_id,

    email,

    phone,

    first_name,

    last_name,

    state,

    currency,

    created_at,

    updated_at,

    SAFE_CAST(total_spent AS NUMERIC) AS total_spent,

    orders_count,

    last_order_id,

    verified_email,

    default_address,

    accepts_marketing,

    marketing_opt_in_level,

    email_marketing_consent,

    sms_marketing_consent,

    tax_exempt,

    shop_url,

    _airbyte_extracted_at,

    _airbyte_raw_id

FROM deduplicated