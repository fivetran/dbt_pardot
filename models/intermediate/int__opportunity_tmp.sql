{{ config(materialized='view') }}

select *
from {{ var('opportunity') }}