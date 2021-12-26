{%- for user in salt['pillar.get']('tool:ssh', [])) %}
  {%- from 'tool-ssh/map.jinja' import user with context %}
SSH configuration is applied for user '{{ user.name }}':
  file.managed:
    - name: {{ user.home }}/.ssh/known_hosts
    - source: salt://tool/ssh/files/known_hosts
    - template: jinja
    - context:
        known_hosts: {{ user.known_hosts | json }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
{%- endfor %}
