with source as (
    select * from {{ source('adventure_works', 'sales_salesorderdetail') }}
),
renamed as (
    select
        salesorderid            as sales_order_id,
        salesorderdetailid      as sales_order_detail_id,
        carriertrackingnumber   as carrier_tracking_number,
        orderqty                as order_qty,
        productid               as product_id,
        unitprice               as unit_price,
        unitpricediscount       as unit_price_discount,
        unitprice * orderqty                                as valor_negociado,
        unitprice * orderqty * (1 - unitpricediscount)     as valor_negociado_liquido,
        rowguid                 as row_guid,
        modifieddate            as modified_date
    from source
)
select * from renamed