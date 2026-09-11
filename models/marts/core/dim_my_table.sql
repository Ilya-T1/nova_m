with stg_my_table as (

    select * from {{ ref('stg_my_source__my_table') }}

),

final as (

    select
        my_table_id,
        status_raw,
        case
            when status_raw = 'active' then 'Active'
            when status_raw = 'inactive' then 'Inactive'
            else 'Unknown'
        end                 as status_display,
        created_at,
        updated_at

    from stg_my_table

)

select * from final
