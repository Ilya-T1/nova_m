-- available_rooms is algebraically guaranteed >= 0 today by the LEAST() cap
-- in int_property_capacity.sql, but that guarantee lives entirely in how
-- the SQL happens to be written. This makes it an independently-checked
-- invariant that keeps catching regressions even if that logic changes.
--
-- Fails (returns a row) for any capacity row where available_rooms < 0.

select *
from {{ ref('fct_capacity_daily') }}
where available_rooms < 0
