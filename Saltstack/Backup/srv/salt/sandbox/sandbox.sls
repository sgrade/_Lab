Configure etc/hosts:
  host.present:
    - ip: 127.0.0.1
    - names:
      - {{ grains.id }}

Install Ubuntu virtualization packages:
  pkg.installed:
    - pkgs:
      - qemu-kvm
      - libvirt-bin
      - bridge-utils

Set up libvirt pki as Salt Virt recommends:
  pkg.installed:
    - pkgs:
      - python-libvirt
  virt.keys:
    - require:
      - Install Ubuntu virtualization packages

Set up libguestfs as Salt Virt recommends:
  pkg.installed:
    - pkgs:
      - libguestfs-tools

# maas uses internal (maas) account when creates virsh pod
Set ssh public key for maas account on maas server:
  ssh_auth.present:
    - user: ubuntu
    - source: salt://sandbox/files/maas.id_rsa.pub
    - config: '%h/.ssh/authorized_keys'

Change network config:
  file.managed:
    - name: /etc/network/interfaces
    - source: salt://sandbox/files/interfaces_{{ grains.id }}
    - user: root
    - group: root
    - mode: '644'
    - require:
      - Install Ubuntu virtualization packages

# libvirt network for maas
Copy maas network config to minion:
  file.managed:
    - name: /srv/salt/maas.xml
    - source: salt://sandbox/files/maas_xml
    - makedirs: True
    - user: root
    - group: root
    - mode: '644'

Create maas network:
  cmd.run:
    - name: virsh net-define /srv/salt/maas.xml
    - require:
      - Copy maas network config to minion
      - Change network config

Configure maas network to autostart:
  cmd.run:
    - name: virsh net-autostart maas
    - require:
      - Create maas network

Start maas network:
  cmd.run:
    - name: virsh net-start maas
    - require:
      - Create maas network

# To overcome maas bug https://bugs.launchpad.net/maas/+bug/1696122
# Create default libvirt storage
# Note: the approach below (recommended in the link above) does not work as pool created, but not defined (will disappear after reboot)
#  cmd.run:
#    - name: virsh pool-create-as default dir --target /var/lib/libvirt/images
# Thus I define it properly

Create directory for default pool:
  file.directory:
    - name: /home/ubuntu/images
    - user: ubuntu
    - group: users
    - mode: '711'
    - require:
      - Install Ubuntu virtualization packages

Copy default pool config to minion:
  file.managed:
    - name: /srv/salt/pool-default.xml
    - source: salt://sandbox/files/pool-default_xml
    - makedirs: True
    - user: root
    - group: root
    - mode: '644'

Create default libvirt storage:
  cmd.run:
    - name: virsh pool-define /srv/salt/pool-default.xml

Configure default pool to autostart:
  cmd.run:
    - name: virsh pool-autostart default
    - require:
      - Create default libvirt storage

Start default pool:
  cmd.run:
    - name: virsh pool-start default
    - require:
      - Create default libvirt storage

Reboot the system:
  cmd.run:
    - name: '/etc/init.d/networking restart'
    - onchanges:
      - Change network config
