{{
    config(
        schema='dm',
        materialized='table',
        sort='region_id'
    )
}}

SELECT
	ctry.region_id,
	ctry.country_id,
	reg.employee_id,
	reg.region_name,
	ctry.country_name
FROM  {{ ref('stg_country') }} AS ctry
LEFT JOIN {{ ref('stg_region') }} AS reg 
	   ON ctry.region_id = reg.region_id