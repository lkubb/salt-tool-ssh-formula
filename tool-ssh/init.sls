{%- from 'tool-ssh/map.jinja' import ssh %}

include:
  - .package
{%- if ssh.users | selectattr('ssh.config', 'defined') %}
  - .config
{%- endif %}
{%- if ssh.users | selectattr('ssh.known_hosts', 'defined') %}
  - .known_hosts
{%- endif %}
