with dim_status as (
    select * from {{ ref('int_dim_status') }}
)
select * from dim_status