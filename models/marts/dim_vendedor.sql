with dim_vendedor as (
    select * from {{ ref('int_dim_vendedor') }}
)
select * from dim_vendedor