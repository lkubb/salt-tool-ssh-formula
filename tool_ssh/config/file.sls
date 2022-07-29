# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as ssh with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}


{%- for user in ssh.users | selectattr('ssh.config', 'defined') | selectattr('ssh.config') %}

OpenSSH config file is managed for user '{{ user.name }}':
  file.managed:
    - name: {{ user['_ssh'].conffile }}
    - source: {{ files_switch([ssh.lookup.paths.conffile],
                              lookup="OpenSSH config file is managed for user '{}'".format(user.name),
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
        ssh_config: {{ user.ssh.config | json }} {# json is subset of yaml, tends to cause less friction #}
{%- endfor %}
