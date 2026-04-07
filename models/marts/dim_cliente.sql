with dim_cliente as (
    select * from {{ ref('int_dim_cliente') }}
)
select * from dim_cliente