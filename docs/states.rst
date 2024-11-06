Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``tool_ssh``
~~~~~~~~~~~~
*Meta-state*.

Performs all operations described in this formula according to the specified configuration.


``tool_ssh.package``
~~~~~~~~~~~~~~~~~~~~
Installs the OpenSSH package only.


``tool_ssh.config``
~~~~~~~~~~~~~~~~~~~
Manages the OpenSSH package configuration by

* recursively syncing from a dotfiles repo
* managing/serializing the config file afterwards

Has a dependency on `tool_ssh.package`_.


``tool_ssh.config.file``
~~~~~~~~~~~~~~~~~~~~~~~~
Manages the OpenSSH package configuration.
Has a dependency on `tool_ssh.package`_.


``tool_ssh.config.sync``
~~~~~~~~~~~~~~~~~~~~~~~~



``tool_ssh.known_hosts``
~~~~~~~~~~~~~~~~~~~~~~~~



``tool_ssh.clean``
~~~~~~~~~~~~~~~~~~
*Meta-state*.

Undoes everything performed in the ``tool_ssh`` meta-state
in reverse order.


``tool_ssh.package.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes the OpenSSH package.
Has a dependency on `tool_ssh.config.clean`_.


``tool_ssh.config.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~
Removes the configuration of the OpenSSH package.


``tool_ssh.known_hosts.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



