# Kubernetes Production Ready Checklist

Roughly stack racked by importance and ease of implementation.

You can work your way down this list linearly for maximum return on investment for however much time you have.

Many config templates and examples are available in the excellent
[HariSekhon/Kubernetes-configs](https://github.com/HariSekhon/Kubernetes-configs)
repo referenced throughout this page for faster implementation seeing what has actually worked and just editing a few
lines specific to your environment.

<!-- INDEX_START -->

- [Healthchecks](#healthchecks)
- [Horizontal Pod Autoscaler](#horizontal-pod-autoscaler)
- [Pod Disruption Budget](#pod-disruption-budget)
- [Pod Anti-Affinity](#pod-anti-affinity)
  - [High Availability](#high-availability)
  - [Stable On-Demand vs Preemptible / Spot Instances](#stable-on-demand-vs-preemptible--spot-instances)
    - [Cost Optimization](#cost-optimization)
    - [Single Instance App Stability](#single-instance-app-stability)
    - [App Sensitivity to Disruptions](#app-sensitivity-to-disruptions)
  - [Performance Engineering](#performance-engineering)
  - [PDB Configs](#pdb-configs)
- [Ingress](#ingress)
  - [Ingress Controllers](#ingress-controllers)
  - [Ingress SSL](#ingress-ssl)
  - [App Ingresses](#app-ingresses)
- [Applications](#applications)
  - [App Lifecycle Management](#app-lifecycle-management)
  - [App Resource Requests & Limits](#app-resource-requests--limits)
  - [App Right-Sizing - Goldilocks & Vertical Pod Autoscaler](#app-right-sizing---goldilocks--vertical-pod-autoscaler)
- [DNS - Automatic DNS Records for Apps](#dns---automatic-dns-records-for-apps)
- [Secrets - Automated Secrets](#secrets---automated-secrets)
  - [External Secrets](#external-secrets)
  - [Sealed Secrets](#sealed-secrets)
- [Namespaces](#namespaces)
  - [Resource Quotas per Namespace](#resource-quotas-per-namespace)
  - [Limit Ranges](#limit-ranges)
  - [Network Policies](#network-policies)
- [Pod Security Policies](#pod-security-policies)
- [Governance, Security & Best Practices](#governance-security--best-practices)
- [Find Deprecated API objects to replace](#find-deprecated-api-objects-to-replace)
- [Helm](#helm)
  - [Helm is not IaC idempotent by itself](#helm-is-not-iac-idempotent-by-itself)
  - [Quickly update any Helm Charts in a `kustomization.yaml` file](#quickly-update-any-helm-charts-in-a-kustomizationyaml-file)

<!-- INDEX_END -->

## Healthchecks

Readiness / liveness probes are critically important for the following reasons:

1. Readiness Probes
   1. only direct traffic to pods which are fully initialized and functioning
   1. don't let users see frequent errors from pods which have been recently migrated / restarted which happens frequently
      on Kubernetes clusters
1. Liveness Probes
   1. restart pods which are stuck after encountering state errors either at runtime or initialization time
      (eg. pull from a config source at initialization or a [database](databases.md) connection
      failing to establish during startup)
   1. this is the only probe that will restart the pod to reset its state to overcome such issues
1. Startup Probes
   1. newer versions of Kubernetes give a specific check for startup. This is useful for apps which have
      long initialization times but you don't want to set high times on Readiness probes
      which would delay dropping later malfunctioning pods out of the Kubernetes internal service load balancer in good
      time - which would end up sending requests in the interim which may be surfaced as errors to users

See the deployment and statefulset templates:

[HariSekhon/Kubernetes-configs - deployment.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/deployment.yaml)

[HariSekhon/Kubernetes-configs - statefulset.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/statefulset.yaml)

## Horizontal Pod Autoscaler

Make sure your pods scale up to meet traffic demands
and scale down off-peak to not waste resources and cloud usage costs.

[HariSekhon/Kubernetes-configs - horizontal-pod-autoscaler.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/horizontal-pod-autoscaler.yaml)

## Pod Disruption Budget

Ensure the Kubernetes scheduler doesn't take down more pods than you can afford for High Availability purposes
or scaling capacity purposes to still be able to serve full traffic at the current scaling level.

Set your pod disruption budget according to your capacity and app's ability to handle a certain number of pods being
unavailable at a given time due to being migrated (killed and restarted on another node):

This is doubly important if you're running apps:

1. apps with a strict quorum requirements
   1. eg. [ZooKeeper](zookeeper.md), [Consul](consul.md) or [Etcd](etcd.md) which cannot tolerate more than 1-2 nodes
      being unavailable before causing complete outages
1. apps with sharded replicas (common with [NoSQL](README.md#nosql) systems)
   1. eg. [Elasticsearch](elasticsearch.md),
      [SolrCloud](solr.md#solrcloud),
      [Cassandra](cassandra.md),
      [MongoDB](mongo.md),
      [Couchbase](couchbase.md)
      where often an outage of 2 nodes could cause partial outages via shard unavailability,
      incomplete results or query failures

[HariSekhon/Kubernetes-configs - pod-disruption-budget.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/pod-disruption-budget.yaml)

## Pod Anti-Affinity

Ensure your pod replicas are spread across nodes for maximum availability and stability.

By default the Kubernetes scheduler will attempt to do a basic spread of pods across nodes
but Pod Anti-Affinity rules enhance this in the following ways:

### High Availability

- spread across different servers to protect against random hardware failure of a single server causing an outage
- spread across different [cloud](cloud.md) availability zones to protect against a single datacenter outage
  eg. power failure / fire / flood / networking issue

### Stable On-Demand vs Preemptible / Spot Instances

On [cloud](cloud.md), choose between running your pods on full priced on-demand nodes or on discounted price preemptible
or spot instances which are much cheaper.

#### Cost Optimization

If your application can take random pod migrations such as a [horizontally scaled](#horizontal-pod-autoscaler) web farm,
then use preemptible or spot instances to save significant money on your cloud budget.

This is part of basic best practice cloud cost optimization.

#### Single Instance App Stability

If you have an app like [Jenkins](jenkins-on-kubernetes.md) server which is a single point of failure then you should definitely
run it on stable on-demand nodes unless you like having several minute outages of your Jenkins UI and job scheduler
while the Jenkins server pod is restarted on another node.

Jenkins for example takes several minutes to start up,
you don't want this happening every day on GCP preemptible nodes or randomly on AWS spot instances.

#### App Sensitivity to Disruptions

Some apps like coordination services or clustered shared data services may not fair well
if randomly restarted in any uncontrolled number such as spot instances may do.

[Pod Disruption Budgets](#pod-disruption-budget) can't help here as they only control the Kubernetes scheduler's
decision about how many pods to reap and redeploy elsewhere at one time.
The Kubernetes scheduler and therefore pod disruption budgets have no control over the lower level Cloud's decision to
reap spot instances at any time, meaning they could randomly take out any number of nodes upon a surge of demand
for spot instances.

Do not run quorum coordination services on spot / preemptible instances for this reason
as you could lose too many of them at the same time,
causing a complete quorum outage and impacting all other applications depending on them for coordination.

**No spot / preemptible for:**

- Coordination Services:
  - [ZooKeeper](zookeeper.md)
  - [Consul](consul.md)
  - [Etcd](etcd.md)
- NoSQL data sharding services:
  - [Elasticsearch](elasticsearch.md)
  - [SolrCloud](solr.md#solrcloud)
  - [Cassandra](cassandra.md)
  - [MongoDB](mongo.md)
  - [Couchbase](couchbase.md)

### Performance Engineering

You may also choose to ensure certain apps are not deployed alongside other performance hungry apps to optimize the
performance available to them.

### PDB Configs

[HariSekhon/Kubernetes-configs - deployment.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/deployment.yaml)

[HariSekhon/Kubernetes-configs - statefulset.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/deployment.yaml)

## Ingress

### Ingress Controllers

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

### App Ingresses

Ensure each app has an ingress address to be reachable via a URL.

Otherwise you'll have to waste time `kubectl port-foward` tunneling to access it each time.

If you are stuck doing that, either because you haven't yet gotten all your Ingress magic set up yet,
then you may want to use
[HariSekhon/DevOps-Bash-tools -kubectl_port_forward.sh](https://github.com/HariSekhon/Kubernetes-configs/blob/master/kubernetes/kubectl_port_forward.sh).

In some cases this can't be avoided, such as [Spark](spark.md#spark-on-kubernetes-ui-tunnel) jobs
launched by [Informatica](informatica.md) due to having the UI on randomly launched job driver pods.

If your ingress controllers are working, set up your app ingresses by editing this config:

[HariSekhon/Kubernetes-configs -ingress.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/ingress.yaml)

See also various app-specific ingresses already configured in
[HariSekhon/Kubernetes-configs](https://github.com/HariSekhon/Kubernetes-configs) repo
under `*/overlay/ingress.yaml`.

## Applications

### App Lifecycle Management

Set up [ArgoCD](https://argoproj.github.io/cd/) to automatically deploy,
update and repair your Kubernetes configs from the saved good config in git ie.
'GitOps'.

[HariSekhon/Kubernetes-configs - argocd](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/base/)

### App Resource Requests & Limits

Setting appropriate resource `requests` and `limits` is critical to both performance and reliability.

Otherwise, apps will end up over-contended - degrading their performance or being outright killed by Linux's OOM Killer
to save the host from crashing - resulting in sudden pod recreations on other nodes and possible service disruptions.

See resources sections in

[HariSekhon/Kubernetes-configs - deployment.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/deployment.yaml)

[HariSekhon/Kubernetes-configs - statefulset.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/statefuleset.yaml)

### App Right-Sizing - Goldilocks & Vertical Pod Autoscaler

But what to set your resource `requests` and `limits` to?

Install [Goldilocks](https://www.fairwinds.com/goldilocks)
to generate VPAs for resource recommendations with a nice dashboard.

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

The drawback of this approach is that the secret must be generated for each cluster - whereas External Secrets config
can be inherited across clusters - while if a Sealed Secrets cluster
(or more accurately the Sealed Secrets installation with the private key on that cluster)
is destroyed and recreated, then the sealed secrets are unrecoverable and you must regenerate all the secrets.

This means this is no good for fast DR or recreations of Kubernetes clusters
unless you can also back up and restore the sealed secrets private keys for the cluster.

[HariSekhon/Kubernetes-configs - Sealed Secrets](https://github.com/HariSekhon/Kubernetes-configs/blob/master/sealed-secrets/base/)

## Namespaces

### Resource Quotas per Namespace

On multi-tenant Kubernetes clusters, create a namespace for each app / team and limit the amount of CPU and RAM
resources they are allowed to request from the cluster's Kubernetes scheduler in their [app resource requests](#app-resources).

This will prevent one team or app from greedily using up all the cluster resources and allow for better resource
planning.

[HariSekhon/Kubernetes-configs - resource-quota.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/resource-quota.yaml)

### Limit Ranges

These set default resource `requests` and `limits` for apps within the namespace.

Make these frugle and force people to right-size their apps in a couple quick iterations at time of deployment using
[Goldilocks](#app-right-sizing).

[HariSekhon/Kubernetes-configs - limit-range.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/limit-range.yaml)

### Network Policies

Restrict communications between namespaces containing different apps and teams.

This is equivalent to old school internal firewalling between different LAN subnets inside the Kubernetes cluster.

If one app in one namespace was to get compromised, there is no reason to allow it to be using as a launching pad to
attack adjacent apps in the cluster.

This will also force teams to document the network connections and services their app is using in order for you to
permit their network access.

[HariSekhon/Kubernetes-configs - network-policy.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/network-policy.yaml)

## Pod Security Policies

Deprecated in newer versions of Kubernetes.

[HariSekhon/Kubernetes-configs - pod-security-policy.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/pod-security-policy.yaml)

## Governance, Security & Best Practices

Install [Polaris](https://www.fairwinds.com/polaris) for a recommendations dashboard full of best practices.

[HariSekhon/Kubernetes-configs - Polaris](polaris/base/)

## Find Deprecated API objects to replace

Run [Pluto](https://pluto.docs.fairwinds.com/) against your cluster before
[Kubernetes cluster upgrades](kubernetes-upgrades.md).

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
