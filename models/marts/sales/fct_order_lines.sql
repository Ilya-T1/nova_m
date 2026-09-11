with stg_orders as (

    select * from {{ ref('stg_tableau_superstore__orders') }}

),

final as (

    select
        order_line_id,
        order_id,
        order_date,
        ship_date,
        datediff('day', order_date, ship_date)     as days_to_ship,
        ship_mode,

        customer_id,
        customer_name,
        segment,

        country_region,
        city,
        state_province,
        postal_code,
        region,

        product_id,
        product_name,
        category,
        sub_category,

        quantity,
        discount,
        sales,
        profit,
        div0(profit, sales)                        as profit_margin,
        profit > 0                                  as is_profitable

    from stg_orders

)

select * from final
