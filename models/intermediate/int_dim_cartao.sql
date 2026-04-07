with cartao as (
    select * from {{ ref('stg_adventure_works__creditcard') }}
),
pessoa_cartao as (
    select * from {{ ref('stg_adventure_works__personcreditcard') }}
),
cartao_enriquecido as (
    select
        {{ dbt_utils.generate_surrogate_key(['cartao.credit_card_id']) }} as cartao_key,
        cartao.credit_card_id,
        cartao.card_type,
        cartao.card_number,
        cartao.exp_month,
        cartao.exp_year,
        pessoa_cartao.business_entity_id
    from cartao
    left join pessoa_cartao
        on cartao.credit_card_id = pessoa_cartao.credit_card_id
)
select * from cartao_enriquecido