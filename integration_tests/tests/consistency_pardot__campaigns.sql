{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

{% set exclude_cols = var('consistency_test_exclude_metrics', ['sum_opportunity_amount_lost', 'sum_opportunity_amount_won', 'sum_opportunity_amount_open']) %}

-- this test ensures the pardot__campaigns end model matches the prior version
with prod as (
    select 
        {{ dbt_utils.star(from=ref('pardot__campaigns'), except=exclude_cols) }},
        round(sum_opportunity_amount_lost, 2) as sum_opportunity_amount_lost,
        round(sum_opportunity_amount_won, 2) as sum_opportunity_amount_won,
        round(sum_opportunity_amount_open, 2) as sum_opportunity_amount_open

    from {{ target.schema }}_pardot_prod.pardot__campaigns
),

dev as (
    select 
        {{ dbt_utils.star(from=ref('pardot__campaigns'), except=exclude_cols) }},
        round(sum_opportunity_amount_lost, 2) as sum_opportunity_amount_lost,
        round(sum_opportunity_amount_won, 2) as sum_opportunity_amount_won,
        round(sum_opportunity_amount_open, 2) as sum_opportunity_amount_open
    from {{ target.schema }}_pardot_dev.pardot__campaigns
),

prod_not_in_dev as (
    -- rows from prod not found in dev
    select * from prod
    except distinct
    select * from dev
),

dev_not_in_prod as (
    -- rows from dev not found in prod
    select * from dev
    except distinct
    select * from prod
),

final as (
    select
        *,
        'from prod' as source
    from prod_not_in_dev

    union all -- union since we only care if rows are produced

    select
        *,
        'from dev' as source
    from dev_not_in_prod
)

select *
from final