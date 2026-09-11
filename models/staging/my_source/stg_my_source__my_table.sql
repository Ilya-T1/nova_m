with source as (

    select * from {{ source('my_source', 'my_table') }}

),

renamed as (

    select
        id                  as my_table_id,
        status              as status_raw,
        created_at          as created_at,
        updated_at          as updated_at

    from source

)

select * from renamed
