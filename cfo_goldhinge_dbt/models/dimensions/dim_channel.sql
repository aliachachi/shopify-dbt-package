{{ config(
    materialized='table'
) }}

WITH channels AS (

    SELECT DISTINCT

        source_name

    FROM {{ ref('stg_shopify__orders') }}

    WHERE source_name IS NOT NULL

)

SELECT

    {{ dbt_utils.generate_surrogate_key([
        'source_name'
    ]) }} AS channel_key,

    source_name AS source_channel

FROM channels