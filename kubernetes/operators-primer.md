# Kubernetes Operators Primer

## What Is an Operator?

**Custom controller + Custom Resource Definition (CRD)** that extends Kubernetes to manage complex applications.

```
Operator = CRD (what) + Controller (how)
```

## Core Concept: Reconciliation Loop

```go
for {
    desired := getCustomResource()  // What user wants
    actual := getCurrentState()      // What exists
    if actual != desired {
        reconcile()                  // Make it so
    }
}
```

**Self-healing:** If someone deletes a resource, operator recreates it.

## Components

```
┌─────────────────────────────────────────────┐
│  Custom Resource Definition (CRD)           │
│  "Teaches K8s a new resource type"          │
│                                             │
│  apiVersion: mycompany.com/v1               │
│  kind: Database    ← New resource type      │
└─────────────────────────────────────────────┘
                    │
                    ↓ watches
┌─────────────────────────────────────────────┐
│  Controller (Operator code)                 │
│  "Knows how to manage Database resources"   │
│                                             │
│  - Creates StatefulSet                      │
│  - Creates PVC                              │
│  - Handles backups                          │
│  - Manages failover                         │
└─────────────────────────────────────────────┘
```

## Example: Database Operator

**Without operator:**
```bash
# Manual steps every time
kubectl apply -f statefulset.yaml
kubectl apply -f service.yaml
kubectl apply -f pvc.yaml
kubectl apply -f configmap.yaml
# Manual backup setup
# Manual failover handling
```

**With operator:**
```yaml
apiVersion: postgres.example.com/v1
kind: PostgresCluster
metadata:
  name: my-db
spec:
  replicas: 3
  storage: 100Gi
  backup:
    schedule: "0 2 * * *"
```

Operator handles everything else.

## How to Build

**Tools:**
- **Kubebuilder** - Official framework (Go)
- **Operator SDK** - Red Hat (Go, Ansible, Helm)
- **Kopf** - Python framework

**Basic structure (Go):**
```go
func (r *DatabaseReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
    // 1. Fetch the custom resource
    db := &v1.Database{}
    r.Get(ctx, req.NamespacedName, db)
    
    // 2. Check current state
    // 3. Create/update resources to match desired state
    // 4. Update status
    
    return ctrl.Result{}, nil
}
```

## Operator vs Other Approaches

| Approach | Reconciliation | Self-Healing | K8s Native |
|----------|----------------|--------------|------------|
| Scripts | ❌ One-time | ❌ | ❌ |
| Ansible | ❌ Push-based | ❌ | ❌ |
| Helm | ❌ Install-time | ❌ | Partial |
| **Operator** | ✅ Continuous | ✅ | ✅ |

## Common Operators

| Operator | Manages |
|----------|---------|
| Prometheus Operator | Prometheus, Alertmanager |
| Cert-Manager | TLS certificates |
| Strimzi | Kafka clusters |
| Rook | Ceph storage |
| GPU Operator | NVIDIA drivers, device plugin |

## When to Use Operators

✅ **Use when:**
- Complex lifecycle (install, upgrade, backup, failover)
- Need continuous reconciliation
- Want declarative management
- Stateful applications

❌ **Skip when:**
- Simple stateless apps (just use Deployment)
- One-time tasks
- Team lacks Go expertise

## TL;DR

- **CRD** = New resource type in K8s
- **Controller** = Code that manages that resource
- **Operator** = CRD + Controller
- **Key benefit** = Continuous reconciliation, self-healing
- **Built with** = Go (Kubebuilder/Operator SDK)

