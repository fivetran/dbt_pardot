with opportunities as (

    select *
    from {{ ref('stg_pardot__opportunity') }}

), prospects as (

    select *
    from {{ ref('stg_pardot__opportunity_prospect') }}

), prospects_xf as (

    select
        opportunity_id,
        count(*) as count_prospects
    from prospects
    group by 1

), joined as (

    select
        opportunities.*,
        prospects_xf.count_prospects
    from opportunities
    left join prospects_xf
        using (opportunity_id)

)

select *
from joined