with source as (
    select * from {{ source('adventure_works', 'address') }}
),
renamed as (
    select
        addressid           as address_id,
        addressline1        as address_line1,
        addressline2        as address_line2,
        city,
        stateprovinceid     as state_province_id,
        postalcode          as postal_code,
        rowguid             as row_guid,
        modifieddate        as modified_date
    from source
)
select * from renamed