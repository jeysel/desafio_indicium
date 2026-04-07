with source as (
    select * from {{ source('adventure_works', 'personcreditcard') }}
),
renamed as (
    select
        businessentityid    as business_entity_id,
        creditcardid        as credit_card_id,
        modifieddate        as modified_date
    from source
)
select * from renamed