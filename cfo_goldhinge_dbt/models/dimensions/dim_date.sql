{{ config(
    materialized='table'
) }}

WITH bounds AS (

    SELECT

        DATE(MIN(created_at)) AS min_date,

        DATE(MAX(created_at)) AS max_date

    FROM {{ ref('stg_shopify__orders') }}

),

calendar AS (

    SELECT day AS date

    FROM bounds,

    UNNEST(
        GENERATE_DATE_ARRAY(
            min_date,
            max_date,
            INTERVAL 1 DAY
        )
    ) AS day

)

SELECT

    CAST(
        FORMAT_DATE('%Y%m%d', date)
        AS INT64
    ) AS date_key,

    date,

    DATE_TRUNC(date, WEEK(MONDAY)) AS week_start,

    DATE_TRUNC(date, MONTH) AS month_start,

    LAST_DAY(date, MONTH) AS month_end,

    DATE_TRUNC(date, QUARTER) AS quarter_start,

    DATE_TRUNC(date, YEAR) AS year_start,

    EXTRACT(YEAR FROM date) AS year,

    EXTRACT(QUARTER FROM date) AS quarter,

    EXTRACT(MONTH FROM date) AS month,

    EXTRACT(DAY FROM date) AS day,

    EXTRACT(DAYOFWEEK FROM date) AS day_of_week,

    FORMAT_DATE('%A', date) AS day_name,

    FORMAT_DATE('%B', date) AS month_name,

    EXTRACT(ISOWEEK FROM date) AS iso_week,

    CASE
        WHEN EXTRACT(DAYOFWEEK FROM date) IN (1, 7)
        THEN TRUE
        ELSE FALSE
    END AS is_weekend

FROM calendar