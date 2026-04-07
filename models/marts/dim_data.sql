with dim_data as (
    select * from {{ ref('int_dim_data') }}
)
select * from dim_data