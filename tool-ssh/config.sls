{%- for user in salt['pillar.get']('tool:ssh', []) | selectattr('config')) %}
  {%- from 'tool-ssh/map.jinja' import user with context %}
SSH directory is present for user '{{ user.name }}':
  file.directory:
    - name: {{ user.home }}/.ssh
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0700'

SSH configuration is applied for user '{{ user.name }}':
  file.managed:
    - name: {{ user.home }}/.ssh/config
    - source: salt://tool-ssh/files/ssh_config
    - template: jinja
    - context:
        ssh_config: {{ user.config | json }} {# json is subset of yaml, tends to cause less friction #}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
{%- endfor %}
