[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) ![dbt logo and version](https://img.shields.io/static/v1?logo=dbt&label=dbt-version&message=>=1.0.0,<2.0.0&color=orange)
# Pardot ([docs](https://fivetran-dbt-pardot.netlify.app/#!/overview))

This package models Pardot data from [Fivetran's connector](https://fivetran.com/docs/applications/pardot). It uses data in the format described by [the Pardot ERD](https://docs.google.com/presentation/d/1YQquOmlb7pIMI1Tcc2Qcner4rSCI8RYdrie1DRkJzds/edit#slide=id.g244d368397_0_1).

This package enables you to better understand your Pardot prospects, opportunities, lists, and campaign performance. It includes analysis-ready models, enriched with relevant metrics.

## Models

This package contains transformation models, designed to work simultaneously with our [Pardot source package](https://github.com/fivetran/dbt_pardot_source). A dependency on the source package is declared in this package's `packages.yml` file, so it will automatically download when you run `dbt deps`. The primary outputs of this package are described below. Intermediate models are used to create these output models.

| **model**                | **description**                                                                                                     |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------- |
| [pardot__campaigns](models/pardot__campaigns.sql)         | Each record represents a campaign in Pardot, enriched with metrics about associated prospects.                      |
| [pardot__lists](models/pardot__lists.sql)            | Each record represents a list in Pardot, enriched with metrics about associated prospect activity.                  |
| [pardot__opportunities](models/pardot__opportunities.sql)    | Each record represents an opportunity in Pardot, enriched with metrics about associated prospects.                   |
| [pardot__prospects](models/pardot__prospects.sql)        | Each record represents a prospect in Pardot, enriched with metrics about associated prospect activity.             |


## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your `packages.yml`

```yaml
packages:
  - package: fivetran/pardot
    version: [">=0.4.0", "<0.5.0"]
```

## Configuration

### Source data location

By default, this package will look for your Pardot data in the `pardot` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your Pardot data is, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
  pardot_source:
    pardot_database: your_database_name
    pardot_schema: your_schema_name 
```

### Passthrough Columns

By default, the package includes all of the standard columns in the `stg_pardot__prospect` model. If you want to include custom columns, configure them using the `prospect_passthrough_columns` variable:

```yml
# dbt_project.yml

...
vars:
  pardot_source:
    prospect_passthrough_columns: ["custom_creative","custom_contact_state"]
```

### Additional metrics

By default, this package aggregates and joins activity data onto the prospect model for email and visit events. If you want to have aggregates for other events in the `visitor_activity` table, use `prospect_metrics_activity_types` variable to generate these aggregates. Use the `type_name` column value:

```yml
# dbt_project.yml

...
vars:
  pardot:
    prospect_metrics_activity_types: ["form handler","webinar"]  
```

### Changing the Build Schema
By default this package will build the Pardot staging models within a schema titled (<target_schema> + `_stg_pardot`) and Pardot final models within a schema titled (<target_schema> + `pardot`) in your target database. If this is not where you would like your modeled Pardot data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
models:
    pardot:
      +schema: my_new_schema_name # leave blank for just the target_schema
    pardot_source:
      +schema: my_new_schema_name # leave blank for just the target_schema
```

## Database Support
This package has been tested on BigQuery, Snowflake, Redshift, and Postgres.

## Contributions

Additional contributions to this package are very welcome! Please create issues
or open PRs against `master`. Check out 
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.

## Resources:
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Have questions, feedback, or need help? Book a time during our office hours [using Calendly](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn how to orchestrate [dbt transformations with Fivetran](https://fivetran.com/docs/transformations/dbt)
- Learn more about Fivetran overall [in our docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
