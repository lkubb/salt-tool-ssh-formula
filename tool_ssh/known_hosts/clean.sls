# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as ssh with context %}


{%- for user in ssh.users | selectattr('ssh.known_hosts', 'defined') | selectattr('ssh.known_hosts') %}

OpenSSH known_hosts file is cleaned for user '{{ user.name }}':
  file.absent:
    - name: {{ user['_ssh'].confdir | path_join('known_hosts') }}
{%- endfor %}
