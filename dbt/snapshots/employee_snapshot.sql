{% snapshot employee_snapshot %}

{{ 
    config(
        target_schema = 'snapshots',
        unique_key = 'employee_role_key',
        strategy = 'check',
        check_cols = ["employee_role_key"]
    )
}}

SELECT
    uuid AS employee_id,
    role_uuid AS role_id,
    first_name AS employee_first_name,
    last_name AS employee_last_name,
    first_name || ' ' || last_name AS employee_full_name,
    email AS employee_email,
    -- As the employee role may change
    {{ dbt_utils.surrogate_key(['uuid', 'role_uuid']) }} AS employee_role_key
FROM {{ source('prod', 'employees') }}

{% endsnapshot %}