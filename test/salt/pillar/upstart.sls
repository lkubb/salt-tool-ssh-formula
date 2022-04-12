# -*- coding: utf-8 -*-
# vim: ft=yaml
---
tool_global:
  users:
    user:
      completions: .completions
      configsync: true
      persistenv: .bash_profile
      rchook: .bashrc
      xdg: true
      ssh:
        config:
          Hosts:
            '*':
              AddressFamily: inet
              ChallengeResponseAuthentication: 'no'
              Ciphers:
                - chacha20-poly1305@openssh.com
                - aes256-gcm@openssh.com
              ForwardAgent: 'no'
              ForwardX11: 'no'
              ForwardX11Trusted: 'no'
              HashKnownHosts: 'yes'
              HostKeyAlgorithms:
                - ssh-ed25519-cert-v01@openssh.com
                - ssh-rsa-cert-v01@openssh.com
                - ssh-ed25519,ssh-rsa
              KexAlgorithms:
                - curve25519-sha256@libssh.org
                - diffie-hellman-group-exchange-sha256
              MACs:
                - hmac-sha2-512-etm@openssh.com
                - hmac-sha2-256-etm@openssh.com
              PasswordAuthentication: 'no'
              ServerAliveCountMax: 2
              ServerAliveInterval: 300
              StrictHostKeyChecking: ask
              VerifyHostKeyDNS: 'yes'
              VisualHostKey: 'yes'
            mygit:
              ControlMaster: auto
              ControlPath: ~/.ssh/master-%r@%h:%p
              ControlPersist: 300
              HostName: mygit.example.com
              User: test
        known_hosts:
          aliases:
            - alias.example.org
          hostnames: false
          omit_ip_address:
            - github.com
          static:
            github.com: ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGm[...]
            gitlab.com: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bN[...]
tool_ssh:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value

    pkg:
      name: openssh
    paths:
      confdir: '.ssh'
      conffile: 'config'

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   tool-ssh-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      OpenSSH config file is managed for user 'user':
        - 'config'
        - 'config.jinja'

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
