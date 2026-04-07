with header as (
    select * from {{ ref('stg_adventure_works__salesorderheader') }}
),
detail as (
    select * from {{ ref('stg_adventure_works__salesorderdetail') }}
),
dim_data as (
    select data_key, data_completa
    from {{ ref('int_dim_data') }}
),
dim_produto as (
    select produto_key, product_id
    from {{ ref('int_dim_produto') }}
),
dim_cliente as (
    select cliente_key, customer_id
    from {{ ref('int_dim_cliente') }}
),
dim_vendedor as (
    select vendedor_key, sales_person_id
    from {{ ref('int_dim_vendedor') }}
),
dim_localidade as (
    select localidade_key, address_id
    from {{ ref('int_dim_localidade') }}
),
dim_cartao as (
    select cartao_key, credit_card_id
    from {{ ref('int_dim_cartao') }}
),
dim_status as (
    select status_key, status
    from {{ ref('int_dim_status') }}
),
motivo as (
    select
        sales_order_id,
        min(sales_reason_id) as sales_reason_id
    from {{ ref('stg_adventure_works__salesorderheadersalesreason') }}
    group by sales_order_id
),
dim_motivo as (
    select motivo_venda_key, sales_reason_id
    from {{ ref('int_dim_motivo_venda') }}
),
joined as (
    select
        {{ dbt_utils.generate_surrogate_key([
            'detail.sales_order_id',
            'detail.sales_order_detail_id'
        ]) }}                               as venda_key,

        dd.data_key,
        dp.produto_key,
        dc.cliente_key,
        dv.vendedor_key,
        dl.localidade_key,
        dcc.cartao_key,
        ds.status_key,
        dm.motivo_venda_key,

        detail.sales_order_id,
        detail.sales_order_detail_id,
        header.order_date,
        header.online_order_flag,

        detail.order_qty             as quantidade_comprada,
        detail.unit_price            as preco_unitario,
        detail.unit_price_discount   as desconto,
        detail.valor_negociado,
        detail.valor_negociado_liquido

    from detail
    inner join header
        on detail.sales_order_id = header.sales_order_id
    left join dim_data dd
        on cast(header.order_date as date) = dd.data_completa
    left join dim_produto dp
        on detail.product_id = dp.product_id
    left join dim_cliente dc
        on header.customer_id = dc.customer_id
    left join dim_vendedor dv
        on header.sales_person_id = dv.sales_person_id
    left join dim_localidade dl
        on header.ship_to_address_id = dl.address_id
    left join dim_cartao dcc
        on header.credit_card_id = dcc.credit_card_id
    left join dim_status ds
        on header.status = ds.status
    left join motivo sr
        on header.sales_order_id = sr.sales_order_id
    left join dim_motivo dm
        on sr.sales_reason_id = dm.sales_reason_id
)
select * from joined