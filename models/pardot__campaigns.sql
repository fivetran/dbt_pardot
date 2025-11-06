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
        source_relation,
        campaign_id,
        count(*) as count_prospects
    from prospects
    group by 1, 2

), joined as (

    select 
        campaigns.source_relation,
        campaigns.campaign_id,
        campaigns.campaign_name,
        opportunities.count_opportunities,
        opportunities.count_opportunities_won,
        opportunities.sum_opportunity_amount_won,
        prospects_xf.count_prospects
    from campaigns
    left join opportunities
        on campaigns.campaign_id = opportunities.campaign_id
        and campaigns.source_relation = opportunities.source_relation
    left join prospects_xf
        on campaigns.campaign_id = prospects_xf.campaign_id
        and campaigns.source_relation = prospects_xf.source_relation

)   

select *
from joined