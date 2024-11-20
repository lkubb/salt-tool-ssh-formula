# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as ssh with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch %}


{%- for user in ssh.users | selectattr("dotconfig", "defined") | selectattr("dotconfig") %}
{%-   set dotconfig = user.dotconfig if user.dotconfig is mapping else {} %}

OpenSSH configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user["_ssh"].confdir }}
    - source: {{ files_switch(
                    ["ssh"],
                    lookup="OpenSSH configuration is synced for user '{}'".format(user.name),
                    config=ssh,
                    path_prefix="dotconfig",
                    files_dir="",
                    custom_data={"users": [user.name]},
                 )
              }}
    - context:
        user: {{ user | json }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
    - file_mode: '0600'
    - dir_mode: '{{ dotconfig.get("dir_mode", "0700") }}'
    - clean: {{ dotconfig.get("clean", false) | to_bool }}
    - makedirs: true
{%- endfor %}
