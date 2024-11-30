{{
    config(
        schema='dm',
        materialized='table'
    )
}}

SELECT 
	vs.client_id,
	vs.employee_id,
	d.country_id,
	d.document_id,
	d.verification_session_id,
	d.document_type,
	vs.verification_status
FROM {{ ref('stg_document') }} AS d 
LEFT JOIN {{ ref('stg_verification_session') }} AS vs
ON d.verification_session_id = vs.verification_session_id