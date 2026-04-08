with datas as (
    select * from {{ source('adventure_works_seeds', 'dim_datas') }}
),
datas_enriquecido as (
    select
        {{ dbt_utils.generate_surrogate_key(['dt_data']) }}  as data_key,
        dt_data             as data_completa,
        ano,
        mes,
        dia,
        trimestre,
        semana_ano,
        dia_semana_num,
        nm_mes,
        nm_mes_abrev,
        nm_dia_semana,
        ano_mes,
        nm_trimestre,
        sigla_trimestre,
        fl_fim_de_semana,
        primeiro_dia_mes,
        ultimo_dia_mes
    from datas
)
select * from datas_enriquecido