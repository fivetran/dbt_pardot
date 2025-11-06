{% macro apply_source_relation() -%}

{{ adapter.dispatch('apply_source_relation', 'pardot') () }}

{%- endmacro %}

{% macro default__apply_source_relation() -%}

{% if var('pardot_sources', []) != [] %}
, _dbt_source_relation as source_relation
{% else %}
, '{{ var("pardot_database", target.database) }}' || '.'|| '{{ var("pardot_schema", "pardot") }}' as source_relation
{% endif %}

{%- endmacro %}