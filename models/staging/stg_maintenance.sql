with source as (
    select * from {{ source('nm_raw', 'raw_maintenance') }}
),

cleaned as (
    select
        maintenance_block_id,
        property_id,
        room_type_id,
        start_date,
        end_date,
        datediff('day', start_date, end_date)   as block_duration_days,
        rooms_out_of_service

    from source
)

select * from cleaned
