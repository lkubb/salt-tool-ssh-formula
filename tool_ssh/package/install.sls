# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as ssh with context %}


OpenSSH is installed:
  pkg.installed:
    - name: {{ ssh.lookup.pkg.name }}
    - version: {{ ssh.get("version") or "latest" }}
    {#- do not specify alternative return value to be able to unset default version #}

OpenSSH setup is completed:
  test.nop:
    - name: Hooray, OpenSSH setup has finished.
    - require:
      - pkg: {{ ssh.lookup.pkg.name }}
