# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- set sls_known_hosts_clean = tplroot ~ '.known_hosts.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as ssh with context %}

include:
  - {{ sls_config_clean }}
  - {{ sls_known_hosts_clean }}

OpenSSH is removed:
  pkg.removed:
    - name: {{ ssh.lookup.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}
      - sls: {{ sls_known_hosts_clean }}
