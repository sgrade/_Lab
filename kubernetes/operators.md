# Kubernetes Operators

## Operators in the Architecture

```
┌─────────────────────────────────────────────────────┐
│                 Kubernetes Cluster                  │
│                                                     │
│  ┌─────────────────┐    ┌─────────────────┐        │
│  │ MODEL OPERATOR  │    │ GPU OPERATOR    │        │
│  │ - Deployments   │    │ - NVIDIA drivers│        │
│  │ - Autoscaling   │    │ - DCGM metrics  │        │
│  │ - Canary        │    │ - Health checks │        │
│  └────────┬────────┘    └────────┬────────┘        │
│           │                      │                  │
│           └──────────┬───────────┘                  │
│                      ▼                              │
│           ┌─────────────────────┐                  │
│           │ PROMETHEUS OPERATOR │                  │
│           │ - Auto-discovery    │                  │
│           │ - Alertmanager      │                  │
│           └─────────────────────┘                  │
└─────────────────────────────────────────────────────┘
```

## Key Operators

### 1. Prometheus Operator (Monitoring/Observability)

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: llama-inference
spec:
  selector:
    matchLabels:
      app: llama-service
  endpoints:
  - port: metrics
```

**Does:** Auto-discovers services, configures scraping, manages alerts.

### 2. GPU Operator (Observability/Scalability)

NVIDIA GPU Operator (off-the-shelf) handles:
- Driver installation/updates
- Device plugin (`nvidia.com/gpu` resource)
- DCGM exporter (GPU metrics → Prometheus)

### 3. Model Operator (Scalability) - Custom

```yaml
apiVersion: inference.togetherai.com/v1
kind: Model
metadata:
  name: llama-3-70b
spec:
  replicas: 10
  gpuType: h100
  gpuCount: 4
  autoscaling:
    targetLatencyMs: 200
  canary:
    percentage: 10
```

**Does:** Creates Deployment/Service/HPA/PDB, scales on latency, manages canary.

## Scalability Flow

```
Traffic ↑ → Latency > 200ms → Model Operator scales replicas →
No GPU capacity? → Karpenter adds nodes → Pods schedule → Latency ↓
```

## Why Operators?

| | Scripts/Ansible | Operators |
|--|-----------------|-----------|
| Continuous reconciliation | ❌ | ✅ |
| Self-healing | ❌ | ✅ |
| K8s native (declarative) | ❌ | ✅ |

## Interview Points

> "For **monitoring**, Prometheus Operator auto-discovers scrape targets when new services deploy."

> "For **observability**, GPU Operator deploys DCGM exporter - GPU metrics out of the box."

> "For **scalability**, a Model Operator can scale based on **latency**, not just CPU. More intelligent than vanilla HPA."

> "Operators fit Together AI because: continuous reconciliation for drift, K8s-native, team knows Go."

## Available Open Source Operators

### Must-Have ⭐

| Operator | Use Case | Link |
|----------|----------|------|
| **Prometheus Operator** | Monitoring, alerting | [github.com/prometheus-operator/prometheus-operator](https://github.com/prometheus-operator/prometheus-operator) |
| **NVIDIA GPU Operator** | GPU drivers, DCGM metrics | [github.com/NVIDIA/gpu-operator](https://github.com/NVIDIA/gpu-operator) |
| **Cert-Manager** | TLS certificates | [github.com/cert-manager/cert-manager](https://github.com/cert-manager/cert-manager) |

### Recommended

| Operator | Use Case | Link |
|----------|----------|------|
| **KServe** | Model inference serving | [github.com/kserve/kserve](https://github.com/kserve/kserve) |
| **Karpenter** | Node autoscaling | [github.com/aws/karpenter](https://github.com/aws/karpenter) |
| **External Secrets** | Secrets from Vault/AWS | [github.com/external-secrets/external-secrets](https://github.com/external-secrets/external-secrets) |
| **Grafana Operator** | Grafana, dashboards | [github.com/grafana/grafana-operator](https://github.com/grafana/grafana-operator) |

### Bare-Metal Specific

| Operator | Use Case | Link |
|----------|----------|------|
| **Metal3** | Bare-metal provisioning | [github.com/metal3-io/baremetal-operator](https://github.com/metal3-io/baremetal-operator) |
| **Tinkerbell Rufio** | BMC management | [github.com/tinkerbell/rufio](https://github.com/tinkerbell/rufio) |

**Together AI likely:** Off-the-shelf for must-haves. Custom-built (Go) for model deployment and multi-vendor provisioning.
