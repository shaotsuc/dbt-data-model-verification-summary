{{
    config(
        schema='staging',
        materialized='table',
    )
}}

SELECT 
	employee_id,
	role_id,
	employee_full_name,
	employee_email,
	dbt_valid_from,
	dbt_valid_to
FROM {{ ref('employee_snapshot') }}
WHERE dbt_valid_to IS NULL


