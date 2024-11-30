{% snapshot region_snapshot %}

{{ 
    config(
        target_schema = 'snapshots',
        unique_key = 'region_employee_key',
        strategy = 'check',
        check_cols = ["region_employee_key"]
    )
}}

SELECT
    uuid AS region_id,
    region_name,
    region_lead AS employee_id,
    -- As region lead may change
    {{ dbt_utils.surrogate_key(['uuid', 'region_lead']) }} AS region_employee_key
FROM {{ source('prod', 'regions') }}

{% endsnapshot %}