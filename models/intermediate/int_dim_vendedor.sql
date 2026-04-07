with vendedor as (
    select * from {{ ref('stg_adventure_works__salesperson') }}
),
funcionario as (
    select * from {{ ref('stg_adventure_works__employee') }}
),
pessoa as (
    select * from {{ ref('stg_adventure_works__person') }}
),
vendedor_enriquecido as (
    select
        {{ dbt_utils.generate_surrogate_key(['vendedor.business_entity_id']) }} as vendedor_key,
        vendedor.business_entity_id     as sales_person_id,
        pessoa.first_name,
        pessoa.last_name,
        pessoa.first_name || ' ' || pessoa.last_name    as nome_vendedor,
        funcionario.job_title,
        vendedor.sales_quota,
        vendedor.sales_ytd,
        vendedor.sales_last_year,
        vendedor.commission_pct,
        vendedor.territory_id
    from vendedor
    left join funcionario
        on vendedor.business_entity_id = funcionario.business_entity_id
    left join pessoa
        on vendedor.business_entity_id = pessoa.business_entity_id
)
select * from vendedor_enriquecido