{{ config(materialized='view') }}

select *
from {{ ref('stg_pardot__opportunity') }}