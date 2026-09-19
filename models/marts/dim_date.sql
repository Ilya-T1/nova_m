-- Conformed calendar dimension. Sourced from int_property_capacity's
-- capacity_date, since that spine already covers the full union of the
-- reservation and maintenance date ranges -- so it's a superset of every
-- date referenced by fct_reservation_nights.stay_date and
-- fct_capacity_daily.capacity_date.
--
-- week_start_date uses Snowflake's DATE_TRUNC('week', ...), which is
-- Monday-based regardless of account-level WEEK_START settings. A numbered
-- ISO week (WEEKOFYEAR) is intentionally omitted -- its result depends on
-- the account's WEEK_START/WEEK_OF_YEAR_POLICY parameters, so it isn't
-- reliably portable; group by week_start_date instead.

with dates as (

    select distinct capacity_date as date_day
    from {{ ref('int_property_capacity') }}

)

select
    date_day,
    date_trunc('week', date_day)       as week_start_date,
    date_trunc('month', date_day)      as month_date,
    year(date_day)                     as year,
    month(date_day)                    as month,
    monthname(date_day)                as month_name,
    quarter(date_day)                  as quarter,
    day(date_day)                      as day_of_month,
    dayname(date_day)                  as day_of_week,
    dayname(date_day) in ('Sat', 'Sun') as is_weekend

from dates
