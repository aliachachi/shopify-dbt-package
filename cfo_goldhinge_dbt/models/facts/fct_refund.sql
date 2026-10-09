{{ config(
    materialized='table'
) }}

SELECT

    {{ dbt_utils.generate_surrogate_key([
        'refund_id'
    ]) }} AS refund_key,

    refund_id,

    order_id,

    created_at AS refund_created_at,

    processed_at,

    refund_line_items,

    transactions,

    order_adjustments,

    total_duties_set,

    _airbyte_extracted_at

FROM {{ ref('stg_shopify__refunds') }}