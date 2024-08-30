with prospects as (

    select *
    from {{ var('prospect') }}

), activities as (

    select *
    from {{ ref('int__activities_by_prospect') }}

), enriched_prospects as (

    select 
        prospect_id,
        account_id,
    from {{ ref('int_pardot__prospects_join_enriched') }}

), joined as (

    select
        prospects.*,

        enriched_prospects.account_id,

        {% for event_type in var('prospect_metrics_activity_types') %}
        coalesce(activities.count_activity_{{ event_type|lower|replace(' ','_') }},0) as count_activity_{{ event_type|lower|replace(' ','_') }},
        activities.most_recent_{{ event_type|lower|replace(' ','_') }}_activity_timestamp,
        {% endfor %}
        
        coalesce(activities.count_activity_visits,0) as count_activity_visits,
        coalesce(activities.count_activity_emails,0) as count_activity_emails,
        activities.most_recent_visit_activity_timestamp,
        activities.most_recent_email_activity_timestamp
    from prospects
    left join activities
        using (prospect_id)
    left join enriched_prospects
        using (prospect_id)

)

select *
from joined