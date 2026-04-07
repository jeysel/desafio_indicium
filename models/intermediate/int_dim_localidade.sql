with endereco as (
    select * from {{ ref('stg_adventure_works__address') }}
),
estado as (
    select * from {{ ref('stg_adventure_works__stateprovince') }}
),
pais as (
    select * from {{ ref('stg_adventure_works__countryregion') }}
),
localidade_enriquecido as (
    select
        {{ dbt_utils.generate_surrogate_key(['endereco.address_id']) }} as localidade_key,
        endereco.address_id,
        endereco.address_line1,
        endereco.address_line2,
        endereco.city           as cidade,
        endereco.postal_code,
        estado.state_province_name  as estado,
        estado.state_province_code,
        pais.country_region_name    as pais,
        pais.country_region_code
    from endereco
    left join estado
        on endereco.state_province_id = estado.state_province_id
    left join pais
        on estado.country_region_code = pais.country_region_code
)
select * from localidade_enriquecido