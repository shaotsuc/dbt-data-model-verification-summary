{{
    config(
        schema='staging',
        materialized='table'
    )
}}


SELECT
	country_id,
	region_id,
	country_name,
	dbt_valid_from,
	dbt_valid_to
FROM {{ ref('country_snapshot') }}
WHERE dbt_valid_to IS NULL