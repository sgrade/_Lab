Configure etc-hosts:
  host.present:
    - ip: 127.0.0.1
    - names:
      - {{ grains.id }}

Attach NICs:
  virt.nic:
    - all:
      eth0:
        bridge: br_eno49
      eth1:
        bridge: br_ens1f1    

Install bridge-utils:
  pkg.installed:
    - pkgs:
      - bridge-utils

