{{ config(
    materialized='table'
) }}

WITH first_orders AS (

    SELECT *

    FROM {{ ref('int_customer_first_order') }}

)

SELECT

    customer_key,

    first_order_date,

    DATE_TRUNC(
        first_order_date,
        MONTH
    ) AS cohort_month

FROM first_orders