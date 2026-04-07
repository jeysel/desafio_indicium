with dim_produto as (
    select * from {{ ref('int_dim_produto') }}
)
select * from dim_produto