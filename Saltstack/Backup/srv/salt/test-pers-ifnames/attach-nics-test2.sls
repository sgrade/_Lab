Attach NIC1:
  cmd.run:
    - name: virsh attach-interface test2 bridge br_eno49 --model virtio --persistent

Attach NIC2:
  cmd.run:
    - name: virsh attach-interface test2 bridge br_eno50 --model virtio --persistent

Attach NIC3:
  cmd.run:
    - name: virsh attach-interface test2 bridge br_ens1f0 --model virtio --persistent

Attach NIC4:
  cmd.run:
    - name: virsh attach-interface test2 bridge br_ens2f0 --model virtio --persistent

