.. _readme:

OpenSSH Formula
===============

Manages OpenSSH **client** in the user environment.

.. contents:: **Table of Contents**
   :depth: 1

Usage
-----
Applying ``tool_ssh`` will make sure ``ssh`` is configured as specified.

Configuration
-------------

This formula
~~~~~~~~~~~~
The general configuration structure is in line with all other formulae from the `tool` suite, for details see :ref:`toolsuite`. An example pillar is provided, see :ref:`pillar.example`. Note that you do not need to specify everything by pillar. Often, it's much easier and less resource-heavy to use the ``parameters/<grain>/<value>.yaml`` files for non-sensitive settings. The underlying logic is explained in :ref:`map.jinja`.

User-specific
^^^^^^^^^^^^^
The following shows an example of ``tool_ssh`` per-user configuration. If provided by pillar, namespace it to ``tool_global:users`` and/or ``tool_ssh:users``. For the ``parameters`` YAML file variant, it needs to be nested under a ``values`` parent key. The YAML files are expected to be found in

1. ``salt://tool_ssh/parameters/<grain>/<value>.yaml`` or
2. ``salt://tool_global/parameters/<grain>/<value>.yaml``.

.. code-block:: yaml

  user:

      # Sync this user's config from a dotfiles repo.
      # The available paths and their priority can be found in the
      # rendered `config/sync.sls` file (currently, @TODO docs).
      # Overview in descending priority:
      # salt://dotconfig/<minion_id>/<user>/
      # salt://dotconfig/<minion_id>/
      # salt://dotconfig/<os_family>/<user>/
      # salt://dotconfig/<os_family>/
      # salt://dotconfig/default/<user>/
      # salt://dotconfig/default/
    dotconfig:              # can be bool or mapping
      file_mode: '0600'     # default: keep destination or salt umask (new)
      dir_mode: '0700'      # default: 0700
      clean: false          # delete files in target. default: false

      # Persist environment variables used by this formula for this
      # user to this file (will be appended to a file relative to $HOME)
    persistenv: '.config/zsh/zshenv'

      # Add runcom hooks specific to this formula to this file
      # for this user (will be appended to a file relative to $HOME)
    rchook: '.config/zsh/zshrc'

      # This user's configuration for this formula. Will be overridden by
      # user-specific configuration in `tool_ssh:users`.
      # Set this to `false` to disable configuration for this user.
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
          # List of DNS entries also pointing to our known hosts and that we want
          # to inject in our generated known_hosts file
        aliases:
          - alias.example.org
          # Includes short hostnames derived from the FQDN
          # (host.example.test -> host)
          # (Deactivated by default, because there can be collisions!)
          # hostnames:
          # Restrict which hosts you want to use via their hostname
          # (i.e. ssh user@host instead of ssh user@host.example.com)
          #  target: '*'  # Defaults to "*.{{ grains['domain']}}"
          #  tgt_type: 'glob'
          # To activate the defaults you can just set an empty dict.
          # hostnames: {}
        hostnames: false
          # Prevent an ever-changing ssh_known_hosts file caused by a domain which
          # is served from multiple IP addresses.
          # To disable completely:
          # omit_ip_address: true
          # Or to disable by specific hosts:
        omit_ip_address:
          - github.com
          # Here you can list keys for hosts which are not among your minions:
        static:
          github.com: ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGm[...]
          gitlab.com: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bN[...]

Formula-specific
^^^^^^^^^^^^^^^^

.. code-block:: yaml

  tool_ssh:

      # Specify an explicit version (works on most Linux distributions) or
      # keep the packages updated to their latest version on subsequent runs
      # by leaving version empty or setting it to 'latest'
      # (again for Linux, brew does that anyways).
    version: latest

      # Default formula configuration for all users.
    defaults:
      config: default value for all users

Config file serialization
~~~~~~~~~~~~~~~~~~~~~~~~~
This formula serializes configuration into a config file. A default one is provided with the formula, but can be overridden via the TOFS pattern. See :ref:`tofs_pattern` for details.

Dotfiles
~~~~~~~~
``tool_ssh.config.sync`` will recursively apply templates from

* ``salt://dotconfig/<minion_id>/<user>/``
* ``salt://dotconfig/<minion_id>/``
* ``salt://dotconfig/<os_family>/<user>/``
* ``salt://dotconfig/<os_family>/``
* ``salt://dotconfig/default/<user>/``
* ``salt://dotconfig/default/``

to the user's config dir for every user that has it enabled (see ``user.dotconfig``). The target folder will not be cleaned by default (ie files in the target that are absent from the user's dotconfig will stay).

The URL list above is in descending priority. This means user-specific configuration from wider scopes will be overridden by more system-specific general configuration.

Development
-----------

Contributing to this repo
~~~~~~~~~~~~~~~~~~~~~~~~~

Commit messages
^^^^^^^^^^^^^^^

Commit message formatting is significant.

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``.

.. code-block:: console

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

State documentation
~~~~~~~~~~~~~~~~~~~
There is a script that semi-autodocuments available states: ``bin/slsdoc``.

If a ``.sls`` file begins with a Jinja comment, it will dump that into the docs. It can be configured differently depending on the formula. See the script source code for details currently.

This means if you feel a state should be documented, make sure to write a comment explaining it.

Testing
~~~~~~~

Linux testing is done with ``kitchen-salt``.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

  $ gem install bundler
  $ bundle install
  $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,
e.g. ``debian-9-2019-2-py3``.

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the ``tool_ssh`` main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.
