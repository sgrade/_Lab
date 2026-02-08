# Kubernetes Interview Q&A

## 1. What happens when you run `kubectl apply -f deployment.yaml`?

1. kubectl sends manifest to **API Server**
2. API Server validates & stores in **etcd**
3. **Scheduler** assigns pods to nodes
4. **Kubelet** on each node pulls image & starts containers
5. **Controller Manager** ensures desired state matches actual state

## 2. How do you debug a pod stuck in `Pending` state?

```bash
kubectl describe pod <pod-name>
```

**Common causes:**
- **Insufficient resources** - Node doesn't have enough CPU/memory
- **Node selector/affinity** - No matching nodes
- **Taints** - Pod missing required tolerations
- **PVC** (Persistent Volume Claim) - Persistent volume not bound

## 3. What's the difference between a Deployment and a StatefulSet?

| | Deployment | StatefulSet |
|--|------------|-------------|
| Pod identity | Random names | Stable names (app-0, app-1) |
| Scaling | Parallel | Sequential (ordered) |
| Storage | Shared/ephemeral | Per-pod persistent volumes |
| Use case | Stateless apps | Databases, Kafka, etcd |

## 4. How does a Service route traffic to pods?

1. Service has a **selector** matching pod labels
2. **kube-proxy** watches Services & Endpoints
3. Creates **iptables/IPVS rules** on each node
4. Traffic to Service IP → load balanced to pod IPs

**Service types:**
- `ClusterIP` - Internal only
- `NodePort` - External via node ports
- `LoadBalancer` - Cloud LB provisioned

## 5. How would you perform a zero-downtime deployment?

**Strategy:** Rolling update (default)

```yaml
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1        # Extra pods during update
      maxUnavailable: 0  # Always keep all pods running
```

**Requirements:**
- **Readiness probe** - Don't route until ready
- **PodDisruptionBudget** - Guarantee minimum available
- **Graceful shutdown** - Handle SIGTERM, drain connections

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: app-pdb
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: myapp
```

