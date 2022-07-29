# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as ssh with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch %}

include:
  - {{ sls_package_install }}


{%- for user in ssh.users | selectattr('ssh.known_hosts', 'defined') | selectattr('ssh.known_hosts') %}

OpenSSH known_hosts file is managed for user '{{ user.name }}':
  file.managed:
    - name: {{ user['_ssh'].confdir | path_join('known_hosts') }}
    - source: {{ files_switch(['known_hosts'],
                              lookup='OpenSSH known_hosts file is managed for user \'{{ user.name }}\'',
                              opt_prefixes=[user.name])
              }}
    - mode: '0600'
    - user: {{ user.name }}
    - group: {{ user.group }}
    - makedirs: true
    - dir_mode: '0700'
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        known_hosts: {{ user.ssh.known_hosts | json }}
{%- endfor %}
