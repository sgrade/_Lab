# Kubernetes Autoscaling

## Three Types

| Type | What it scales | When to use |
|------|----------------|-------------|
| **HPA** | Pod replicas | Stateless apps, most common |
| **VPA** | Pod resources (CPU/memory) | Right-sizing, stateful apps |
| **Cluster Autoscaler / Karpenter** | Nodes | When pods can't schedule |

## HPA (Horizontal Pod Autoscaler)

**Scales pod count based on metrics.**

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: api-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api-server
  minReplicas: 3
  maxReplicas: 50
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

**Custom metrics (e.g., queue depth, latency):**
```yaml
metrics:
- type: External
  external:
    metric:
      name: request_latency_p99
    target:
      type: Value
      value: 200m  # 200ms
```

**Key points:**
- Needs metrics-server installed
- Scale up: fast (~15s)
- Scale down: slow (5min default, configurable)

## VPA (Vertical Pod Autoscaler)

**Adjusts CPU/memory requests automatically.**

```yaml
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: api-vpa
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api-server
  updatePolicy:
    updateMode: "Auto"  # Off, Initial, Auto
```

**Modes:**
- `Off` - Recommendations only
- `Initial` - Set on pod creation only
- `Auto` - Evict and recreate pods with new resources

**⚠️ Limitation:** Restarts pods to apply changes. Don't use with HPA on same metric.

## Cluster Autoscaler vs Karpenter

| | Cluster Autoscaler | Karpenter |
|--|-------------------|-----------|
| **Approach** | Scale node groups | Provision individual nodes |
| **Speed** | Minutes | ~60 seconds |
| **Flexibility** | Pre-defined node groups | Any instance type |
| **GPU support** | Via node groups | Native, fast |
| **Cloud support** | All clouds | AWS (GCP coming) |

### Cluster Autoscaler

```yaml
# Scales existing node groups up/down
# Needs node groups pre-configured

# Trigger: Pending pods that can't schedule
# Action: Add nodes to matching node group
```

### Karpenter (Recommended for GPU)

```yaml
apiVersion: karpenter.sh/v1beta1
kind: NodePool
metadata:
  name: gpu-pool
spec:
  template:
    spec:
      requirements:
      - key: node.kubernetes.io/instance-type
        operator: In
        values: ["p4d.24xlarge", "p5.48xlarge"]
      - key: karpenter.sh/capacity-type
        operator: In
        values: ["on-demand"]
  limits:
    cpu: 1000
    memory: 2000Gi
```

**Why Karpenter for AI:**
- Faster provisioning (60s vs minutes)
- Picks optimal instance type per pod
- Better bin-packing
- Native GPU support

## Scaling Flow (AI Workload)

```
Traffic ↑
    │
    ▼
HPA: Scale pods 10 → 20
    │
    ▼
Pending pods (no GPU capacity)
    │
    ▼
Karpenter: Provision H100 nodes
    │
    ▼
Pods schedule, latency ↓
    │
    ▼
Traffic ↓
    │
    ▼
HPA: Scale pods 20 → 10
    │
    ▼
Karpenter: Consolidate, remove empty nodes
```

## Quick Reference

```bash
# Check HPA status
kubectl get hpa
kubectl describe hpa api-hpa

# Check VPA recommendations
kubectl describe vpa api-vpa

# Check pending pods (autoscaler trigger)
kubectl get pods --field-selector=status.phase=Pending

# Karpenter logs
kubectl logs -n karpenter -l app.kubernetes.io/name=karpenter
```

## What Needs Installation?

| Component | Native? | Managed K8s (EKS/GKE) | Bare-Metal |
|-----------|---------|----------------------|------------|
| **HPA** | ✅ Yes | ✅ Ready | ✅ Ready |
| **metrics-server** | ❌ | ✅ Pre-installed | ⚠️ Install |
| **VPA** | ❌ | ⚠️ Install (GKE: one-click) | ⚠️ Install |
| **Karpenter** | ❌ | ⚠️ Install | ❌ AWS only |
| **Cluster Autoscaler** | ❌ | ⚠️ Install | ❌ Cloud only |

**Bare-metal node scaling:** Manual or custom operator (no Karpenter/Cluster Autoscaler).

## Interview Points

> "HPA for pod scaling, Karpenter for node scaling. Together they handle traffic spikes end-to-end."

> "For GPU workloads, Karpenter is better than Cluster Autoscaler - faster provisioning, picks optimal instance type automatically."

> "HPA can scale on custom metrics like latency or queue depth, not just CPU. More intelligent for AI inference."

