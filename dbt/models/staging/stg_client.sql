{{
    config(
        schema='staging',
        materialized='table'
    )
}}

SELECT
    uuid AS client_id,
    client_name,
    UPPER(industry) AS client_industry,
    crm_account_id
FROM {{ source('prod', 'clients') }}