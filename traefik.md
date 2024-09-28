# Traefik

Open-source reverse proxy / load balancer designed specifically for dynamic, cloud-native environments.

Well-suited for microservices and containerized architectures such as [Kubernetes](kubernetes.md).

<!-- INDEX_START -->

- [Key Points](#key-points)
  - [Routers](#routers)
  - [Middleware](#middleware)
  - [Services](#services)
  - [Why bother vs Nginx ingress](#why-bother-vs-nginx-ingress)
- [Traefik Hub](#traefik-hub)
- [Diagram - Traefik Kubernetes Ingress](#diagram---traefik-kubernetes-ingress)

<!-- INDEX_END -->

## Key Points

- Traefik Proxy is the default ingress controller for Rancher Lab's [K3s](k3s.md)
- Dashboard is read-only - shows static + dynamic configs for apps
- Traefik Enterprise is needed to integrate more than 1 ingress pod with LetsEncrypt
  - <https://doc.traefik.io/traefik/providers/kubernetes-ingress/#letsencrypt-support-with-the-ingress-provider>

<!-- -->

- Dynamic Configuration - automatically discovers services in real-time and updates its configuration without manual
  intervention
- Support for Multiple Protocols: Works with HTTP, HTTPS, TCP, and UDP traffic
- [Load Balancing](load-balancing.md) - distributes requests across multiple instances of a service to ensure
  high availability and scalability
- SSL Termination - native built-in support for Let's Encrypt to automatically generate and renew SSL certificates
  - might need to add traditional ingresses instead of Traefik's advanced IngressRoute if wanting to use
    [Cert Manager](kubernetes-production-ready-checklist.md#automatic-ssl---cert-manager) instead
- Routing - flexible routing rules based on various criteria like domain, path, headers, etc.
- Middleware - offers middleware capabilities for functionalities such as authentication, rate limiting, and access
  control
- Extensibility - highly customizable with plug-ins and easy integration with observability tools like
  [Prometheus](prometheus.md) and [Grafana](grafana.md)

## Configuration

- Static - at startup - can only use one of these in this order of priority:
  - config file
  - CLI args in deployment
  - environment variables
  - uses CLI args on [K3s](k3s.md)
  - static config sets entrypoints (port), backend providers to enable for dynamic configs, tracing, observability, and
    logging
- Dynamic - polls backend providers to get config updates

- can listen to different protocols on the same port! eg. HTTPS and plain TCP passthrough on same port...
- Provider Types
  - Labels - [Dockerfile](dockerfile.md)
  - Annotations - [Kubernetes](kubernetes.md)
    [Ingress](https://github.com/HariSekhon/Kubernetes-configs/blob/master/ingress.yaml)
  - Key/Value Pairs - [Etcd](etcd.md) / [ZooKeeper](zookeeper.md) / [Consul](consul.md)
  - Files - Bare Metal or [Kubernetes](kubernetes.md) CRD such as IngressRoute, can also use Kubernetes ConfigMap mount
    for non-standard configurations

- Provider Namespaces - `<name>@<provider>` eg. `middleware-redirect@kubernetescrd`
  - in K8s Ingress this would be referenced as just `middleware-redirect`
  because it's already part of Kubernetes CRD provider

### Routers

- `Routers` -> `entrypoint` -> `Router`
- router analyzes request, connects it to middleware or service
- matches on protocol, path, hostname, and TLS config

### Middleware

Alters request before handing it off to a Service.

- auth
- rewrites
- redirects
- rate limiting
- compression
- buffering
- circuit breaking
- retries
- error handling
- available for HTTP and TCP routers
- can chain middleware together

### Services

Connects requests to backend servers.

- [load balancing](load-balancing.md)
- sticky session persistence
- canary
- blue / green
- weighted routing
- only uses K8s service to get list of healthy pods from endpoints resource, sends directly to pods and bypasses k8s
  service IP
- use `TraefikService` when you want the Traefik LB features

### Kubernetes CRD vs Traefik Objects

| Kubernetes CRD object                      | Traefik object                                                                         |
|--------------------------------------------|----------------------------------------------------------------------------------------|
| IngressRoute<br>( HTTP / TCP / UDP )       | Router - can point to either Kubernetes service or more LB feature rich TraefikService |
| TraefikService                             | HTTP Service (not a Kubernetes service)                                                |
| Middleware<br>( HTTP / TCP )               | Middleware                                                                             |
| TLSOptions<br>TLSStore<br>ServersTransport | same                                                                                   |

### Deploy vs Release

- Deploy pods
- Release - when traffic is cut over to new pods

### Load Balancing

- sticky sessions / session persistence - same user goes to same server in web farm - using Source IP or Cookie Header
  affinity
  - Traefik Proxy uses header `Set-Cookie`
- canary deployment
  - weighted round robin small percentage of traffic from real users
    or
  - route to new version based on header for QA team only to see the new version on production
- mirroring - duplicate requests to new version, but do not send the traffic back to users
  - analyze logfiles and metrics of how the app behaves

### Why bother with Traefik vs Nginx ingress

- Traefik doesn't interrupt in-flight connections to reload configuration
  - Nginx creates a new file and then restarts pods!
- more secure - Nginx has had more vulnerabilities
- weighted balancing (but pods are the same size so does this matter??)
- rate limiting
- no-code authentication
- Lets Encrypt support (other ingresses like Nginx, [Kong](kong.md), [HAProxy](haproxy.md) just use Cert Manager
  watching the k8s ingress object configuration to auto-generate which is a more generic solution)
- Observability - dashboard, log analysis, metrics and request tracing
  - integrates with:
    - Datadog
    - [Elastic](elasticsearch.md) stack
    - [InfluxDB](influxdb.md)
    - Statsd
    - Jaeger
    - [Prometheus](prometheus.md)
    - Zipkin
- Custom plugins
- Plugin Catalog - available from Dashboard and Traefik Labs home page

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Kubernetes-configs&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Kubernetes-configs)

## Traefik Hub

- Publishes services to Traefik and exposes them via a `https://<random>.traefikhub.io` URL
- Tunnels from K8s cluster where agent is to Traefik Hub to get configurations
- Supports Traefik Proxy and Nginx Ingress

<https://hub.traefik.io/agents>

See [HariSekhon/Kubernetes-configs - traefik-hub-agent](https://github.com/HariSekhon/Kubernetes-configs/tree/master/traefik-hub-agent)

Create secret from command there and install
[kustomization helm chart](https://github.com/HariSekhon/Kubernetes-configs/tree/master/traefik-hub-agent)

- **XXX: set an Access Control Policy to protect this URL endpoint with JWT token, Basic Auth or OIDC to Google:**

<https://doc.traefik.io/traefik-hub/access-control-policies/methods/oidc-google/>

- **XXX: set an access control policy immediately here:**

<https://hub.traefik.io/acp>

- creates a Kubernetes `accesscontrolpolicies` object of the same name as the policy in the traefik namespace:

```shell
kubectl get accesscontrolpolicies -A
```

```none
hub-agent-auth-server-cc8d559bf-hn65h   1/1     Running   0          5h47m
hub-agent-auth-server-cc8d559bf-l8x4f   1/1     Running   0          5h47m
hub-agent-auth-server-cc8d559bf-pdx6j   1/1     Running   0          5h47m
hub-agent-controller-656cccffd8-w7lms   1/1     Running   0          5h47m
hub-agent-dev-portal-fd5d4c68-95m6m     1/1     Running   0          5h47m
hub-agent-dev-portal-fd5d4c68-b2zd9     1/1     Running   0          5h47m
hub-agent-dev-portal-fd5d4c68-jndd9     1/1     Running   0          5h47m
hub-agent-tunnel-569669c8bb-wbx2v       1/1     Running   0          5h47m
```

## Diagram - Traefik Kubernetes Ingress

[HariSekhon/Kubernetes-configs - Traefik](https://github.com/HariSekhon/Kubernetes-configs/tree/master/traefik)

![Traefik K8s Ingress](https://raw.githubusercontent.com/HariSekhon/Diagrams-as-Code/master/images/kubernetes_traefik_ingress_gke.svg)

**Ported from private Knowledge Base page 2023+**
