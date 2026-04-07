with motivo as (
    select * from {{ ref('stg_adventure_works__salesreason') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['sales_reason_id']) }} as motivo_venda_key,
    sales_reason_id,
    sales_reason_name   as motivo_venda_name,
    reason_type
from motivo