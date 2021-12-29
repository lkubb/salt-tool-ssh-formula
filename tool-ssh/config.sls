{%- from 'tool-ssh/map.jinja' import ssh %}

{%- for user in ssh.users | selectattr('ssh.config')) %}
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
        ssh_config: {{ user.ssh.config | json }} {# json is subset of yaml, tends to cause less friction #}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
{%- endfor %}
