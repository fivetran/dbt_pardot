with pardot_prospects as (
    select *
    from {{ ref('stg_pardot__prospect') }}
),

salesforce_contacts as (
    select * 
    from {{ ref('stg_salesforce__contacts') }}
),

pardot_campaigns as (
    select 
        campaign_id,
        campaign_name,
        campaign_salesforce_id
    from {{ ref('stg_pardot__campaign') }}
),

joined as (
    select
        pardot_prospects.prospect_id,
        
        prospect_campaigns.campaign_name as prospect_campaign_name,
        prospect_campaigns.campaign_salesforce_id as prospect_campaign_salesforce_id,

        pardot_prospects.crm_contact_fid,
        salesforce_contacts.account_id
    
    from pardot_prospects

    left join salesforce_contacts
    on pardot_prospects.crm_contact_fid = salesforce_contacts.contact_id

    left join pardot_campaigns as prospect_campaigns
    using (campaign_id)
)

select * from joined