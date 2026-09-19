{% macro date_spine_bound(agg, relation, column) %}
{#-
    Builds a scalar subquery for dbt_utils.date_spine's start_date/end_date
    arguments, always referencing a real relation via ref() (passed in as
    `relation`) rather than an earlier CTE name.

    Why this exists: dbt_utils.date_spine splices start_date/end_date as raw
    SQL text into its own generated CTE. A bare CTE name (e.g. "reservations")
    inside that text is NOT resolvable in the scope of the calling model's
    WITH clause -- Snowflake will try to look it up as a real object and fail
    with "Object '<NAME>' does not exist or not authorized". Always building
    this bound through this macro keeps that mistake from recurring.

    agg: 'min' or 'max'
    relation: a ref() call, e.g. ref('stg_reservations')
    column: column name to aggregate, e.g. 'check_in_date'

    To combine multiple sources (e.g. the union of two tables' ranges),
    wrap two calls with least()/greatest() at the call site:
        start_date="(select least(" ~ date_spine_bound('min', ref('a'), 'x')
                    ~ ", " ~ date_spine_bound('min', ref('b'), 'y') ~ "))"
-#}
(select {{ agg }}({{ column }}) from {{ relation }})
{%- endmacro %}
