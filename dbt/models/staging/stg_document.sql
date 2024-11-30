{{
    config(
        schema='staging',
        materialized='incremental',
        unique_key='verification_session_id'
    )
}}

SELECT
	uuid AS document_id,
	UPPER(type) AS document_type,
	verification_session_uuid AS verification_session_id,
	country_uuid AS country_id
FROM {{ source('prod', 'documents') }}