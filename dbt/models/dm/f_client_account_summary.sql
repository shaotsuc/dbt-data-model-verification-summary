{{
    config(
        schema='dm',
        materialized='table'
    )
}}


SELECT 
	cl.client_id,
	cl.crm_account_id,
	ac.account_manager_id,
	cl.client_name AS client_account_name,
	cl.client_industry,
	ac.account_value,
	am.account_manager_full_name,
	am.account_manager_email
FROM  {{ ref('stg_client') }} AS cl
LEFT JOIN {{ ref('stg_account') }} AS ac 
	   ON cl.crm_account_id = ac.crm_account_id
LEFT JOIN {{ ref('stg_account_manager') }} AS am 
	   ON ac.account_manager_id = am.account_manager_id
