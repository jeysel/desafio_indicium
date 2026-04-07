with source as (
    select * from {{ source('adventure_works', 'product') }}
),
renamed as (
    select
        productid               as product_id,
        name                    as product_name,
        productnumber           as product_number,
        color,
        standardcost            as standard_cost,
        listprice               as list_price,
        size,
        weight,
        productsubcategoryid    as product_subcategory_id,
        productmodelid          as product_model_id,
        sellstartdate           as sell_start_date,
        sellenddate             as sell_end_date,
        discontinueddate        as discontinued_date,
        rowguid                 as row_guid,
        modifieddate            as modified_date
    from source
)
select * from renamed