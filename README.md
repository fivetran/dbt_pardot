<p align="center">
    <a alt="License"
        href="https://github.com/fivetran/dbt_pardot/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

# Pardot Transformation dbt Package ([Docs](https://fivetran.github.io/dbt_pardot/))
# 📣 What does this dbt package do?
- Produces modeled tables that beverage Pardot data from [Fivetran's connector](https://fivetran.com/docs/applications/pardot) in the format described by [this ERD](https://fivetran.com/docs/applications/pardot#schemainformation) and builds off the output of our [Pardot source package](https://github.com/fivetran/dbt_pardot_source).
- Enables you to better understand your Pardot prospects, opportunities, lists, and campaign performance. 
- Generates a comprehensive data dictionary of your source and modeled Pardot data through the [dbt docs site](https://fivetran.github.io/dbt_pardot/#!/overview).

The following table provides a detailed list of all models materialized within this package by default. 
> TIP: See more details about these models in the package's [dbt docs site](https://fivetran.github.io/dbt_pardot/#!/overview?g_v=1).
.
## Models

This package contains transformation models, designed to work simultaneously with our [Pardot source package](https://github.com/fivetran/dbt_pardot_source). A dependency on the source package is declared in this package's `packages.yml` file, so it will automatically download when you run `dbt deps`. The primary outputs of this package are described below. Intermediate models are used to create these output models.

| **Model**                | **Description**                                                                                                     |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------- |
| [pardot__campaigns](https://fivetran.github.io/dbt_pardot/#!/model/model.pardot.pardot__campaigns)         | Each record represents a campaign in Pardot, enriched with metrics about associated prospects.                      |
| [pardot__lists](https://fivetran.github.io/dbt_pardot/#!/model/model.pardot.pardot__lists)            | Each record represents a list in Pardot, enriched with metrics about associated prospect activity.                  |
| [pardot__opportunities](https://fivetran.github.io/dbt_pardot/#!/model/model.pardot.pardot__opportunities)    | Each record represents an opportunity in Pardot, enriched with metrics about associated prospects.                   |
| [pardot__prospects](https://fivetran.github.io/dbt_pardot/#!/model/model.pardot.pardot__prospects)        | Each record represents a prospect in Pardot, enriched with metrics about associated prospect activity.             |

# 🎯 How do I use the dbt package?

## Step 1: Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Pardot connector syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, or **PostgreSQL** destination.

## Step 2: Install the package
Include the following pardot package version in your `packages.yml` file:
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

```yaml
packages:
  - package: fivetran/pardot
    version: [">=0.5.0", "<0.6.0"]
```

## Step 3: Define database and schema variables
By default, this package runs using your destination and the `pardot` schema. If this is not where your Pardot data is (for example, if your Pardot schema is named `pardot_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml

```yml
vars:
  pardot_source:
    pardot_database: your_database_name
    pardot_schema: your_schema_name 
```

## (Optional) Step 4: Additional configurations

<details><summary>Expand for configurations</summary>

### Passthrough Columns

By default, the package includes all of the standard columns in the `stg_pardot__prospect` model. If you want to include custom columns, configure them using the `prospect_passthrough_columns` variable:

```yml
vars:
  pardot_source:
    prospect_passthrough_columns: ["custom_creative","custom_contact_state"]
```

### Additional metrics

By default, this package aggregates and joins activity data onto the prospect model for email and visit events. If you want to have aggregates for other events in the `visitor_activity` table, use `prospect_metrics_activity_types` variable to generate these aggregates. Use the `type_name` column value:

```yml
vars:
  pardot:
    prospect_metrics_activity_types: ["form handler","webinar"]  
```

### Changing the Build Schema
By default this package will build the Pardot staging models within a schema titled (<target_schema> + `_stg_pardot`) and Pardot final models within a schema titled (<target_schema> + `pardot`) in your target database. If this is not where you would like your modeled Pardot data to be written, add the following configuration to your `dbt_project.yml` file:

```yml
models:
    pardot:
      +schema: my_new_schema_name # leave blank for just the target_schema
    pardot_source:
      +schema: my_new_schema_name # leave blank for just the target_schema
```

### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:
> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_pardot_source/blob/main/dbt_project.yml) variable declarations to see the expected names.
    
```yml
vars:
    pardot_<default_source_table_name>_identifier: your_table_name 
```
</details>

## (Optional) Step 6: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand to view details</summary>
<br>
    
Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core™ setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).
</details>

# 🔍 Does this package have dependencies?
This dbt package is dependent on the following dbt packages. Please be aware that these dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
    
```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

    - package: fivetran/pardot_source
      version: [">=0.5.0", "<0.6.0"]
```

# 🙌 How is this package maintained and can I contribute?
## Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/pardot/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_pardot/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

## Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions! 

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package!

# 🏪 Are there any resources available?
- If you have questions or want to reach out for help, please refer to the [GitHub Issue](https://github.com/fivetran/dbt_pardot/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
- Have questions or want to just say hi? Book a time during our office hours [on Calendly](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com.