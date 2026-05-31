{{
    config(
        materialized='incremental',
        unique_key='dbt_scd_id',
        incremental_strategy='merge'
    )
}}

with snapshot_data as (
    select
        code,
        name,
        age,
        salary,
        case when dbt_valid_to is null then true else false end as is_current,
        dbt_valid_from as valid_from,
        dbt_valid_to as valid_to,
        dbt_scd_id
    from {{ ref('employee_snapshot') }}
)

select * 
from snapshot_data

{% if is_incremental() %}
  -- Only process records that have been updated or created since the last run
  where valid_from >= (select max(valid_from) from {{ this }})
     or valid_to >= (select max(valid_to) from {{ this }})
{% endif %}
