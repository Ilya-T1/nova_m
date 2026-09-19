-- Daily available-room capacity per property x room_type, enriched beyond
-- int_property_capacity. Grain: property_id + room_type_id + capacity_date.
--
-- Kept at daily grain (not pre-aggregated to month) so weekly capacity
-- analysis is possible -- roll up to week/month in Tableau via dim_date
-- (week_start_date / month_date), not here.

with daily as (

    select * from {{ ref('int_property_capacity') }}

)

select
    d.property_id,
    d.property_name,
    d.country,
    d.room_type_id,
    d.room_type_name,
    d.capacity_date,

    d.room_count,
    d.rooms_blocked,
    d.available_rooms,

    -- Share of inventory blocked by maintenance -- purely a ratio of this
    -- table's own columns, so it belongs here rather than as a BI calc.
    -- NULL (not 0) when room_count is 0, via dbt_utils.safe_divide.
    {{ dbt_utils.safe_divide('d.rooms_blocked', 'd.room_count') }}         as pct_rooms_blocked,

    dayname(d.capacity_date)                                     as day_of_week,
    dayname(d.capacity_date) in ('Sat', 'Sun')                   as is_weekend,
    case
        when dayname(d.capacity_date) in ('Sat', 'Sun') then 'Weekend'
        else 'Weekday'
    end                                                           as day_type,

    {{ is_peak_season('p.seasonality', 'd.capacity_date') }}                as is_peak_season

from daily d
left join {{ ref('dim_property') }} p on p.property_id = d.property_id
