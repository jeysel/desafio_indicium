with datas as (
    select distinct cast(orderdate as date) as data_completa
    from {{ ref('stg_adventure_works__salesorderheader') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['data_completa']) }}   as data_key,
    data_completa,
    year(data_completa)                                         as ano,
    month(data_completa)                                        as mes,
    day(data_completa)                                          as dia,
    date_format(data_completa, 'MMMM')                         as nome_mes,
    quarter(data_completa)                                      as trimestre,
    dayofweek(data_completa)                                    as dia_semana,
    case when dayofweek(data_completa) in (1, 7)
        then false else true
    end                                                         as is_dia_util
from datas