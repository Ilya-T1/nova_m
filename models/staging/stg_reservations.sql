with source as (
    select * from {{ source('nm_raw', 'raw_reservations') }}
),

cleaned as (
    select
        reservation_id,
        property_id,
        room_type_id,
        channel_category_id,

        booking_date,
        check_in_date,
        check_out_date,
        cancellation_date,

        datediff('day', check_in_date, check_out_date)  as nights_stayed,
        datediff('day', booking_date, check_in_date)    as lead_time_days,

        num_guests,

        initcap(trim(meal_plan))                        as meal_plan,
        case
            when lower(trim(meal_plan)) like '%breakfast%' then true
            else false
        end                                             as has_breakfast,

        initcap(trim(cancellation_policy))              as cancellation_policy,
        cancellation_deadline_days,

        upper(trim(status))                             as status,
        case
            when upper(trim(status)) = 'CANCELLED'      then true
            else false
        end                                             as is_cancelled,

        total_amount,
        case
            when datediff('day', check_in_date, check_out_date) > 0
            then total_amount / datediff('day', check_in_date, check_out_date)
            else null
        end                                             as daily_rate

    from source
)

select * from cleaned
