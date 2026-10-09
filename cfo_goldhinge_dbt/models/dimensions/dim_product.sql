{{ config(
    materialized='table'
) }}

SELECT

    {{ dbt_utils.generate_surrogate_key([
        'v.variant_id'
    ]) }} AS product_key,

    v.variant_id,

    v.product_id,

    p.product_name,

    v.variant_title,

    v.display_name,

    v.sku,

    p.vendor,

    p.product_type,

    p.handle,

    p.status AS product_status,

    v.price,

    v.compare_at_price,

    v.inventory_quantity,

    v.inventory_item_id,

    v.available_for_sale,

    v.requires_shipping,

    p.is_gift_card,

    p.tracks_inventory,

    p.created_at AS product_created_at,

    p.updated_at AS product_updated_at,

    v.created_at AS variant_created_at,

    v.updated_at AS variant_updated_at

FROM {{ ref('stg_shopify__product_variants') }} v

LEFT JOIN {{ ref('stg_shopify__products') }} p

    ON v.product_id = p.product_id