{% macro is_peak_season(seasonality_column, date_column) %}
{#-
    Peak-season flag shared by fct_reservation_nights and fct_capacity_daily.
    Year-round properties (seasonality = 'All') are always peak; seasonal
    (Apr-Oct) properties are peak only when date_column's month falls in
    that window.

    seasonality_column: e.g. 'p.seasonality' (from dim_property)
    date_column: e.g. 'n.stay_date' or 'd.capacity_date'
-#}
case
    when {{ seasonality_column }} = 'All' then true
    when {{ seasonality_column }} = 'Apr-Oct' and month({{ date_column }}) between 4 and 10 then true
    else false
end
{%- endmacro %}
