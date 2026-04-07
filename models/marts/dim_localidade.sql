with dim_localidade as (
    select * from {{ ref('int_dim_localidade') }}
)
select * from dim_localidade