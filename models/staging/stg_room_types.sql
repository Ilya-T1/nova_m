with source as (
    select * from {{ source('nm_raw', 'raw_room_types') }}
),

cleaned as (
    select
        room_type_id,
        property_id,
        initcap(trim(room_type_name))           as room_type_name,
        max_occupancy,
        room_count

    from source
)

select * from cleaned
