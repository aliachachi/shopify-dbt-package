{{ config(
    materialized='table'
) }}

WITH customers AS (

    SELECT *

    FROM {{ ref('stg_shopify__customers') }}

),

deduplicated AS (

    SELECT *

    FROM customers

    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY updated_at DESC
    ) = 1

)

SELECT

    {{ dbt_utils.generate_surrogate_key([
        'customer_id'
    ]) }} AS customer_key,

    customer_id,

    email,

    phone,

    first_name,

    last_name,

    CONCAT(
        COALESCE(first_name, ''),
        ' ',
        COALESCE(last_name, '')
    ) AS customer_name,

    created_at AS customer_created_at,

    updated_at AS customer_updated_at,

    orders_count,

    total_spent,

    state,

    currency,

    verified_email,

    accepts_marketing,

    marketing_opt_in_level,

    tax_exempt

FROM deduplicated