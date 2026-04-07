with header as (
    select * from {{ ref('stg_adventure_works__salesorderheader') }}
),
detail as (
    select * from {{ ref('stg_adventure_works__salesorderdetail') }}
),
dim_data as (
    select * from {{ ref('dim_data') }}
),
dim_produto as (
    select * from {{ ref('dim_produto') }}
),
dim_cliente as (
    select * from {{ ref('dim_cliente') }}
),
dim_vendedor as (
    select * from {{ ref('dim_vendedor') }}
),
dim_localidade as (
    select * from {{ ref('dim_localidade') }}
),
dim_cartao as (
    select * from {{ ref('dim_cartao') }}
),
dim_status as (
    select * from {{ ref('dim_status') }}
),
dim_motivo_venda as (
    select * from {{ ref('dim_motivo_venda') }}
),
salesreason as (
    select * from {{ ref('stg_adventure_works__salesorderheadersalesreason') }}
),
fato as (
    select
        {{ dbt_utils.generate_surrogate_key([
            'detail.sales_order_id',
            'detail.sales_order_detail_id'
        ]) }}                                   as venda_key,

        -- chaves estrangeiras
        dd.data_key,
        dp.produto_key,
        dc.cliente_key,
        dv.vendedor_key,
        dl.localidade_key,
        dcc.cartao_key,
        ds.status_key,
        dmv.motivo_venda_key,

        -- grãos
        detail.sales_order_id,
        detail.sales_order_detail_id,
        header.order_date,
        header.online_order_flag,

        -- métricas
        detail.order_qty                        as quantidade_comprada,
        detail.unit_price                       as preco_unitario,
        detail.unit_price_discount              as desconto,
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
    left join salesreason sr
        on header.sales_order_id = sr.sales_order_id
    left join dim_motivo_venda dmv
        on sr.sales_reason_id = dmv.sales_reason_id
)

select * from fato