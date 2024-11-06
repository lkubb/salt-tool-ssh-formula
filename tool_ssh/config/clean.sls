# vim: ft=sls

{#-
    Removes the configuration of the OpenSSH package.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as ssh with context %}


{%- for user in ssh.users | selectattr("ssh.config", "defined") | selectattr("ssh.config") %}

OpenSSH config file is cleaned for user '{{ user.name }}':
  file.absent:
    - name: {{ user["_ssh"].conffile }}

OpenSSH config dir is absent for user '{{ user.name }}':
  file.absent:
    - name: {{ user["_ssh"].confdir }}
{%- endfor %}
