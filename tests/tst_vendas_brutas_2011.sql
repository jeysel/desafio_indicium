/*
    Esse teste certifica que as vendas brutas de 2011 batem
    com o valor auditado pela contabilidade de $12.646.112,16
    conforme solicitado pelo CEO Carlos Silveira.
*/

with soma_vendas_2011 as (
    select
        year(order_date)        as ano,
        sum(valor_negociado)    as total
    from {{ ref('fato_vendas') }}
    group by 1
)

select *
from soma_vendas_2011
where ano = 2011
and total not between 12646112.06 and 12646112.26