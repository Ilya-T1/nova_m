-- Each reservation's exploded night-rows in fct_reservation_nights should
-- number exactly num_nights -- catches any date_spine boundary bug (e.g. a
-- reservation whose check_in/check_out falls outside the spine's computed
-- range, silently dropping or truncating its nights).
--
-- Fails (returns a row) for any reservation where the exploded row count
-- doesn't match its own num_nights value.

select
    reservation_id,
    num_nights,
    count(*) as exploded_nights

from {{ ref('fct_reservation_nights') }}
group by 1, 2
having count(*) != num_nights
