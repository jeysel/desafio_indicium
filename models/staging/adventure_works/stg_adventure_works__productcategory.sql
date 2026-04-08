with source as (
    select * from {{ source('adventure_works', 'production_productcategory') }}
),
renamed as (
    select
        productcategoryid   as product_category_id,
        name                as product_category_name,
        rowguid             as row_guid,
        modifieddate        as modified_date
    from source
)
select * from renamed