# Kong

<https://docs.konghq.com/>

<!-- INDEX_START -->

- [Products](#products)
- [Kong Gateway](#kong-gateway)
  - [Ports](#ports)
  - [Logs](#logs)
  - [Deployments](#deployments)
  - [Monitoring](#monitoring)
    - [Tracing](#tracing)
- [Kong Enterprise](#kong-enterprise)
- [API Gateway Benefits](#api-gateway-benefits)
- [CLI](#cli)
- [Diagram](#diagram)
  - [Kong Kubernetes Ingress](#kong-kubernetes-ingress)

<!-- INDEX_END -->

## Products

- [Kong Gateway](#kong-gateway) (open source) - API Gateway reverse-proxy
  - [Kong Enterprise](#kong-enterprise) (self-managed, built on Kong Gateway)
- Kong Konnect (Saas single global control plane manages self-installed gateways)
- Kong Manager - free/enterprise mode - uses Kong admin API to control Kong Gateway
- [Kong decK](#cli) - CLI for managing Kong Gateway or Konnect in declarative fashion
- [Kong Plugin Hub](https://docs.konghq.com/hub/)
- Kong Mesh - service mesh based on Kuma and Envoy for Kubernetes or VMs
- [Kong Insomnia](https://insomnia.rest/) - open-source API desktop client - tested but not sure what the point of this
  is compared to curl
  - Inso - Insomnia CLI for [CI/CD](ci-cd.md) use
- [Mockbin](https://mockbin.org/) - create API endpoints to test using Insomnia

## Kong Gateway

Default username / password: `kong_admin` / `password`

- most popular open-source API gateway reverse proxy
- Enterprise version requires for advanced plugins such as OIDC, RBAC, OPA, adv rate limiting and transformations

- Single-binary containing components:
  - Nginx
  - OpenResty
  - API Management
  - Plugins
  - Admin API
  - Kong Manager / declarative configuration via yaml/CLI

- low latency < 1ms
- high throughput 50K+ transactions/sec per node
- Kubernetes-native Ingress Controller and configuration yamls using CRD objects to declaratively configure all aspects
  of Kong (see [HariSekhon/Kubernetes - kong/](https://github.com/HariSekhon/Kubernetes-configs/tree/master/kong) )
- GitOps declarative configuration
- multiple API versions - redirect users to latest, rollback to previous version
- High Availability
- written in Lua on top of OpenResty framework which runs on an Nginx web server - loads Lua, JS, Go or Python plugins
- Consumer - the external client
- Route - path that maps to a URL to a service backend
  - can use regex paths (longer matches take precedence)
  - prefix paths are more resource efficient
- Service - the backend app's protocol configuration
- Upstream - the backend app's load balancing + health check
- Load Balancing
  - DNS
  - "Ring"
    - round robin (default)
    - consistent hashing - consumer, ip, header or cookie
    - least connections
    - latency
- Service Health Checks
- 95+ plugins:
  - rate-limiting
  - security
  - authn
  - caching
  - transformations
  - Advanced Plugins are rewritten versions of the OSS plugins
  - types:
    - Free - essential security, Kong Manager
    - Plus - advanced security, OIDC
    - available through Kong Konnect SaaS
    - Enterprise - secrets management, Dev portal, Vitals (analytics), RBAC

### Ports

<https://docs.konghq.com/gateway/3.2.x/production/networking/default-ports/>

| Port | Description                   |
| ---- |-------------------------------|
| 8080 | Proxy HTTP                    |
| 8443 | Proxy HTTPS                   |
| 8001 | Admin API HTTP                |
| 8444 | Admin API HTTPS               |
| 8002 | Kong Manager HTTP             |
| 8445 | Kong Manager HTTPS            |
| 8003 | Kong Developer Portal HTTP    |
| 8446 | Kong Developer Portal HTTPS   |

### Logs

```none
/usr/local/kong/logs/
```

### Deployments

- Konnect - SaaS managed control plane + self-managed data plane gateways
- Hybrid - self-managed - gateway nodes are split into control plane + data plane nodes
  - only control plane nodes access DB
  - data plane nodes get configuration from control plane nodes
  - Admin API is on the control plane nodes
  - can have control plane control gateway data plane nodes across sites, like a self-managed Konnect
- Traditional (Classic) - gateway + DB
  - DB can be [PostgreSQL](postgres.md) or [Cassandra](cassandra.md)
- DB-less - declarative configuration on each gateway - via DecK CLI yaml reconciliation or Kubernetes CRDs stored in
  etcd and loaded at pod boot time

Configuration options:

- Kong Manager UI
- Kong Admin API - Imperative - REST API calls
  - Declarative - `/config` admin API endpoint using [YAML](data-formats.md#yaml) / [JSON](json.md) config file
    (DB-less mode)
- `/etc/kong/kong.conf` (YAML) + KONG_ prefixed environment variables matching config file settings

### Monitoring

- [Prometheus](prometheus.md)
- Datadog
- Statsd

#### Tracing

- OpenTelemetry
- Zipkin
- Jaeger
- OpenTracing

## Kong Enterprise

- built on Kong Gateway (open source)
- runs natively on Kubernetes - configure Kong Gateway the same way as Kubernetes with Kong Ingress Controller
- single pane of glass
- Secrets Management - references AWS Secrets Manager, GCP Secret Manager, Hashicorp Vault or environment variables
- RBAC + teams
- Workspaces - management grouping to assign RBAC against resource entities
- OIDC (OpenID Connect)
- OPA (Open Policy Agent) authz integration
- OAuth 2.0
- integrates with AWS Secrets Manager and Hashicorp Vault
- Kong API Analytics
- Dev Portal
- Service Catalog

- License checks in precedence:
  - `KONG_LICENSE_DATA` environment variable
  - `/etc/kong/license.json`
  - `KONG_LICENSE_PATH` environment variable

```shell
http -h POST localhost:8001/licenses payload=@/path/to/license.json
```

In hybrid deployments, applying the license to control plane using method 4 will result in distribution of the license
from control plane to data plane.

Otherwise methods 1/2/3 should be used on each data plane node.

## API Gateway Benefits

- single point of entry (failure!)
- combine multiple requests into one
- transforming requests
- cache common queries
- distribute load across servers like an LB
- authn + authz before accepting API requests
- filter requests
- management - billing, routing, rate limiting, monitoring, analytics, policies, alerts, security, service discovery

## CLI

Validate configuration:

```shell
kong check
```

DB migration or Kong Gateway upgrades (takes you to Enterprise version though):

```shell
kong migrations
```

Performs non-destructive operations - no-downtime blue/green old and new deployments:

Run this from the newer version of Kong:

```shell
kong migrations up
```

- Start the newer version of kong container
- stop the old version of kong constainer
- finalize

```shell
kong migrations finish
```

```shell
kong start  # nginx and other services
```

```shell
kong stop
```

```shell
kong restart
```

```shell
deck ping
```

```shell
http POST localhost:8001/services \
          name=mockbin_service \
          url=http://mockbin:8080/request
```

```shell
http -f POST localhost:8001/services/mockbin_service/routes \
             name=mockbin_route \
             paths=/mockbin
```

```shell
deck dump --output-file gwopslabdump.yaml --workspace default
```

```shell
deck diff --state gwopslabdump.yaml
```

```shell
deck reset
#y
```

See it's empty:

```shell
http -b localhost:8001/services
```

Restore config:

```shell
deck sync --state gwopslabdump.yaml
```

```shell
http GET localhost:8001/services
```

```shell
http GET localhost:8001/routes
```

```shell
http GET localhost:8000/mockbin
```

## Diagram

### Kong Kubernetes Ingress

![Kong K8s Ingress](https://raw.githubusercontent.com/HariSekhon/Diagrams-as-Code/master/images/kubernetes_kong_api_gateway_eks.png)

**Ported from private Knowledge Base page 2023+**
