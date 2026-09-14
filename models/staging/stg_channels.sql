with source as (
    select * from {{ source('nm_raw', 'raw_channels') }}
),

cleaned as (
    select
        channel_category_id,

        case upper(trim(channel_category))
            when 'OTA'           then 'OTA'
            when 'DIRECT'        then 'Direct'
            when 'TOUR OPERATOR' then 'Tour Operator'
            when 'CORPORATE'     then 'Corporate'
            else initcap(trim(channel_category))
        end                         as channel_category

    from source
)

select * from cleaned
