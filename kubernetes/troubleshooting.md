# Kubernetes Troubleshooting

## Pod Not Starting

```bash
# Check pod status
kubectl describe pod <name>

# Common issues in Events section:
# - ImagePullBackOff: Wrong image name/tag, registry auth
# - CrashLoopBackOff: App crashing, check logs
# - Pending: No schedulable node, resource constraints
# - ContainerCreating: Volume mount issues, init containers
```

## Debugging Flow

1. **Pod level:** `kubectl describe pod` → Events
2. **Container level:** `kubectl logs <pod>` (add `-p` for previous crash)
3. **Node level:** `kubectl describe node`, check conditions
4. **Exec into pod:** `kubectl exec -it <pod> -- sh`

## Common Issues

| Symptom | Likely Cause |
|---------|--------------|
| ImagePullBackOff | Bad image, no auth, registry down |
| CrashLoopBackOff | App error, check logs |
| OOMKilled | Memory limit exceeded |
| Evicted | Node under resource pressure |
| Pending (no nodes) | Insufficient resources, taints |

## OOMKilled vs Evicted

| | OOMKilled | Evicted |
|---|-----------|---------|
| **Who decides** | Linux kernel (cgroup) | Kubelet |
| **Trigger** | Container exceeds `limits.memory` | Node memory crosses threshold |
| **Scope** | Single container | Entire pod |
| **Termination** | Instant SIGKILL | Graceful SIGTERM |
| **Exit code** | 137 | N/A |

**How cgroups are involved:**
- Kubelet sets `memory.max` in cgroup based on pod's `limits.memory`
- Kernel OOM killer triggers when container exceeds cgroup limit → OOMKilled
- Eviction is Kubelet-level (reads `/proc/meminfo`), not cgroup-based

**QoS Classes** (determines eviction order):

| QoS Class | Condition | Eviction Priority |
|-----------|-----------|-------------------|
| BestEffort | No requests/limits | First |
| Burstable | Requests < Limits | Middle |
| Guaranteed | Requests = Limits | Last |

```bash
# Check if container was OOMKilled
kubectl get pod <name> -o jsonpath='{.status.containerStatuses[*].lastState.terminated.reason}'

# Check pod's QoS class
kubectl get pod <name> -o jsonpath='{.status.qosClass}'

# Find evicted pods
kubectl get pods --field-selector=status.phase=Failed | grep Evicted

# Check node memory pressure
kubectl describe node <name> | grep -A5 "Conditions:"

# Check eviction thresholds on node
kubectl get node <name> -o jsonpath='{.status.allocatable.memory}'

# View cgroup memory limit (on node)
cat /sys/fs/cgroup/kubepods/pod<uid>/memory.max

# View container's OOM score adjustment
cat /proc/<pid>/oom_score_adj
```

## Network Debugging

```bash
# DNS check from inside pod
kubectl exec -it <pod> -- nslookup kubernetes

# Service endpoints
kubectl get endpoints <service>

# Check if pods selected by service
kubectl get pods -l <service-selector>
```

## Resource Issues

```bash
# Node capacity
kubectl describe node | grep -A 5 "Allocated resources"

# Pod resource usage
kubectl top pod <name>

# Pending due to resources?
kubectl get events | grep FailedScheduling
```

## etcd Health (control plane)

```bash
# Check etcd cluster health
etcdctl endpoint health
etcdctl endpoint status
```


