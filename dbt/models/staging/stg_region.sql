{{
    config(
        schema='staging',
        materialized='table'
    )
}}

SELECT
	region_id,
	region_name,
	employee_id,
	dbt_valid_from,
	dbt_valid_to
FROM {{ ref('region_snapshot') }}
WHERE dbt_valid_to IS NULL