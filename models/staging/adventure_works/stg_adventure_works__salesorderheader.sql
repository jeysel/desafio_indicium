with source as (
    select * from {{ source('adventure_works', 'salesorderheader') }}
),
renamed as (
    select
        salesorderid            as sales_order_id,
        revisionnumber          as revision_number,
        orderdate               as order_date,
        duedate                 as due_date,
        shipdate                as ship_date,
        status,
        onlineorderflag         as online_order_flag,
        purchaseordernumber     as purchase_order_number,
        accountnumber           as account_number,
        customerid              as customer_id,
        salespersonid           as sales_person_id,
        territoryid             as territory_id,
        billtoaddressid         as bill_to_address_id,
        shiptoaddressid         as ship_to_address_id,
        shipmethodid            as ship_method_id,
        creditcardid            as credit_card_id,
        creditcardapprovalcode  as credit_card_approval_code,
        currencyrateid          as currency_rate_id,
        subtotal                as sub_total,
        taxamt                  as tax_amt,
        freight,
        totaldue                as total_due,
        comment,
        rowguid                 as row_guid,
        modifieddate            as modified_date
    from source
)
select * from renamed