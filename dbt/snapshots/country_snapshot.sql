{% snapshot country_snapshot %}

{{ 
    config(
        target_schema = 'snapshots',
        unique_key = 'country_region_key',
        strategy = 'check',
        check_cols = ["country_region_key"]
    )
}}

SELECT
    uuid AS country_id,
	region_uuid AS region_id,
    country_name,
    {{ dbt_utils.surrogate_key(['uuid', 'region_uuid']) }} AS country_region_key
FROM {{ source('prod', 'countries') }}

{% endsnapshot %}