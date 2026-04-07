with status_venda as (
    select distinct status
    from {{ ref('stg_adventure_works__salesorderheader') }}
),
status_enriquecido as (
    select
        {{ dbt_utils.generate_surrogate_key(['status']) }} as status_key,
        status,
        case status
            when 1 then 'Em Processo'
            when 2 then 'Aprovado'
            when 3 then 'Pendente'
            when 4 then 'Rejeitado'
            when 5 then 'Enviado'
            when 6 then 'Cancelado'
            else 'Desconhecido'
        end as status_descricao
    from status_venda
)
select * from status_enriquecido