with source as (

    select * from {{ source('tableau_superstore', 'orders') }}

),

renamed as (

    select
        "Row ID"            as order_line_id,
        "Order ID"          as order_id,
        "Order Date"        as order_date,
        "Ship Date"         as ship_date,
        "Ship Mode"         as ship_mode,
        "Customer ID"       as customer_id,
        "Customer Name"     as customer_name,
        SEGMENT             as segment,
        "Country/Region"    as country_region,
        CITY                as city,
        "State/Province"    as state_province,
        "Postal Code"       as postal_code,
        REGION              as region,
        "Product ID"        as product_id,
        CATEGORY            as category,
        "Sub-Category"      as sub_category,
        "Product Name"      as product_name,
        SALES               as sales,
        QUANTITY            as quantity,
        DISCOUNT            as discount,
        PROFIT              as profit

    from source

)

select * from renamed
