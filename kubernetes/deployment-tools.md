 # Kubernetes Deployment Tools

## Helm

**What:** Package manager for Kubernetes. Templates + values = manifests.

**How it works:**
```
Chart (templates + Chart.yaml)
    ↓
helm install myapp ./chart --values prod.yaml
    ↓
Renders templates with values
    ↓
Applies manifests to cluster
```

**Example chart structure:**
```
mychart/
├── Chart.yaml        # Metadata
├── values.yaml       # Default values
└── templates/
    ├── deployment.yaml
    └── service.yaml
```

**Commands:**
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install postgres bitnami/postgresql
helm upgrade postgres bitnami/postgresql --set auth.password=newpass
helm rollback postgres 1
```

**Open-source:** Helm is fully OSS (CNCF graduated).

## Kustomize

**What:** Overlay-based customization. No templating, pure YAML patches.

**How it works:**
```
base/
├── deployment.yaml   # Base manifest
└── kustomization.yaml

overlays/prod/
├── kustomization.yaml  # References base + patches
└── replica-patch.yaml  # Only differences
    ↓
kubectl apply -k overlays/prod/
    ↓
Merges base + patches → applies to cluster
```

**Example structure:**
```yaml
# base/kustomization.yaml
resources:
- deployment.yaml
- service.yaml

# overlays/prod/kustomization.yaml
bases:
- ../../base
replicas:
- name: myapp
  count: 5
images:
- name: myapp
  newTag: v2.0.0
```

**Commands:**
```bash
kubectl apply -k base/          # Apply base
kubectl apply -k overlays/prod/ # Apply with prod patches
kustomize build overlays/prod/  # Preview merged YAML
```

**Key features:**
- Built into kubectl (no install needed)
- Strategic merge patches or JSON patches
- ConfigMap/Secret generators
- Common labels/annotations

**Kustomize vs Helm:**

| | Kustomize | Helm |
|---|-----------|------|
| Approach | Patch existing YAML | Template engine |
| Learning curve | Lower (just YAML) | Higher (Go templates) |
| Flexibility | Limited to patches | Full templating logic |
| Built-in | Yes (kubectl -k) | Separate binary |

**Open-source:** Kustomize is fully OSS, part of kubernetes-sigs.

## ArgoCD

**What:** GitOps continuous delivery. Git = source of truth, ArgoCD syncs cluster to match Git.

**How it works:**
```
Git repo (YAML manifests)
    ↓
ArgoCD watches repo
    ↓
Detects drift (cluster ≠ Git)
    ↓
Auto-syncs or alerts
```

**Architecture:**
- API Server: Web UI, CLI, webhook receiver
- Repo Server: Fetches manifests from Git
- Application Controller: Watches cluster state, syncs

**Example Application:**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-app
spec:
  source:
    repoURL: https://github.com/org/repo
    path: k8s/prod
    targetRevision: main
  destination:
    server: https://kubernetes.default.svc
    namespace: production
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

**Open-source:** ArgoCD is fully OSS (CNCF incubating).

**Commercial:** Codefresh, Akuity (managed ArgoCD with enterprise features).

## Flux

**What:** GitOps alternative to ArgoCD. More CRD-focused, split into controllers.

**How it works:**
```
Git repo
    ↓
Source Controller: Monitors Git
    ↓
Kustomize/Helm Controller: Renders manifests
    ↓
Applies to cluster
```

**Architecture (modular):**
- source-controller: Git, Helm repos, S3 buckets
- kustomize-controller: Kustomize + drift detection
- helm-controller: Helm releases
- notification-controller: Alerts
- image-reflector/automation: Auto-update images

**Example GitRepository + Kustomization:**
```yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: my-repo
spec:
  interval: 1m
  url: https://github.com/org/repo
  ref:
    branch: main
---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: my-app
spec:
  interval: 10m
  sourceRef:
    kind: GitRepository
    name: my-repo
  path: ./k8s/prod
  prune: true
```

**Open-source:** Flux is fully OSS (CNCF graduated).

**Commercial:** Weaveworks (now defunct), but Flux continues as CNCF project.

## Comparison

| | Helm | ArgoCD | Flux |
|---|------|--------|------|
| **Type** | Package manager | GitOps CD | GitOps CD |
| **UI** | CLI only | Web UI + CLI | CLI only (dashboards via extensions) |
| **Multi-cluster** | Manual | Built-in | Via clusters + kubeconfigs |
| **Image updates** | Manual | External (argocd-image-updater) | Built-in (image-automation) |
| **Maturity** | CNCF Graduated | CNCF Incubating | CNCF Graduated |
| **Complexity** | Simple | Medium | Higher (more controllers) |

**Common patterns:**
- Helm for packaging → ArgoCD/Flux for deployment
- Small teams: ArgoCD (easier UI)
- Large/complex: Flux (more modular, better multi-tenancy)


