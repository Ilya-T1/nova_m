with source as (
    select * from {{ source('nm_raw', 'raw_room_types') }}
),

cleaned as (
    select
        room_type_id,
        property_id,

        -- Consolidates synonymous per-property labels to one canonical name
        -- (e.g. one property's "Premium" is another's "Superior") so the
        -- same real room type reads the same across all properties.
        case
            when upper(trim(room_type_name)) = 'STANDARD' then 'Double Standard'
            when upper(trim(room_type_name)) = 'DOUBLE'   then 'Double Standard'
            when upper(trim(room_type_name)) = 'SUPERIOR' then 'Double Superior'
            when upper(trim(room_type_name)) = 'PREMIUM'  then 'Double Superior'
            else initcap(trim(room_type_name))
        end                                      as room_type_name,

        max_occupancy,
        room_count

    from source
)

select * from cleaned
