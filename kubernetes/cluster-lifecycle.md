# Kubernetes Cluster Lifecycle

## Lifecycle Stages

```
Planning → Provisioning → Configuration → Operations → Maintenance → Decommission
```

## 1. Planning

**Decisions to make:**

| Area | Considerations |
|------|----------------|
| Platform | Managed (EKS/GKE/AKS) vs self-managed vs bare-metal |
| Sizing | Node types, count, autoscaling limits |
| Networking | CNI plugin (Calico, Cilium), IP ranges, service mesh |
| Storage | CSI drivers, StorageClasses, backup strategy |
| Security | RBAC, PSP/PSA, network policies, secrets management |
| Observability | Monitoring stack, logging, tracing |

**Outputs:**
- Architecture diagram
- Capacity plan
- Cost estimate
- Disaster recovery plan

## 2. Provisioning

**Infrastructure creation:**

```bash
# Managed K8s (EKS example)
terraform init
terraform plan
terraform apply  # Creates VPC, control plane, node groups

# Bare-metal (Kubespray)
ansible-playbook -i inventory/mycluster/hosts.yaml cluster.yml
```

**Why Kubespray:**
- Ansible-based, production-ready K8s installer for bare-metal/VMs
- Supports multi-master HA setups
- Handles etcd clustering, CNI plugins, certificate management
- Vendor-agnostic (works on any Linux: RHEL, Ubuntu, CentOS)
- Idempotent, can upgrade/scale existing clusters
- Alternative to kubeadm manual steps or Rancher

**When to use:**
- On-prem datacenters (no cloud provider)
- Custom hardware (GPU servers, ARM nodes)
- Air-gapped environments
- Need full control over K8s config

**What gets created:**
- Control plane (managed or self-hosted)
- Worker node groups (with taints, labels, instance types)
- VPC/networking
- IAM roles, security groups
- Load balancers

**Validation:**
```bash
kubectl cluster-info
kubectl get nodes
kubectl get pods -n kube-system
```

## 3. Configuration

**Post-provisioning setup:**

```bash
# Core add-ons
helm install ingress-nginx ingress-nginx/ingress-nginx
helm install cert-manager jetstack/cert-manager

# Observability
helm install prometheus prometheus-community/kube-prometheus-stack
helm install loki grafana/loki-stack

# GitOps
kubectl apply -f argocd-install.yaml

# Storage
kubectl apply -f ebs-csi-driver.yaml

# Security
kubectl apply -f policy-engine.yaml  # OPA/Kyverno
```

**Configure:**
- RBAC policies
- Resource quotas per namespace
- Network policies
- PodSecurityStandards
- Monitoring dashboards
- Alerting rules

## 4. Operations (Day 2)

**Daily/ongoing activities:**

| Activity | Tools | Frequency |
|----------|-------|-----------|
| Deploy apps | ArgoCD, Helm | Continuous |
| Monitor health | Prometheus, Grafana | Real-time |
| Scale workloads | HPA, VPA, Cluster Autoscaler | Automatic |
| Incident response | kubectl, logs | As needed |
| Cost optimization | Kubecost, right-sizing | Weekly |
| Security scanning | Trivy, Falco | Continuous |

**Key metrics to watch:**
- Node utilization (CPU, memory, disk)
- Pod health and restarts
- API server latency
- etcd performance
- Network throughput

## 5. Maintenance

### 5.1 Cluster Upgrades

**Kubernetes version updates:**

```bash
# Managed (EKS)
aws eks update-cluster-version --name prod --kubernetes-version 1.28

# Self-managed (Kubespray)
ansible-playbook -i inventory/mycluster/hosts.yaml upgrade-cluster.yml
```

**Process:**
1. Review changelog, deprecations
2. Update dev/staging first
3. Drain nodes one by one
4. Upgrade control plane
5. Upgrade node groups (rolling)
6. Validate workloads

**Frequency:** Every 3-6 months (stay within support window)

### 5.2 Node Maintenance

**OS patches, driver updates:**

```bash
# Cordon node (prevent new pods)
kubectl cordon node1

# Drain node (evict pods gracefully)
kubectl drain node1 --ignore-daemonsets --delete-emptydir-data

# Perform maintenance (SSH to node, update packages)
ssh node1 "apt update && apt upgrade -y && reboot"

# Uncordon when ready
kubectl uncordon node1
```

**Automation:** Kured (automatic node reboots after patches)

### 5.3 Certificate Rotation

```bash
# Check cert expiry
kubeadm certs check-expiration

# Renew certs
kubeadm certs renew all
```

**Managed K8s:** Automatic, but verify.

### 5.4 etcd Backup

```bash
# Backup
ETCDCTL_API=3 etcdctl snapshot save backup.db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key

# Restore (disaster recovery)
ETCDCTL_API=3 etcdctl snapshot restore backup.db
```

**Frequency:** Daily automated backups.

## 6. Scaling

### 6.1 Horizontal (add nodes)

```bash
# Managed
aws eks update-nodegroup-config --cluster-name prod \
  --nodegroup-name workers --scaling-config desiredSize=20

# Terraform
# Update desired_size in node_group resource, apply
```

### 6.2 Vertical (bigger nodes)

- Create new node group with larger instance type
- Migrate workloads via taints/drains
- Delete old node group

### 6.3 New Node Groups

- For new hardware types (new GPU models)
- For different AZs
- For specialized workloads

## 7. Decommissioning

**Graceful cluster shutdown:**

```bash
# 1. Stop new deployments
kubectl scale deployment --all --replicas=0 -n production

# 2. Drain all nodes
kubectl drain --all --ignore-daemonsets --delete-emptydir-data

# 3. Backup etcd one final time
etcdctl snapshot save final-backup.db

# 4. Export critical resources
kubectl get all --all-namespaces -o yaml > cluster-export.yaml

# 5. Destroy infrastructure
terraform destroy
```

**Before destroying:**
- Migrate data from PersistentVolumes
- Export configs, secrets (securely)
- Update DNS/load balancers
- Archive logs, metrics
- Document lessons learned

## Key Files to Maintain

```
k8s-infrastructure/
├── terraform/
│   ├── main.tf              # Cluster provisioning
│   ├── variables.tf
│   └── terraform.tfstate    # BACKUP THIS
├── config/
│   ├── kubeconfig           # Access credentials
│   └── rbac/                # RBAC policies
├── backups/
│   ├── etcd-snapshots/      # Daily backups
│   └── manifests/           # Resource exports
├── runbooks/
│   ├── upgrade-procedure.md
│   ├── disaster-recovery.md
│   └── incident-response.md
└── inventory/               # For bare-metal
    └── hosts.yaml
```

## Best Practices

- **Version everything:** Cluster version, addons, workloads
- **Test upgrades:** Dev → Staging → Prod
- **Automate backups:** etcd snapshots, PV snapshots
- **Monitor capacity:** Set alerts before hitting limits
- **Plan for DR:** Multi-cluster, cross-region strategies
- **Document changes:** Change log, who/what/when/why
- **Regular audits:** Security, cost, resource usage

