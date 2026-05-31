{% snapshot employee_snapshot %}

    {{
        config(
            unique_key='code',
            strategy='timestamp',
            updated_at='last_updated'
        )
    }}

    SELECT * 
    FROM {{ source('raw', 'employee') }}

{% endsnapshot %}