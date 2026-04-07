with fato_vendas as (
    select * from {{ ref('int_fato_vendas') }}
)
select * from fato_vendas