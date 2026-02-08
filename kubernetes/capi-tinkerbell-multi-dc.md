# Cluster API + Tinkerbell for Multi-Datacenter Architecture

## Scenario
6 datacenters, 1000+ bare-metal servers, mixed vendors

## Architecture Options

### Option 1: Centralized Management (Recommended for <10 DCs)

```
┌─────────────────────────────────────────────────────────┐
│           Central Management Cluster (DC1)              │
│                                                         │
│  - Cluster API controllers                              │
│  - Tinkerbell CAPI provider (CAPT)                     │
│  - Cluster definitions for all DCs                     │
│  - GitOps (Flux/ArgoCD)                                │
└─────────────────────────────────────────────────────────┘
                          │
         ┌────────────────┼────────────────┐
         ↓                ↓                ↓
    ┌─────────┐      ┌─────────┐     ┌─────────┐
    │  DC1    │      │  DC2    │ ... │  DC6    │
    │         │      │         │     │         │
    │ Tink    │      │ Tink    │     │ Tink    │
    │ Stack   │      │ Stack   │     │ Stack   │
    └─────────┘      └─────────┘     └─────────┘
         │                │                │
    ┌────┴────┐      ┌────┴────┐     ┌────┴────┐
    │ Servers │      │ Servers │     │ Servers │
    │ (bare-  │      │ (bare-  │     │ (bare-  │
    │  metal) │      │  metal) │     │  metal) │
    └─────────┘      └─────────┘     └─────────┘
```

**How it works:**
- Single management cluster (highly available, 3+ nodes)
- Tinkerbell stack deployed in each DC (local to servers)
- Management cluster communicates with Tinkerbell over VPN/WAN
- Cluster definitions specify target DC via labels/selectors

### Option 2: Regional Management (For >10 DCs)

```
┌───────────────────────┐         ┌───────────────────────┐
│  Management (West)    │         │  Management (East)    │
│  - CAPI + CAPT        │         │  - CAPI + CAPT        │
└───────────────────────┘         └───────────────────────┘
         │                                  │
    ┌────┴────┐                        ┌────┴────┐
    ↓         ↓                        ↓         ↓
  DC1       DC2                      DC3       DC4
  Tink      Tink                     Tink      Tink
```

## Tinkerbell Stack per DC

Each DC needs local Tinkerbell components:

```
┌────────────────────────────────────────┐
│           Datacenter X                  │
│                                         │
│  Tinkerbell Stack (on K8s or docker):  │
│  ┌──────────────────────────────────┐  │
│  │ Boots       - DHCP, TFTP, iPXE  │  │
│  │ Hegel       - Metadata service   │  │
│  │ Tink Server - Workflow engine    │  │
│  │ Rufio       - BMC control        │  │
│  └──────────────────────────────────┘  │
│              ↓ (L2)                     │
│  ┌──────────────────────────────────┐  │
│  │   Bare-metal servers              │  │
│  │   - PXE boot from Boots           │  │
│  │   - Fetch metadata from Hegel     │  │
│  │   - Execute workflows from Tink   │  │
│  └──────────────────────────────────┘  │
└────────────────────────────────────────┘
              ↑ (L3)
    Management Cluster (remote)
```

**Why local Tinkerbell stack?**
- PXE/DHCP needs L2 connectivity
- Reduced WAN dependency for provisioning
- Faster image downloads (local)
- Can provision even if WAN is down

## Network Requirements

| Connection | Protocol | Requirement |
|------------|----------|-------------|
| Servers ↔ Tinkerbell Stack | DHCP, TFTP, HTTP | L2 (same VLAN) |
| Tinkerbell ↔ Management Cluster | HTTPS (K8s API) | L3 (VPN/WAN) |
| BMC ↔ Tinkerbell (Rufio) | Redfish/IPMI | L2 or L3 (separate BMC network) |

## Cluster Manifest Example

```yaml
apiVersion: cluster.x-k8s.io/v1beta1
kind: Cluster
metadata:
  name: prod-dc2-cluster-01
  namespace: dc2
spec:
  controlPlaneEndpoint:
    host: 10.2.0.10
    port: 6443
  infrastructureRef:
    apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
    kind: TinkerbellCluster
    name: prod-dc2-cluster-01
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: TinkerbellCluster
metadata:
  name: prod-dc2-cluster-01
  namespace: dc2
spec:
  # Points to Tinkerbell in DC2
  tinkerbellEndpoint: https://tink.dc2.example.com
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: TinkerbellMachineTemplate
metadata:
  name: control-plane
  namespace: dc2
spec:
  template:
    spec:
      # Hardware selection
      hardwareAffinity:
        required:
          - key: datacenter
            operator: In
            values: ["dc2"]
          - key: vendor
            operator: In
            values: ["dell", "supermicro"]
      # OS image
      imageLookupFormat: "ubuntu-2204-kube-{{.kubernetesVersion}}"
```

## Hardware Inventory

Tinkerbell needs hardware inventory. Two approaches:

### Approach 1: Pre-populated Hardware Resources

```yaml
apiVersion: tinkerbell.org/v1alpha1
kind: Hardware
metadata:
  name: server-dc2-r01-u10
  namespace: dc2
spec:
  id: "a4:bf:01:23:45:67"
  bmcRef:
    name: server-dc2-r01-u10-bmc
  metadata:
    datacenter: "dc2"
    rack: "r01"
    vendor: "dell"
  interfaces:
    - dhcp:
        hostname: server-dc2-r01-u10
        ip: 10.2.1.100
        mac: "a4:bf:01:23:45:67"
      netboot:
        allowPXE: true
---
apiVersion: bmc.tinkerbell.org/v1alpha1
kind: Machine
metadata:
  name: server-dc2-r01-u10-bmc
  namespace: dc2
spec:
  connection:
    host: 10.2.100.10
    authSecretRef:
      name: bmc-credentials
    insecureTLS: true
```

### Approach 2: Discovery with Boots + Auto-registration

```bash
# Servers PXE boot → Boots (DHCP) → Registered in Hardware DB
# Then CAPI can allocate from available pool
```

## Deployment Flow

```
1. Management Cluster (DC1)
   kubectl apply -f dc2-cluster.yaml
   
2. CAPI Controller
   ↓ Watches for TinkerbellCluster resource
   ↓ Talks to Tinkerbell API in DC2
   
3. Tinkerbell (DC2)
   ↓ Selects hardware from inventory
   ↓ Creates workflows
   
4. Rufio (DC2)
   ↓ Powers on servers via Redfish
   ↓ Sets PXE boot order
   
5. Servers (DC2)
   ↓ PXE boot from Boots
   ↓ Download OS image
   ↓ Execute provisioning workflow
   ↓ Install K8s components
   ↓ Join cluster
   
6. CAPI Controller
   ↓ Monitors machine status
   ↓ Marks cluster ready
```

## Practical Setup

### Step 1: Deploy Management Cluster
```bash
# In DC1, create management cluster (use kubespray or existing)
# Install Cluster API
clusterctl init --infrastructure tinkerbell
```

### Step 2: Deploy Tinkerbell Stack per DC
```bash
# In each DC, deploy Tinkerbell on bare-metal or small K8s cluster
helm install tinkerbell-stack tinkerbell/stack \
  --namespace tink-system \
  --set boots.enabled=true \
  --set hegel.enabled=true \
  --set rufio.enabled=true
```

### Step 3: Populate Hardware Inventory
```bash
# For each server in each DC
kubectl apply -f hardware-inventory-dc1.yaml
kubectl apply -f hardware-inventory-dc2.yaml
# ... dc3-6
```

### Step 4: Create Clusters via CAPI
```bash
# From management cluster
kubectl apply -f prod-clusters/dc2-cluster-01.yaml
kubectl apply -f prod-clusters/dc2-cluster-02.yaml
# etc.
```

## High Availability Considerations

### Management Cluster HA
- 3+ control plane nodes
- Spread across racks/zones in DC1
- Regular backups of CAPI state
- Consider multi-region management (Option 2) for DR

### Tinkerbell Stack HA (per DC)
- Run on local K8s cluster (3 nodes) OR
- Docker Compose with shared storage (simpler)
- Boots service is critical - needs HA
- Database (PostgreSQL) needs replication

### Network HA
- Redundant VPN tunnels between management ↔ DCs
- If WAN down, clusters continue running (just can't create new)
- Consider read-only replica of management cluster per region

## Scaling Strategy

For 1000+ servers across 6 DCs:

```
Management Cluster: 5 nodes (handle API load)
  ↓ manages
├─ DC1: 200 servers → 4 workload clusters (50 servers each)
├─ DC2: 150 servers → 3 workload clusters
├─ DC3: 180 servers → 4 workload clusters
├─ DC4: 170 servers → 3 workload clusters
├─ DC5: 160 servers → 3 workload clusters
└─ DC6: 140 servers → 3 workload clusters
```

**Per-DC Tinkerbell sizing:**
- Tinkerbell Stack: 3 nodes (can handle 200+ servers)
- Concurrent provisioning: ~10-20 servers at a time
- Hardware database scales to 1000s of entries

## Alternative: Hybrid Approach

```
┌──────────────────────────────────────────────┐
│  Management Cluster (Centralized)            │
│  - CAPI controllers                          │
│  - Metal3 provider (for some DCs)           │
│  - Tinkerbell provider (for others)         │
└──────────────────────────────────────────────┘
              ↓
    ┌─────────┴─────────┐
    ↓                   ↓
DC1-3: Tinkerbell    DC4-6: Metal3
(modern hardware)    (older hardware with Ironic)
```

Use different providers per DC based on hardware capabilities.

## Monitoring & Observability

```yaml
# Track provisioning across all DCs
- Prometheus + Grafana
  - Tinkerbell workflow metrics
  - CAPI machine lifecycle
  - Hardware utilization per DC
  
- Alerts
  - Failed provisioning workflows
  - Hardware unavailable
  - Tinkerbell stack down
  - VPN connectivity issues
```

## Trade-offs

| Approach | Pros | Cons |
|----------|------|------|
| **Centralized (1 mgmt)** | Single pane, simpler ops | WAN dependency, single point of failure |
| **Regional (2-3 mgmt)** | Better isolation, lower latency | More complex, state sync challenges |
| **Per-DC management** | Full independence | 6× operational overhead |

## Recommended: Centralized with Regional Failover

```
Primary Management (DC1) ─────┐
                              │ (replication)
                              ↓
Standby Management (DC4) ─────┘

Both can manage all 6 DCs
Failover if primary DC1 fails
```

## TL;DR

**Architecture:**
- 1 central management cluster running CAPI
- Tinkerbell stack deployed locally in each DC (needs L2 to servers)
- Management cluster manages all via L3/VPN

**Key Points:**
- Tinkerbell MUST be local (PXE/DHCP needs L2)
- Management cluster CAN be remote (API over L3)
- Hardware inventory pre-populated or auto-discovered
- Each DC independent for provisioning (survives WAN failure)
- Scale: 1 management cluster can handle 6 DCs / 1000+ servers

**For Together AI scale:**
This is production-ready and used by large orgs. Better than kubespray at 1000+ server scale.

