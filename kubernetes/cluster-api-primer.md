# Cluster API Primer

## What Is It?

**Cluster API (CAPI)** = Kubernetes-native way to manage Kubernetes clusters using Kubernetes itself.

*"Use Kubernetes to manage Kubernetes"*

## Core Concept

Instead of running Ansible playbooks, you create **Kubernetes resources** to declare clusters:

```yaml
apiVersion: cluster.x-k8s.io/v1beta1
kind: Cluster
metadata:
  name: my-cluster
spec:
  controlPlaneEndpoint:
    host: 10.0.0.1
    port: 6443
---
apiVersion: controlplane.cluster.x-k8s.io/v1beta1
kind: KubeadmControlPlane
metadata:
  name: my-cluster-control-plane
spec:
  replicas: 3
  version: v1.28.0
---
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachineDeployment
metadata:
  name: my-cluster-workers
spec:
  replicas: 5
  template:
    spec:
      version: v1.28.0
```

Apply it: `kubectl apply -f cluster.yaml`

CAPI controllers handle the rest: provision VMs, install K8s, join nodes.

## Architecture

```
┌─────────────────────────────────┐
│   Management Cluster            │  ← Runs CAPI controllers
│   (existing K8s cluster)        │
│                                 │
│  - Cluster API controllers      │
│  - Infrastructure providers     │
│  - Bootstrap providers          │
└─────────────────────────────────┘
         ↓ manages
┌─────────────────────────────────┐
│   Workload Cluster 1            │  ← Your actual K8s cluster
│   (3 masters + 5 workers)       │
└─────────────────────────────────┘
         ↓ manages
┌─────────────────────────────────┐
│   Workload Cluster 2            │
│   (3 masters + 10 workers)      │
└─────────────────────────────────┘
```

## Key Components

| Component | Purpose |
|-----------|---------|
| **Management Cluster** | Existing K8s that runs CAPI |
| **Infrastructure Provider** | AWS, Azure, vSphere, bare-metal, etc. |
| **Bootstrap Provider** | How to init nodes (usually kubeadm) |
| **Control Plane Provider** | How to manage control plane |

## Workflow

```bash
# 1. Install CAPI on management cluster
clusterctl init --infrastructure aws

# 2. Generate cluster manifest
clusterctl generate cluster my-cluster > cluster.yaml

# 3. Create cluster
kubectl apply -f cluster.yaml

# 4. Watch it provision
kubectl get clusters
kubectl get machines

# 5. Get kubeconfig for new cluster
clusterctl get kubeconfig my-cluster > my-cluster.kubeconfig

# 6. Use the new cluster
kubectl --kubeconfig my-cluster.kubeconfig get nodes
```

## Infrastructure Providers

- **CAPA** - AWS
- **CAPZ** - Azure  
- **CAPG** - GCP
- **CAPV** - vSphere
- **Metal3** - Bare-metal
- **Tinkerbell** - Bare-metal (modern)

## Cluster API vs Kubespray

| | Kubespray | Cluster API |
|---|-----------|-------------|
| **Approach** | Ansible playbooks | K8s resources (CRDs) |
| **Management** | Run from laptop/CI | K8s manages K8s |
| **Learning curve** | Easier | Steeper |
| **Day 2 ops** | Manual re-run | Declarative (GitOps) |
| **Scaling** | Run playbook again | Update replicas in yaml |
| **Multi-cluster** | Separate inventories | Single pane of glass |

## When to Use Cluster API

✅ **Use CAPI when:**
- Managing many clusters (10+)
- Need self-service cluster provisioning
- Want GitOps for cluster lifecycle
- Have K8s expertise on team

❌ **Use Kubespray when:**
- One-time cluster setup
- Team knows Ansible well
- Simple requirements
- Getting started with K8s

## Example: Scale Workers

**Kubespray:**
```bash
vim inventory/hosts.ini  # Add new nodes
ansible-playbook -i inventory scale.yml
```

**Cluster API:**
```bash
kubectl patch machinedeployment my-cluster-workers -p '{"spec":{"replicas":10}}'
# CAPI provisions new VMs and joins them automatically
```

## Day 2 Operations

Cluster API handles:
- **Scaling** - Change replica count
- **Upgrades** - Rolling K8s version updates
- **Self-healing** - Replace failed nodes automatically
- **Lifecycle** - Create, scale, upgrade, delete clusters

All via `kubectl` or GitOps tools (Flux, ArgoCD).

## Together AI Use Case

For 1000+ servers across 6 DCs:

**Cluster API Benefits:**
- Manage multiple clusters from central management cluster
- Declarative cluster definitions (version controlled)
- Automated node replacement
- Consistent across bare-metal + cloud

**Would likely use:**
- Metal3 or Tinkerbell provider for bare-metal
- CAPA for AWS workloads
- Single management cluster managing all

## TL;DR

**Cluster API** = Kubernetes resources (YAML) to manage Kubernetes clusters.

- You define clusters as K8s objects
- Controllers provision infrastructure and install K8s
- Great for managing many clusters at scale
- Steeper learning curve than Kubespray
- Production-grade, used by large orgs

