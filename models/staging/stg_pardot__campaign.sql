
with base as (

    select * 
    from {{ ref('stg_pardot__campaign_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_pardot__campaign_tmp')),
                staging_columns=get_campaign_columns()
            )
        }}
        {{ pardot.apply_source_relation() }}

    from base
    where not coalesce(_fivetran_deleted, false)
),

final as (

    select
        source_relation,
        id as campaign_id,
        name as campaign_name,
        cost,
        _fivetran_deleted,
        _fivetran_synced
    from fields
)

select * from final
