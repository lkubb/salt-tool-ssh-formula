# vim: ft=sls

{#-
    Manages the OpenSSH package configuration by

    * recursively syncing from a dotfiles repo
    * managing/serializing the config file afterwards

    Has a dependency on `tool_ssh.package`_.
#}

include:
  - .sync
  - .file
