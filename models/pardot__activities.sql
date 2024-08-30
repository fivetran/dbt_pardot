with activities as (
    select * 
    from {{ ref('int_pardot__activities_join_enriched') }}
),

prospects as (
    select *
    from {{ ref('int_pardot__prospects_join_enriched') }}  
),

joined as (
    select
        *

    from activities

    left join prospects using (prospect_id)
)

select
    *

from joined