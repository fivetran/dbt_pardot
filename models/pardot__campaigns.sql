{% if execute and flags.WHICH in ('run', 'build') %}
    {% set statuses = dbt_utils.get_column_values(table=ref('int__opportunity_tmp'), column='opportunity_status') %} 
{% else %}
    {% set statuses = [] %}
{% endif %}

with opportunities_tmp as (
    select * 
    from {{ ref('int__opportunity_tmp') }} 
    
), opportunities as ( 
    select 
        source_relation, campaign_id
        count(*) as count_opportunities
        {% if statuses == [] %} , {% endif %} 
    
        {% for status in statuses %} 
        count(case when opportunity_status = '{{ status }}' then 1 end) as count_opportunities_{{ status|lower|replace(' ','_') }}, 
        sum(case when opportunity_status = '{{ status }}' then amount end) as sum_opportunity_amount_{{ status|lower|replace(' ','_') }} 
        {% if not loop.last %} , {% endif %} 
        {% endfor %} 
    from opportunities_tmp 
    group by 1, 2 
    
), campaigns as ( 
     select * 
     from {{ ref('stg_pardot__campaign') }} 
     
), prospects as ( 
    select * 
    from {{ ref('stg_pardot__prospect') }} 
    
), prospects_xf as ( 
    select 
        source_relation, 
        campaign_id, 
        count(*) as count_prospects 
    from prospects 
    group by 1, 2 
    
), joined as ( 
    select 
        campaigns.*, 

        {% for status in statuses %} 
        count_opportunities_{{ status|lower|replace(' ','_') }}, 
        sum_opportunity_amount_{{ status|lower|replace(' ','_') }}, 
        {% endfor %} 
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