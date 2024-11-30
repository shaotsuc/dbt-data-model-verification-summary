{{
    config(
        schema='staging',
        materialized='table'
    )
}}

SELECT
    uuid AS role_id,
    UPPER(role_name) AS role_name
FROM {{ source('prod', 'roles') }}