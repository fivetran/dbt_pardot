with opportunities as (

    select *
    from {{ ref('stg_pardot__opportunity') }}

), prospects as (

    select *
    from {{ ref('stg_pardot__opportunity_prospect') }}

), prospects_xf as (

    select
        source_relation,
        opportunity_id,
        count(*) as count_prospects
    from prospects
    group by 1, 2

), joined as (

    select
        opportunities.*,
        prospects_xf.count_prospects
    from opportunities
    left join prospects_xf
        on opportunities.opportunity_id = prospects_xf.opportunity_id
        and opportunities.source_relation = prospects_xf.source_relation

)

select *
from joined