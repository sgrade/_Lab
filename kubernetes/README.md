                                                                                                                                                                                                                                                                                       # Kubernetes

Core concepts for kubernetes interviews.

## Architecture

**Control Plane:**
- `kube-apiserver` - API gateway, all communication goes through it
- `etcd` - Key-value store for cluster state
- `kube-scheduler` - Assigns pods to nodes
- `kube-controller-manager` - Runs control loops (deployments, replicasets)

**Worker Nodes:**
- `kubelet` - Agent that runs pods
- `kube-proxy` - Network proxy, handles service routing
- Container runtime (containerd, CRI-O)

## Core Objects

| Object | Purpose |
|--------|---------|
| Pod | Smallest deployable unit, 1+ containers |
| Deployment | Declarative pod management, rolling updates |
| Service | Stable network endpoint for pods |
| ConfigMap | Non-sensitive configuration |
| Secret | Sensitive data (base64 encoded) |
| Namespace | Virtual cluster isolation |

## Networking

**Service Types:**
- `ClusterIP` - Internal only (default)
- `NodePort` - Exposes on each node's IP
- `LoadBalancer` - Cloud LB provisioned
- `ExternalName` - DNS CNAME alias

**CNI Plugins:** Calico, Cilium, Flannel, Weave

## Key Commands

```bash
# Cluster info
kubectl cluster-info
kubectl get nodes

# Workloads
kubectl get pods -A
kubectl describe pod <name>
kubectl logs <pod> [-c container]
kubectl exec -it <pod> -- /bin/sh

# Debugging
kubectl get events --sort-by='.lastTimestamp'
kubectl top pods
kubectl top nodes
```

## Deployment Strategies

| Strategy | Description |
|----------|-------------|
| Rolling Update | Gradual replacement (default) |
| Recreate | Kill all, then create new |
| Blue/Green | Two environments, switch traffic |
| Canary | Small % to new version first |

## At Scale (1000+ nodes)

- Use managed Kubernetes (EKS, GKE, AKS) when possible
- For bare-metal: Cluster API, Rancher, or Kubespray
- Node auto-scaling groups
- Pod disruption budgets for availability
- Resource quotas per namespace


