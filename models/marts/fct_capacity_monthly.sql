-- Rolls up int_property_capacity's daily grain to property x room_type x
-- month, for occupancy rate / RevPAR denominators. available_room_nights
-- sums the already-capped daily available_rooms, so the cap logic doesn't
-- need to be redone here.

with daily as (

    select * from {{ ref('int_property_capacity') }}

),

monthly as (

    select
        property_id,
        room_type_id,
        date_trunc('month', capacity_date)     as month_date,
        sum(room_count)                        as total_room_nights,
        sum(rooms_blocked)                     as maintenance_room_nights,
        sum(available_rooms)                   as available_room_nights

    from daily
    group by 1, 2, 3

)

select
    m.property_id,
    p.property_name,
    p.country,
    m.room_type_id,
    rt.room_type_name,
    m.month_date,
    year(m.month_date)     as year,
    month(m.month_date)    as month,
    m.total_room_nights,
    m.maintenance_room_nights,
    m.available_room_nights

from monthly m
left join {{ ref('stg_properties') }} p  on p.property_id  = m.property_id
left join {{ ref('stg_room_types') }} rt on rt.room_type_id = m.room_type_id
