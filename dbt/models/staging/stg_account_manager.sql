{{
    config(
        schema='staging',
        materialized='table'
    )
}}

SELECT
    id AS account_manager_id,
    first_name AS account_manager_first_name,
    last_name AS account_manager_last_name,
    first_name || ' ' || last_name AS account_manager_full_name,
    email AS account_manager_email
FROM {{ source('crm', 'account_managers') }}