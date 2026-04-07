with header_reason as (
    select * from {{ ref('stg_adventure_works__salesorderheadersalesreason') }}
),
dim_motivo as (
    select * from {{ ref('dim_motivo_venda') }}
)

select
    {{ dbt_utils.generate_surrogate_key([
        'header_reason.sales_order_id',
        'header_reason.sales_reason_id'
    ]) }}                               as venda_motivo_key,
    header_reason.sales_order_id,
    dm.motivo_venda_key,
    dm.motivo_venda_name,
    dm.reason_type
from header_reason
left join dim_motivo dm
    on header_reason.sales_reason_id = dm.sales_reason_id