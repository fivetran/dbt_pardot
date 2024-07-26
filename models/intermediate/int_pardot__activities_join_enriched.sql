with visitor_activity as (
    select *
    from {{ ref('stg_pardot__visitor_activity') }}
),

campaigns as (
    select *
    from {{ ref('stg_pardot__campaign') }}
),

list_emails as (
    select *
    from {{ ref('stg_pardot__list_email') }}
)

select 
    visitor_activity.*,
    list_email_name,
    list_email_subject,
    list_email_sent_at,
    campaigns.campaign_name as activity_campaign_name 

from visitor_activity

left join campaigns on visitor_activity.campaign_id = campaigns.campaign_id

left join list_emails on visitor_activity.list_email_id = list_emails.list_email_id

