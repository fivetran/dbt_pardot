with activities as (

    select *
    from {{ ref('stg_pardot__visitor_activity') }}

), visitors as (

    select *
    from {{ ref('stg_pardot__visitor') }}

), joined as (

    select
        coalesce(visitors.source_relation, activities.source_relation) as source_relation,
        activities.event_type_name,
        activities.created_timestamp,
        coalesce(visitors.prospect_id, activities.prospect_id) as prospect_id
    from activities
    left join visitors
        on activities.visitor_id = visitors.visitor_id
        and activities.source_relation = visitors.source_relation

), aggregated as (

    select
        source_relation,
        prospect_id,

        {% for event_type in var('prospect_metrics_activity_types') %}
        count(case when lower(event_type_name) = lower('{{ event_type }}') then 1 end) as count_activity_{{ event_type|lower|replace(' ','_') }},
        max(case when lower(event_type_name) = lower('{{ event_type }}') then created_timestamp end) as most_recent_{{ event_type|lower|replace(' ','_') }}_activity_timestamp,
        {% endfor %}

        count(case when lower(event_type_name) = 'visit' then 1 end) as count_activity_visits,
        max(case when lower(event_type_name) = 'visit' then created_timestamp end) as most_recent_visit_activity_timestamp,
        count(case when lower(event_type_name) = 'email' then 1 end) as count_activity_emails,
        max(case when lower(event_type_name) = 'email' then created_timestamp end) as most_recent_email_activity_timestamp
    from joined
    group by 1, 2

)

select *
from aggregated