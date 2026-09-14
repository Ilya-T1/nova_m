with source as (
    select * from {{ source('nm_raw', 'raw_properties') }}
),

cleaned as (
    select
        property_id,

        'Nova M '
            || initcap(trim(city))
            || ' '
            || initcap(trim(property_type))     as property_name,

        upper(trim(country))                    as country,
        initcap(trim(city))                     as city,
        cast(zip_code as varchar(10))           as zip_code,
        initcap(trim(property_type))            as property_type,
        star_rating,
        total_rooms,

        case
            when seasonality = true  then 'Apr-Oct'
            when seasonality = false then 'All'
        end                                     as seasonality

    from source
)

select * from cleaned
