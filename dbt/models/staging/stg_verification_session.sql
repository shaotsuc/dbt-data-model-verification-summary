{{
    config(
        schema='staging',
        materialized ='incremental',
        unique_key='verification_session_id'
    )
}}

SELECT
	uuid AS verification_session_id,
	UPPER(status) AS verification_status,
	client_uuid AS client_id,
	verification_specialist_uuid AS employee_id
FROM {{ source('prod', 'verification_sessions') }}