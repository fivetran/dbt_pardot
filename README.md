<!--section="pardot_transformation_model"-->
# Pardot dbt Package

<p align="left">
    <a alt="License"
        href="https://github.com/fivetran/dbt_pardot/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0,_<3.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
    <a alt="Fivetran Quickstart Compatible"
        href="https://fivetran.com/docs/transformations/data-models/quickstart-management#quickstartmanagement">
        <img src="https://img.shields.io/badge/Fivetran_Quickstart_Compatible%3F-yes-green.svg" /></a>
</p>

This dbt package transforms data from Fivetran's Pardot connector into analytics-ready tables.

## Resources

- Number of materialized models¹: 21
- Connector documentation
  - [Pardot connector documentation](https://fivetran.com/docs/connectors/applications/pardot)
  - [Pardot ERD](https://fivetran.com/docs/connectors/applications/pardot#schemainformation)
- dbt package documentation
  - [GitHub repository](https://github.com/fivetran/dbt_pardot)
  - [dbt Docs](https://fivetran.github.io/dbt_pardot/#!/overview)
  - [DAG](https://fivetran.github.io/dbt_pardot/#!/overview?g_v=1)
  - [Changelog](https://github.com/fivetran/dbt_pardot/blob/main/CHANGELOG.md)

## What does this dbt package do?
This package enables you to better understand your Pardot prospects, opportunities, lists, and campaign performance. It creates enriched models with metrics focused on prospect activity and campaign effectiveness.

### Output schema
Final output tables are generated in the following target schema:

```
<your_database>.<connector/schema_name>_pardot
```

### Final output tables

By default, this package materializes the following final tables:

| Table | Description |
| :---- | :---- |
| [pardot__campaigns](https://fivetran.github.io/dbt_pardot/#!/model/model.pardot.pardot__campaigns) | Each record represents a Pardot campaign enriched with aggregated metrics including prospect counts, opportunity counts by status (won/lost), and opportunity amounts by status to measure campaign performance and revenue impact. <br></br>**Example Analytics Questions:**<ul><li>Which campaigns have the highest count_opportunities_won and sum_opportunity_amount_won?</li><li>How does campaign cost compare to sum_opportunity_amount_won for ROI analysis?</li><li>Which campaigns have the most count_prospects but low count_opportunities_won (indicating conversion issues)?</li></ul>|
| [pardot__lists](https://fivetran.github.io/dbt_pardot/#!/model/model.pardot.pardot__lists) | Each record represents a Pardot list enriched with aggregated activity metrics from list members including email activity counts, visit activity counts, and timestamps of most recent activities to measure list engagement levels. <br></br>**Example Analytics Questions:**<ul><li>Which lists have the highest count_activity_emails and count_activity_visits from their members?</li><li>How do is_dynamic lists compare to static lists in terms of count_activity_emails and member engagement?</li><li>Which lists have the most recent most_recent_email_activity_timestamp or most_recent_visit_activity_timestamp indicating active engagement?</li></ul>|
| [pardot__opportunities](https://fivetran.github.io/dbt_pardot/#!/model/model.pardot.pardot__opportunities) | Each record represents a Pardot opportunity enriched with the count of associated prospects to connect sales pipeline data with prospect relationships and track opportunity value and progression. <br></br>**Example Analytics Questions:**<ul><li>Which opportunities have the highest amount and probability with the most count_prospects?</li><li>How does count_prospects correlate with opportunity_status (won vs lost) and amount?</li><li>What is the time between created_timestamp and closed_timestamp for opportunities by campaign_id and stage?</li></ul>|
| [pardot__prospects](https://fivetran.github.io/dbt_pardot/#!/model/model.pardot.pardot__prospects) | Each record represents a Pardot prospect enriched with aggregated activity metrics including email activity counts, visit activity counts, and configurable activity type metrics to analyze prospect engagement and lead quality. <br></br>**Example Analytics Questions:**<ul><li>Which prospects have the highest score and grade with the most count_activity_emails and count_activity_visits?</li><li>How does opted_out or is_do_not_email status correlate with most_recent_email_activity_timestamp and engagement levels?</li><li>What prospects have recent most_recent_visit_activity_timestamp but low count_activity_emails indicating sales follow-up opportunities?</li></ul>|

¹ Each Quickstart transformation job run materializes these models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.

---

## Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Pardot connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

## How do I use the dbt package?
You can either add this dbt package in the Fivetran dashboard or import it into your dbt project:

- To add the package in the Fivetran dashboard, follow our [Quickstart guide](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore).
- To add the package to your dbt project, follow the setup instructions in the dbt package's [README file](https://github.com/fivetran/dbt_pardot/blob/main/README.md#how-do-i-use-the-dbt-package) to use this package.

<!--section-end-->

### Install the package
Include the following pardot package version in your `packages.yml` file:
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

```yaml
packages:
  - package: fivetran/pardot
    version: [">=1.3.0", "<1.4.0"]
```
> All required sources and staging models are now bundled into this transformation package. Do not include `fivetran/pardot_source` in your `packages.yml` since this package has been deprecated.

### Define database and schema variables

#### Option A: Single connection
By default, this package runs using your [destination](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile) and the `pardot` schema. If this is not where your Pardot data is (for example, if your Pardot schema is named `pardot_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
  pardot:
    pardot_database: your_database_name
    pardot_schema: your_schema_name
```

#### Option B: Union multiple connections
If you have multiple Pardot connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. For each source table, the package will union all of the data together and pass the unioned table into the transformations. The `source_relation` column in each model indicates the origin of each record.

To use this functionality, you will need to set the `pardot_sources` variable in your root `dbt_project.yml` file:

```yml
# dbt_project.yml

vars:
  pardot:
    pardot_sources:
      - database: connection_1_destination_name # Required
        schema: connection_1_schema_name # Required
        name: connection_1_source_name # Required only if following the step in the following subsection

      - database: connection_2_destination_name
        schema: connection_2_schema_name
        name: connection_2_source_name
```

##### Recommended: Incorporate unioned sources into DAG
> *If you are running the package through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore), the below step is necessary in order to synchronize model runs with your Pardot connections. Alternatively, you may choose to run the package through Fivetran [Quickstart](https://fivetran.com/docs/transformations/quickstart), which would create separate sets of models for each Pardot source rather than one set of unioned models.*

By default, this package defines one single-connection source, called `pardot`, which will be disabled if you are unioning multiple connections. This means that your DAG will not include your Pardot sources, though the package will run successfully.

To properly incorporate all of your Pardot connections into your project's DAG:
1. Define each of your sources in a `.yml` file in your project. Utilize the following template for the `source`-level configurations, and, **most importantly**, copy and paste the table and column-level definitions from the package's `src_pardot.yml` [file](https://github.com/fivetran/dbt_pardot/blob/main/models/staging/src_pardot.yml).

```yml
# a .yml file in your root project

version: 2

sources:
  - name: <name> # ex: Should match name in pardot_sources
    schema: <schema_name>
    database: <database_name>
    loader: fivetran
    config:
      loaded_at_field: _fivetran_synced
      freshness: # feel free to adjust to your liking
        warn_after: {count: 72, period: hour}
        error_after: {count: 168, period: hour}

    tables: # copy and paste from pardot/models/staging/src_pardot.yml - see https://support.atlassian.com/bitbucket-cloud/docs/yaml-anchors/ for how to use anchors to only do so once
```

> **Note**: If there are source tables you do not have (see [Additional configurations](#optional-additional-configurations)), you may still include them, as long as you have set the right variables to `False`.

2. Set the `has_defined_sources` variable (scoped to the `pardot` package) to `True`, like such:
```yml
# dbt_project.yml
vars:
  pardot:
    has_defined_sources: true
```

### (Optional) Additional configurations
<details open><summary>Expand/Collapse details</summary>

#### Passthrough Columns

By default, the package includes all of the standard columns in the `stg_pardot__prospect` model. If you want to include custom columns, configure them using the `prospect_passthrough_columns` variable:

```yml
vars:
  pardot:
    prospect_passthrough_columns: ["custom_creative","custom_contact_state"]
```

#### Additional metrics

By default, this package aggregates and joins activity data onto the prospect model for email and visit events. If you want to have aggregates for other events in the `visitor_activity` table, use `prospect_metrics_activity_types` variable to generate these aggregates. Use the `type_name` column value:

```yml
vars:
  pardot:
    prospect_metrics_activity_types: ["form handler","webinar"]  
```

#### Changing the Build Schema
By default this package will build the Pardot staging models within a schema titled (<target_schema> + `_stg_pardot`) and Pardot final models within a schema titled (<target_schema> + `pardot`) in your target database. If this is not where you would like your modeled Pardot data to be written, add the following configuration to your `dbt_project.yml` file:

```yml
models:
    pardot:
      +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
      staging:
        +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
```

#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:
> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_pardot/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
vars:
    pardot_<default_source_table_name>_identifier: your_table_name 
```
</details>

### (Optional) Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand to view details</summary>
<br>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core™ setup guides](https://fivetran.com/docs/transformations/dbt/setup-guide#transformationsfordbtcoresetupguide).
</details>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.

```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

```

<!--section="pardot_maintenance"-->
## How is this package maintained and can I contribute?

### Package Maintenance
The Fivetran team maintaining this package only maintains the [latest version](https://hub.getdbt.com/fivetran/pardot/latest/) of the package. We highly recommend you stay consistent with the latest version of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_pardot/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Learn how to contribute to a package in dbt's [Contributing to an external dbt package article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657).

<!--section-end-->

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_pardot/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).