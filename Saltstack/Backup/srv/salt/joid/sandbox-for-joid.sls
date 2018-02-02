Attach Admin/Management NIC to joid:
  cmd.run:
    - name: virsh attach-interface joid bridge br_em49

Attach External NIC to joid:
  cmd.run:
    - name: virsh attach-interface joid bridge br_ens1f1

