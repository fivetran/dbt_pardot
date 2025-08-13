with campaigns as (

    select *
    from {{ ref('stg_pardot__campaign') }}

), prospects as (

    select *
    from {{ ref('stg_pardot__prospect') }}

), opportunities as (

    select *
    from {{ ref('int__opportunities_by_campaign') }}

), prospects_xf as (

    select 
        campaign_id,
        count(*) as count_prospects 
    from prospects
    group by 1

), joined as (

    select *
    from campaigns
    left join opportunities
        using (campaign_id)
    left join prospects_xf
        using (campaign_id)

)   

select *
from joined