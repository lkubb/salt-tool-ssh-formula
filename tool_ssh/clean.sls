# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``tool_ssh`` meta-state
    in reverse order.
#}

include:
  - .config.clean
  - .known_hosts.clean
  - .package.clean
