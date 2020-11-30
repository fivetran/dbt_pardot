with lists as (

    select *
    from {{ var('list') }}

), activities as (

    select *
    from {{ ref('int__activities_by_list') }}

), joined as (

    select
        lists.*,
        coalesce(activities.count_activity_emails,0) as count_activity_emails,
        coalesce(activities.count_activity_visits,0) as count_activity_visits,
        activities.most_recent_email_activity_timestamp,
        activities.most_recent_visit_activity_timestamp
    from lists
    left join activities
        using (list_id)

)

select *
from joined