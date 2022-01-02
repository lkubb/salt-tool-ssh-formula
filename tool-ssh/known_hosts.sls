{%- from 'tool-ssh/map.jinja' import ssh %}

{%- for user in ssh.users | selectattr('ssh.known_hosts', 'defined') %}
SSH configuration is applied for user '{{ user.name }}':
  file.managed:
    - name: {{ user.home }}/.ssh/known_hosts
    - source: salt://tool/ssh/files/known_hosts
    - template: jinja
    - context:
        known_hosts: {{ user.ssh.known_hosts | json }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
{%- endfor %}
