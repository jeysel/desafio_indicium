with cliente as (
    select * from {{ ref('stg_adventure_works__customer') }}
),
pessoa as (
    select * from {{ ref('stg_adventure_works__person') }}
),
cliente_enriquecido as (
    select
        {{ dbt_utils.generate_surrogate_key(['cliente.customer_id']) }} as cliente_key,
        cliente.customer_id,
        pessoa.first_name,
        pessoa.last_name,
        pessoa.first_name || ' ' || pessoa.last_name    as nome_cliente,
        pessoa.person_type,
        cliente.territory_id
    from cliente
    left join pessoa
        on cliente.person_id = pessoa.business_entity_id
)
select * from cliente_enriquecido