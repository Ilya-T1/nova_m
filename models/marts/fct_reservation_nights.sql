-- Presentation-layer pass-through of int_reservation_nights, materialized
-- as a table for query performance in Tableau. Grain: one row per
-- reservation_id + stay_date (non-cancelled reservations only).

select * from {{ ref('int_reservation_nights') }}
