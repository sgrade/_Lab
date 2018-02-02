Configure etc-hosts:
  host.present:
    - ip: 127.0.0.1
    - names:
      - {{ grains.id }}

Install bridge-utils:
  pkg.installed:
    - pkgs:
      - bridge-utils

