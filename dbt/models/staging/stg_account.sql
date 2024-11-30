{{
    config(
        schema='staging',
        materialized='table'
    )
}}

SELECT
    id AS crm_account_id,
    account_name,
    account_value,
    account_manager_id
FROM {{ source('crm', 'accounts') }}