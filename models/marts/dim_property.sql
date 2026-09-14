-- Conformed property dimension. Sourced directly from stg_properties (not
-- from int_reservation_nights) so that every property appears here even if
-- it currently has zero reservations -- fct_capacity_monthly and other
-- future facts need to be able to join every property, not just booked ones.

select
    property_id,
    property_name,
    country,
    city,
    zip_code,
    property_type,
    star_rating,
    total_rooms,
    seasonality

from {{ ref('stg_properties') }}
