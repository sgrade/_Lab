Attach Admin/Management NIC:
  cmd.run:
    - name: virsh attach-interface {{ grains.id }} bridge br_em49 --model virtio --persistent

Attach External NIC:
  cmd.run:
    - name: virsh attach-interface {{ grains.id }} bridge br_ens1f1 --model virtio --persistent

