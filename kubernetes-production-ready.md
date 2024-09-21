# Kubernetes Production Ready Checklist

Roughly stack racked by importance and ease of implementation.

You can work your way down this list linearly for maximum return on investment for however much time you have.

Many config templates and examples are available in the excellent
[HariSekhon/Kubernetes-configs](https://github.com/HariSekhon/Kubernetes-configs)
repo referenced throughout this page for faster implementation seeing what has actually worked and just editing a few
lines specific to your environment.

<!-- INDEX_START -->
<!-- INDEX_END -->

## Healthchecks

Readiness / liveness probes are critically important for correction functioning.

See the deployment and statefulset templates:

[HariSekhon/Kubernetes-configs - deployment.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/deployment.yaml)

[HariSekhon/Kubernetes-configs - statefulset.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/statefulset.yaml)

## Horizontal Pod Autoscaler

Make sure your pods scale up to meet traffic demands and scale down off-peak to not waste resources.

[HariSekhon/Kubernetes-configs - horizontal-pod-autoscaler.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/horizontal-pod-autoscaler.yaml)

## Pod Disruption Budget

Ensure the Kubernetes scheduler doesn't take down more pods than you can afford for High Availability purposes
or scaling capacity purposes to still be able to serve high load traffic during peak times.

Set your pod disruption budget according to your capacity ability to handle pods being reaped and moved around:

[HariSekhon/Kubernetes-configs - pod-disruption-budget.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/pod-disruption-budget.yaml)

## Pod Anti-Affinity

Ensure your pod replicas are spread and deployed for maximum High Availability and stability.

across different servers,

### High Availability

- spread across different servers to protect against random hardware failure of a single server causing an outage
- spread across different [cloud](cloud.md) availability zones to protect against a single datacenter outage
  eg. power failure / fire / flood / networking issue

### Stable On-Demand vs Preemptible / Spot Instances

On [cloud](cloud.md), choose between running your pods on-demand nodes which are full price or on preemptible or spot
instances which are much cheaper.

#### Cost Optimization

If your application can take random pod migrations such as a [horizontally scaled](#horizontal-pod-autoscaler) web farm,
then use preemptible or spot instances to save significant money on your cloud budget.

This is part of basic best practice cloud cost optimization.

#### Single Instance App Stability

If you have an app like [Jenkins](jenkins-on-kubernetes.md) server, then you should definitely
run it on stable on-demand nodes unless you like having several minute outages of your Jenkins UI and job scheduler
while the Jenkins server pod is restarted on another node.

#### App Sensitivity to Disruptions

Some apps like coordination nodes may not fair well if randomly restarted in any number.

[Pod Disruption Budgets](#pod-disruption-budget) may not help here as they only control the Kubernetes scheduker's
decision about how many pods to reap and redeploy elsewhere at one time.
The Kubernetes scheduler and therefore pod disruption budgets have no control over the lower level Cloud's decision to
reap spot-instances at any time, meaning they could randomly take out any number of nodes if there is a lot of demand
for spot pricing.

Do not run quorum coordination services on spot / preemptible instances for this reason
as you could lose too many of them at the same time,
causing a complete quorum outage and impacting all other applications depending on them for coordination.

No spot / preemptible for:

- [ZooKeeper](zookeeper.md)
- [Consul](consul.md)
- [Etcd](etcd.md)

### Performance Engineering

You may also choose to ensure certain apps are not deployed alongside other performance hungry apps to optimize the
performance available to them.

### Configs

[HariSekhon/Kubernetes-configs - deployment.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/deployment.yaml)

[HariSekhon/Kubernetes-configs - statefulset.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/deployment.yaml)

## Ingress Controllers

Set up a stable HTTPS entrypoint to your apps with DNS and SSL.

- [Nginx](https://kubernetes.github.io/ingress-nginx/) ([config](https://github.com/HariSekhon/Kubernetes-configs/blob/master/ingress-nginx/base/))
- [Kong](https://konghq.com/) ([config](https://github.com/HariSekhon/Kubernetes-configs/blob/master/kong/base/))
- [Traefik](https://traefik.io/traefik/) ([config](https://github.com/HariSekhon/Kubernetes-configs/blob/master/traefik/base/))
- [HAProxy](https://haproxy.org/) ([config](https://github.com/HariSekhon/Kubernetes-configs/blob/master/haproxy))

### Ingress SSL

Set up [Cert Manager](https://cert-manager.io/) for
[Automatic Certificate Management](https://en.wikipedia.org/wiki/Automatic_Certificate_Management_Environment)
using the popular free
[Let's Encrypt](https://letsencrypt.org) certificate authority.

You can also use your [cloud](cloud.md) certificate authority if your corporate policy dictates.

[HariSekhon/Kubernetes-configs - cert-manager](https://github.com/HariSekhon/Kubernetes-configs/blob/master/cert-manager)

## App Lifecycle Management

Set up [ArgoCD](https://argoproj.github.io/cd/) to automatically deploy,
update and repair your Kubernetes configs.

[HariSekhon/Kubernetes-configs - argocd](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/base/)

## App Ingresses

Ensure each app has an ingress address to be reachable via a URL.

Otherwise you'll have to waste time `kubectl port-foward` tunneling to access it each time.

If you are stuck doing that, either because you haven't yet gotten all your Ingress magic set up yet,
then you may want to use
[HariSekhon/DevOps-Bash-tools -kubectl_port_forward.sh](https://github.com/HariSekhon/Kubernetes-configs/blob/master/kubernetes/kubectl_port_forward.sh).

In some cases this can't be avoided, such as [Spark](spark.md#spark-on-kubernetes-ui-tunnel) jobs
launched by [Informatica](informatica.md).

If your ingress controllers are working, set up your app ingresses by editing this config:

[HariSekhon/Kubernetes-configs -ingress.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/ingress.yaml)

See also various app-specific ingresses already provided in
[HariSekhon/Kubernetes-configs](https://github.com/HariSekhon/Kubernetes-configs) repo
under `*/overlay/ingress.yaml`.

## App Resources

Setting appropriate resource `requests` and `limits` is critical to both performance and reliability.

Otherwise, apps will end up over-contended - degrading their performance or being outright killed by Linux's OOM Killer
to save the host from crashing - resulting in sudden pod recreations on other nodes and possible service disruptions.

See resources sections in

[HariSekhon/Kubernetes-configs - deployment.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/deployment.yaml)

[HariSekhon/Kubernetes-configs - statefulset.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/statefuleset.yaml)

### App Right-Sizing

But what to set your resource `requests` and `limits` to you say?

Install [Goldilocks](https://www.fairwinds.com/goldilocks) to generate VPAs and resource recommendations.

It will tell you exactly how much your app is using so you can tune its resource `requests` and `limits`
after setting an initial estimate of your best guess.

[HariSekhon/Kubernetes-configs - Goldilocks](https://github.com/HariSekhon/Kubernetes-configs/blob/master/goldilocks/base/)

## DNS - Automatic DNS Records for Apps

Install [External DNS](https://github.com/kubernetes-sigs/external-dns) to automatically create DNS records for your
apps.

It integrates with many popular DNS providers such as [Cloudflare](cloudflare.md),
[AWS](aws.md) Route53, [GCP](gcp.md) Cloud DNS etc.

[HariSekhon/Kubernetes-configs - External DNS](https://github.com/HariSekhon/Kubernetes-configs/blob/master/external-dns/base/)

## Secrets - Automated Secrets

Install one of the following:

- [External Secrets](#external-secrets)
- [Sealed Secrets](#sealed-secrets)

### External Secrets

[External Secrets](https://github.com/external-secrets/external-secrets) integrates with and pulls secrets from:

- [AWS](aws.md) Secrets Manager
- [GCP](gcp.md) Secret Manager
- [Azure](azure.md) Key Vault
- Hashicorp [Vault](vault.md)

[HariSekhon/Kubernetes-configs - External Secrets](external-secrets/base/)

### Sealed Secrets

[Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets) by Bitnami is a simpler solution in which you encrypt a secret
using a private key unique to the cluster which results in a blob that is safe to store in [Git](git.md) because it can
only be decrypted by the cluster to regenerate the Kubernetes secret object.

The drawback of this approach is that the secret must be generated for each cluster, and if the cluster
(or more the Sealed Secret installation with the private key on that cluster) is destroyed and recreated,
then the sealed secrets are unrecoverable and you must regenerate the secrets.

This means this is no good for fast DR or recreations of Kubernetes clusters
unless you can also back up and restore the sealed secrets private keys for the cluster.

[HariSekhon/Kubernetes-configs - Sealed Secrets](https://github.com/HariSekhon/Kubernetes-configs/blob/master/sealed-secrets/base/)

## Namespaces

### Resource Quotas per Namespace

On multi-tenant Kubernetes clusters, create a namespace for each app / team and limit the amount of CPU and RAM
resources they are allowed to request from Kubernetes scheduler in their [app resource requests](#app-resources).

[HariSekhon/Kubernetes-configs - resource-quota.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/resource-quota.yaml)

### Limit Ranges

These set default resource `requests` and `limits` for apps within the namespace.

Make these frugle and force people to right-size their apps in 2 iterations at time of deployment using
[Goldilocks](#app-right-sizing).

[HariSekhon/Kubernetes-configs - limit-range.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/limit-range.yaml)

### Network Policies

Restrict communications between namespaces containing different apps and teams.

This is equivalent to old school internal firewalling between different LAN subnets inside the Kubernetes cluster.

[HariSekhon/Kubernetes-configs - network-policy.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/network-policy.yaml)

## Pod Security Policies

Deprecated in newer versions of Kubernetes.

[HariSekhon/Kubernetes-configs - pod-security-policy.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/pod-security-policy.yaml)

## Governance, Security & Best Practices

Install [Polaris](https://www.fairwinds.com/polaris) for a recommendations dashboard full of best practices.

[HariSekhon/Kubernetes-configs - Polaris](polaris/base/)

## Find Deprecated API objects to replace

Run [Pluto](https://pluto.docs.fairwinds.com/) against your cluster before
[Kubernetes cluster upgrades](kubernetes-upgrades.md)

The following scripts are useful from in the popular [DevOps Bash Tools](https://github.com/HariSekhon/DevOps-Bash-tools) repo:

- [pluto_detect_kustomize_materialize.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/kubernetes/pluto_detect_kustomize_materialize.sh)
  - recursively materializes all `kustomization.yaml` and runs [Pluto](https://github.com/FairwindsOps/pluto) on each
  directory to work around [this issue](https://github.com/FairwindsOps/pluto/issues/444)
- [pluto_detect_helm_materialize.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/kubernetes/pluto_detect_helm_materialize.sh)
  - recursively materializes all helm `Chart.yaml` and runs [Pluto](https://github.com/FairwindsOps/pluto) on each
    directory to work around [this issue](https://github.com/FairwindsOps/pluto/issues/444)
- [pluto_detect_kubectl_dump_objects.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/kubernetes/pluto_detect_kubectl_dump_objects.sh)
  - dumps all live Kubernetes objects to /tmp all can run [Pluto](https://github.com/FairwindsOps/pluto) to detect
    deprecated API objects on the cluster from any source

## Helm

### Helm is not IaC idempotent by itself

People who deploy directly from Helm CLI should be aware that is PoC territory.

You must wrap Helm in Kustomize or ArgoCD or similar to detect live object config drift!

### Quickly update any Helm Charts in a `kustomization.yaml` file

Use
[kustomize_update_helm_chart_versions.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/kubernetes/kustomize_update_helm_chart_versions.sh)
in the popular [DevOps Bash Tools](https://github.com/HariSekhon/DevOps-Bash-tools) repo.

<br>

**Migrated from [HariSekhon/Kubernetes-configs](https://github.com/HariSekhon/Kubernetes-configs) repo**
