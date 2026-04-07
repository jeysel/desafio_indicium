with dim_motivo_venda as (
    select * from {{ ref('int_dim_motivo_venda') }}
)
select * from dim_motivo_venda