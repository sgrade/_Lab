# Traefik - Kubernetes Ingress & Gateway API

## What is Traefik?

**Traefik** = Modern reverse proxy and load balancer, supports both Ingress and Gateway API.

**Key features:**
- Dynamic configuration (auto-discovers services)
- Built-in Let's Encrypt support
- Middleware for auth, rate limiting, headers
- Native Kubernetes integration
- Metrics (Prometheus), tracing (Jaeger)
- TCP/UDP support (not just HTTP)

## Architecture

```
Internet
    ↓
Traefik (LoadBalancer Service)
    ↓
Ingress/Gateway API rules
    ↓
Services → Pods
```

## Installation

```bash
# Using Helm
helm repo add traefik https://traefik.github.io/charts
helm install traefik traefik/traefik \
  --namespace traefik \
  --create-namespace

# Verify
kubectl get pods -n traefik
kubectl get svc -n traefik  # External IP appears here
```

## Ingress API (Traditional)

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app
  annotations:
    traefik.ingress.kubernetes.io/router.entrypoints: websecure
    traefik.ingress.kubernetes.io/router.tls: "true"
spec:
  ingressClassName: traefik
  rules:
  - host: api.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 8000
  tls:
  - hosts:
    - api.example.com
    secretName: api-tls-cert
```

## Gateway API (Modern)

**Gateway API** = Next-gen Ingress, more expressive, role-oriented.

### Gateway (infrastructure)

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: main-gateway
  namespace: traefik
spec:
  gatewayClassName: traefik
  listeners:
  - name: http
    protocol: HTTP
    port: 80
  - name: https
    protocol: HTTPS
    port: 443
    tls:
      certificateRefs:
      - name: wildcard-cert
```

### HTTPRoute (application)

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: api-route
  namespace: production
spec:
  parentRefs:
  - name: main-gateway
    namespace: traefik
  hostnames:
  - api.example.com
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /v1
    backendRefs:
    - name: api-v1
      port: 8000
  - matches:
    - path:
        type: PathPrefix
        value: /v2
    backendRefs:
    - name: api-v2
      port: 8000
```

## Middleware (Traefik-specific)

**Rate limiting:**
```yaml
apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: rate-limit
spec:
  rateLimit:
    average: 100
    burst: 50
```

**Authentication:**
```yaml
apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: basic-auth
spec:
  basicAuth:
    secret: auth-credentials
```

**Headers:**
```yaml
apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: security-headers
spec:
  headers:
    customResponseHeaders:
      X-Frame-Options: "DENY"
      X-Content-Type-Options: "nosniff"
```

**Apply middleware to HTTPRoute:**
```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: api-route
spec:
  rules:
  - filters:
    - type: ExtensionRef
      extensionRef:
        group: traefik.io
        kind: Middleware
        name: rate-limit
    - type: ExtensionRef
      extensionRef:
        group: traefik.io
        kind: Middleware
        name: basic-auth
    backendRefs:
    - name: api-service
      port: 8000
```

## Advanced Features

### Traffic Splitting (Canary)

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: canary-route
spec:
  rules:
  - backendRefs:
    - name: api-stable
      port: 8000
      weight: 90
    - name: api-canary
      port: 8000
      weight: 10
```

### TCP Routing

```yaml
apiVersion: gateway.networking.k8s.io/v1alpha2
kind: TCPRoute
metadata:
  name: postgres-route
spec:
  parentRefs:
  - name: main-gateway
  rules:
  - backendRefs:
    - name: postgres
      port: 5432
```

### Let's Encrypt (Automatic TLS)

```yaml
# values.yaml for Helm
additionalArguments:
- --certificatesresolvers.letsencrypt.acme.email=admin@example.com
- --certificatesresolvers.letsencrypt.acme.storage=/data/acme.json
- --certificatesresolvers.letsencrypt.acme.tlschallenge=true

# In Ingress annotation
metadata:
  annotations:
    traefik.ingress.kubernetes.io/router.tls.certresolver: letsencrypt
```

## Monitoring

**Prometheus metrics endpoint:**
```yaml
# Traefik Helm values
metrics:
  prometheus:
    enabled: true
    entryPoint: metrics
```

**Key metrics:**
- `traefik_entrypoint_requests_total` - Request count
- `traefik_entrypoint_request_duration_seconds` - Latency
- `traefik_service_requests_total` - Per-service requests
- `traefik_backend_connections_open` - Active connections

**Dashboard:**
```bash
# Enable dashboard
kubectl port-forward -n traefik $(kubectl get pods -n traefik -l app.kubernetes.io/name=traefik -o name) 9000:9000

# Access: http://localhost:9000/dashboard/
```

## Ingress vs Gateway API

| | Ingress | Gateway API |
|---|---------|-------------|
| Maturity | Stable (v1) | Stable (v1.0) |
| Expressiveness | Basic | Advanced (traffic splitting, headers) |
| Role separation | Single resource | Gateway (infra) + Route (app) |
| Protocol support | HTTP/HTTPS only | HTTP, TCP, UDP, gRPC |
| Multi-tenancy | Limited | Better (ReferenceGrant) |

**Recommendation:** Use Gateway API for new deployments (more future-proof).

## Common Issues

**Problem:** External IP stuck in `<pending>`
```bash
# Check LoadBalancer service
kubectl get svc -n traefik
kubectl describe svc traefik -n traefik

# Cloud provider issue? Check events
kubectl get events -n traefik
```

**Problem:** 404 Not Found
```bash
# Check if route is registered
kubectl get httproutes -A
kubectl describe httproute <name>

# Check Traefik logs
kubectl logs -n traefik -l app.kubernetes.io/name=traefik -f
```

**Problem:** TLS certificate issues
```bash
# Check certificate secret
kubectl get secret <tls-secret> -o yaml

# Verify cert-manager (if using)
kubectl get certificate
kubectl describe certificate <name>
```

## Best Practices

- Use Gateway API for new deployments
- Separate infrastructure (Gateway) from app routing (HTTPRoute)
- Enable rate limiting for public APIs
- Use middleware for cross-cutting concerns (auth, headers)
- Monitor metrics in Prometheus/Grafana
- Set resource limits on Traefik pods
- Use HPA for Traefik deployment
- Configure PodDisruptionBudget for HA

