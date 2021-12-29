# `ssh` Formula
Sets up, configures and updates `openssh` client.

## Usage
Applying `tool-ssh` will make sure openssh is available and configured as specified.

## Configuration
### Pillar
#### General `tool` architecture
Note: Sadly this formula inherits all the disadvantages of the `tool` architecture without most of its benefits.
Since installing user environments is not the primary use case for saltstack, the architecture is currently a bit awkward. All `tool` formulas assume running as root. There are three scopes of configuration:
1. per-user `tool`-specific
  > e.g. generally force usage of XDG dirs in `tool` formulas for this user
2. per-user formula-specific
  > e.g. setup this tool with the following configuration values for this user
3. global formula-specific (All formulas will accept `defaults` for `users:username:formula` default values in this scope as well.)
  > e.g. setup system-wide configuration files like this

**3** goes into `tool:formula` (e.g. `tool:git`). Both user scopes (**1**+**2**) are mixed per user in `users`. `users` can be defined in `tool:users` and/or `tool:formula:users`, the latter taking precedence. (**1**) is namespaced directly under `username`, (**2**) is namespaced under `username: {formula: {}}`.

```yaml
tool:
######### user-scope 1+2 #########
  users:                         #
    username:                    #
      xdg: true                  #
      dotconfig: true            #
      formula:                   #
        config: value            #
####### user-scope 1+2 end #######
  formula:
    formulaspecificstuff:
      conf: val
    defaults:
      yetanotherconfig: somevalue
######### user-scope 1+2 #########
    users:                       #
      username:                  #
        xdg: false               #
        formula:                 #
          otherconfig: otherval  #
####### user-scope 1+2 end #######
```


#### User-specific
The following shows an example of `tool-zsh` pillar configuration. Namespace it to `tool:users` and/or `tool:zsh:users`.
```yaml
username:
  ssh:
    config: # .ssh/config file
      Hosts:
        '*':
          AddressFamily: inet
          HashKnownHosts: yes
          VisualHostKey: yes
          PasswordAuthentication: no
          ChallengeResponseAuthentication: no
          StrictHostKeyChecking: ask
          VerifyHostKeyDNS: yes
          ForwardAgent: no
          ForwardX11: no
          ForwardX11Trusted: no
          ServerAliveInterval: 300
          ServerAliveCountMax: 2
          Ciphers:
            - chacha20-poly1305@openssh.com
            - aes256-gcm@openssh.com
          MACs:
            - hmac-sha2-512-etm@openssh.com
            - hmac-sha2-256-etm@openssh.com
          KexAlgorithms:
            - curve25519-sha256@libssh.org
            - diffie-hellman-group-exchange-sha256
          HostKeyAlgorithms:
            - ssh-ed25519-cert-v01@openssh.com
            - ssh-rsa-cert-v01@openssh.com
            - ssh-ed25519,ssh-rsa
        mygit:
          HostName: mygit.example.com
          User: test
          ControlMaster: auto
          ControlPath: "~/.ssh/master-%r@%h:%p"
          ControlPersist: 300
    known_hosts: # .ssh/known_hosts file
      # List of DNS entries also pointing to our known hosts and that we want
      # to inject in our generated known_hosts file
      aliases:
        - alias.example.org
      # Includes short hostnames derived from the FQDN
      # (host.example.test -> host)
      # (Deactivated by default, because there can be collisions!)
      hostnames: false
      # hostnames:
      # Restrict wich hosts you want to use via their hostname
      # (i.e. ssh user@host instead of ssh user@host.example.com)
      #  target: '*'  # Defaults to "*.{{ grains['domain']}}"
      #  tgt_type: 'glob'
      # To activate the defaults you can just set an empty dict.
      # hostnames: {}
      # Here you can list keys for hosts which are not among your minions:
      static:
        github.com: 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGm[...]'
        gitlab.com: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bN[...]'
      # Prevent an ever-changing ssh_known_hosts file caused by a domain which
      # is served from multiple IP addresses.
      # To disable completely:
      # omit_ip_address: true
      # Or to disable by specific hosts:
      omit_ip_address:
        - github.com
```


#### Formula-specific
```yaml
tool:
  ssh:
    defaults:
      config: # .ssh/config file
        Hosts:
          '*':
            ForwardX11: yes
      known_hosts: # .ssh/known_hosts file
        hostnames: true
```
