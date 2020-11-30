with prospects as (

    select *
    from {{ var('prospect') }}

), activities as (

    select *
    from {{ ref('int__activities_by_prospect') }}

), joined as (

    select
        prospects.*,
        coalesce(activities.count_activity_visits,0) as count_activity_visits,
        coalesce(activities.count_activity_emails,0) as count_activity_emails,
        activities.most_recent_visit_activity_timestamp,
        activities.most_recent_email_activity_timestamp
    from prospects
    left join activities
        using (prospect_id)

)

select *
from joined