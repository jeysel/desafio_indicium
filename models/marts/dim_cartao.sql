with dim_cartao as (
    select * from {{ ref('int_dim_cartao') }}
)
select * from dim_cartao