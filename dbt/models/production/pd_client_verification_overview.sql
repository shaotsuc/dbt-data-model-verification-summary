{{
    config(
        schema='production',
        materialized='table'
    )
}}

WITH verification_session AS (
	SELECT 
		ctr.region_name,
		ctr.country_name,
		ver.client_id,
		ver.document_type,
		COUNT(DISTINCT ver.verification_session_id) AS verification_session_cnt,
		SUM(CASE WHEN ver.verification_status = 'approved' THEN 1 ELSE 0 END) AS approved_cnt,
		SUM(CASE WHEN ver.verification_status = 'resubmission' THEN 1 ELSE 0 END) AS resubmission_cnt,
		SUM(CASE WHEN ver.verification_status = 'declined' THEN 1 ELSE 0 END) AS declined_cnt
	FROM {{ ref('f_verification_overview') }} AS ver 
	LEFT JOIN {{ ref('d_country_region') }} AS ctr
		   ON ver.country_id = ctr.country_id
	GROUP BY 
		ctr.region_name,
		ctr.country_name,
		ver.client_id,
		ver.document_type
)
, account AS (
SELECT
	client_id,
	client_account_name,
	client_industry,
	account_manager_full_name,
	SUM(account_value) AS account_value
FROM {{ ref('f_client_account_summary') }}
GROUP BY 
	client_id,
	client_account_name,
	client_industry,
	account_manager_full_name
)

SELECT
	vs.region_name,
	vs.country_name,
	acc.client_account_name,
	acc.client_industry,
	acc.account_manager_full_name,
	vs.document_type,
	SUM(verification_session_cnt) AS verification_session_cnt,
	SUM(approved_cnt) AS approved_cnt,
	SUM(resubmission_cnt) AS resubmission_cnt,
	SUM(declined_cnt) AS declined_cnt  
FROM verification_session AS vs
LEFT JOIN account AS acc
	   ON vs.client_id = acc.client_id
GROUP BY 	
	vs.region_name,
	vs.country_name,
	acc.client_account_name,
	acc.client_industry,
	acc.account_manager_full_name,
	vs.document_type
