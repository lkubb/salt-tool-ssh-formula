{%- from 'tool-ssh/map.jinja' import ssh %}

include:
  - .package
{%- if ssh.users | selectattr('ssh.config') %}
  - .config
{%- endif %}
{%- if ssh.users | selectattr('ssh.known_hosts') %}
  - .known_hosts
{%- endif %}
