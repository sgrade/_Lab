Configure etc-hosts:
  host.present:
    - ip: 127.0.0.1
    - names:
      - {{ grains.id }}

Attach NIC to joid:
  cmd.run:
    - name: virsh attach-interface {{ grains.id }} bridge br0

Install bridge-utils:
  pkg.installed:
    - pkgs:
      - bridge-utils

Change network config:
  file.managed:
    - name: /etc/network/interfaces
    - source: salt://joid/files/interfaces_{{ grains.id }}
    - user: root
    - group: root
    - mode: '644'
    - require:
      - Install Ubuntu virtualization packages

