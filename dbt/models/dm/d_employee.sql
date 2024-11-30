{{
    config(
        schema='dm',
        materialized='table'
    )
}}

SELECT
	emp.employee_id,
	emp.role_id,
	emp.employee_full_name,
	emp.employee_email,
	ro.role_name
FROM {{ ref('stg_employee') }} AS emp
LEFT JOIN {{ ref('stg_role') }} AS ro 
	   ON emp.role_id = ro.role_id