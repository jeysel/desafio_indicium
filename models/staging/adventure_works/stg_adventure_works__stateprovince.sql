with source as (
    select * from {{ source('adventure_works', 'stateprovince') }}
),
renamed as (
    select
        stateprovinceid         as state_province_id,
        stateprovincecode       as state_province_code,
        countryregioncode       as country_region_code,
        isonlystateprovinceflag as is_only_state_province_flag,
        name                    as state_province_name,
        territoryid             as territory_id,
        rowguid                 as row_guid,
        modifieddate            as modified_date
    from source
)
select * from renamed