{% set statuses = dbt_utils.get_column_values(table=ref('int__opportunity_tmp'), column='opportunity_status') %}

with opportunities as (

    select *
    from {{ ref('int__opportunity_tmp') }}

), aggregated as (

    select 
        campaign_id,
        count(*) as count_opportunities,

        {% for status in statuses %}
        count(case when opportunity_status = '{{ status }}' then 1 end) as count_opportunities_{{ status|lower|replace(' ','_') }},
        sum(case when opportunity_status = '{{ status }}' then amount end) as sum_opportunity_amount_{{ status|lower|replace(' ','_') }}
        {% if not loop.last %} , {% endif %}
        {% endfor %}
    
    from opportunities
    group by 1

)

select *
from aggregated