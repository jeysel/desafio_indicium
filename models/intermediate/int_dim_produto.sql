with produto as (
    select * from {{ ref('stg_adventure_works__product') }}
),
subcategoria as (
    select * from {{ ref('stg_adventure_works__productsubcategory') }}
),
categoria as (
    select * from {{ ref('stg_adventure_works__productcategory') }}
),
produto_enriquecido as (
    select
        {{ dbt_utils.generate_surrogate_key(['produto.product_id']) }} as produto_key,
        produto.product_id,
        produto.product_name,
        produto.product_number,
        produto.color,
        produto.standard_cost,
        produto.list_price,
        produto.size,
        produto.weight,
        produto.product_line,
        produto.class,
        produto.style,
        produto.sell_start_date,
        produto.sell_end_date,
        subcategoria.product_subcategory_name,
        categoria.product_category_name
    from produto
    left join subcategoria
        on produto.product_subcategory_id = subcategoria.product_subcategory_id
    left join categoria
        on subcategoria.product_category_id = categoria.product_category_id
)
select * from produto_enriquecido