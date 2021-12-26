{%- set users = salt['pillar.get']('tool:ssh') -%}

include:
  - .package
{%- if users | selectattr('config') %}
  - .config
{%- endif %}
{%- if users | selectattr('known_hosts') %}
  - .config
{%- endif %}
