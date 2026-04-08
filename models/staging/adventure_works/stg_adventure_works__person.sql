with source as (
    select * from {{ source('adventure_works', 'person_person') }}
),
renamed as (
    select
        businessentityid    as business_entity_id,
        persontype          as person_type,
        firstname           as first_name,
        middlename          as middle_name,
        lastname            as last_name,
        emailpromotion      as email_promotion,
        rowguid             as row_guid,
        modifieddate        as modified_date
    from source
)
select * from renamed