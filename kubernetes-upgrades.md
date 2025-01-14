# Kubernetes Upgrades

Before you upgrade a Kubernetes cluster, you must ensure you won't break any existing apps running on it.

<!-- INDEX_START -->

- [Pre-Requisite Checks](#pre-requisite-checks)
  - [Check the Changlog](#check-the-changlog)
  - [Ensure Worker Nodes are Already Running the Same Version](#ensure-worker-nodes-are-already-running-the-same-version)
  - [Check for Deprecated API objects](#check-for-deprecated-api-objects)
    - [Pluto](#pluto)
    - [Kube-No-Trouble](#kube-no-trouble)
    - [Deprecated APIs Metrics](#deprecated-apis-metrics)
    - [Kubectl Convert](#kubectl-convert)
  - [Nova Outdated Helm Charts or Container Images](#nova-outdated-helm-charts-or-container-images)
  - [PSP - Pod Security Policies](#psp---pod-security-policies)
  - [Ensure High Availability](#ensure-high-availability)
    - [Pod Disruption Budgets](#pod-disruption-budgets)
    - [Topology Spread Constraints](#topology-spread-constraints)
  - [Ensure No Docker Socket Usage](#ensure-no-docker-socket-usage)
- [GoNoGo](#gonogo)
- [Kubepug](#kubepug)
- [Cluster Backup (optional)](#cluster-backup-optional)
- [Cluster Upgrade](#cluster-upgrade)
  - [Cluster AutoScaler](#cluster-autoscaler)
  - [AWS EKS Cluster Upgrade](#aws-eks-cluster-upgrade)
- [Verify Workloads](#verify-workloads)
- [Meme](#meme)

<!-- INDEX_END -->

## Pre-Requisite Checks

### Check the Changlog

To see what changed between versions:

[Kubernetes Changlog](https://github.com/kubernetes/kubernetes/tree/master/CHANGELOG)

### Ensure Worker Nodes are Already Running the Same Version

There is limited
[version skew](https://kubernetes.io/releases/version-skew-policy/#supported-versions)
between components, so check you aren't going to cut off your kubelets if they're running on an older version.

Compare the Master control plane version:

```shell
kubectl version
```

with the Worker nodes version:

```shell
kubectl get nodes
```

### Check for Deprecated API objects

[Kubernetes Deprecation Policy](https://kubernetes.io/docs/reference/using-api/deprecation-policy/)

Any apps using deprecated API objects will need to be upgraded first.

Check using more than one tool in case they give you slightly different results
as you can see below with Kubent and Pluto:

- [Pluto](#pluto)
- [Kubent](#kube-no-trouble)
- [Deprecated APIs Metrics](#deprecated-apis-metrics)
- [Kubectl Convert](#kubectl-convert)

#### Pluto

Install FairwindsOps [Pluto](https://pluto.docs.fairwinds.com/).

On Mac using [Homebrew](brew.md):

```shell
brew info pluto
```

Or latest GitHub release using [DevOps-Bash-tools](devops-bash-tools.md):

```shell
install_pluto.sh
```

```shell
pluto detect-all-in-cluster
```

```text
W0810 08:03:34.761332   12955 warnings.go:70] v1 ComponentStatus is deprecated in v1.19+
W0810 08:03:35.151381   12955 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
NAME                                                        KIND                VERSION                                REPLACEMENT                            REMOVED   DEPRECATED   REPL AVAIL
aws-node-termination-handler/aws-node-termination-handler   PodSecurityPolicy   policy/v1beta1                                                                true      true         false
eks.privileged                                              PodSecurityPolicy   policy/v1beta1                                                                true      true         false
eks-exempt                                                  FlowSchema          flowcontrol.apiserver.k8s.io/v1beta2   flowcontrol.apiserver.k8s.io/v1beta3   false     true         false
eks-workload-high                                           FlowSchema          flowcontrol.apiserver.k8s.io/v1beta2   flowcontrol.apiserver.k8s.io/v1beta3   false     true         false
```

Run also this script:

```shell
pluto_detect_kubectl_dump_objects.sh
```

which in my testing found different deprecated / removed API objects (see these Pluto issues:
[#461](https://github.com/FairwindsOps/pluto/issues/461),
[#495](https://github.com/FairwindsOps/pluto/issues/495),
and this [faq](https://pluto.docs.fairwinds.com/faq/#frequently-asked-questions)):

If you're using [Helm](helm.md) or [Kustomize](kustomize.md) and want to test your Git repo configs for deprecated
objects, run these scripts from the [DevOps-Bash-tools](devops-bash-tools.md) repo:

```shell
pluto_detect_helm_materialize.sh
```

```shell
pluto_detect_kustomize_materialize.sh
```

#### Kube-No-Trouble

Install [Kube-No-Trouble](https://github.com/doitintl/kube-no-trouble).

On Mac using [Homebrew](brew.md):

```shell
brew info kubent
```

Or latest GitHub release using [DevOps-Bash-tools](devops-bash-tools.md):

```shell
install_kubent.sh
```

Scan the current Kubernetes cluster for which your kubectl context is configured:

```shell
kubent
```

Output:

```text
8:51PM INF >>> Kube No Trouble `kubent` <<<
8:51PM INF version 0.7.3 (git sha 57480c07b3f91238f12a35d0ec88d9368aae99aa)
8:51PM INF Initializing collectors and retrieving data
8:51PM INF Target K8s version is 1.24.17-eks-7f9249a
8:51PM INF Retrieved 83 resources from collector name=Cluster
8:51PM INF Retrieved 24 resources from collector name="Helm v3"
8:51PM INF Loaded ruleset name=custom.rego.tmpl
8:51PM INF Loaded ruleset name=deprecated-1-16.rego
8:51PM INF Loaded ruleset name=deprecated-1-22.rego
8:51PM INF Loaded ruleset name=deprecated-1-25.rego
8:51PM INF Loaded ruleset name=deprecated-1-26.rego
8:51PM INF Loaded ruleset name=deprecated-1-27.rego
8:51PM INF Loaded ruleset name=deprecated-1-29.rego
8:51PM INF Loaded ruleset name=deprecated-1-32.rego
8:51PM INF Loaded ruleset name=deprecated-future.rego
__________________________________________________________________________________________
>>> Deprecated APIs removed in 1.25 <<<
------------------------------------------------------------------------------------------
KIND                NAMESPACE     NAME                           API_VERSION      REPLACE_WITH (SINCE)
PodSecurityPolicy   <undefined>   aws-node-termination-handler   policy/v1beta1   <removed> (1.21.0)
PodSecurityPolicy   <undefined>   eks.privileged                 policy/v1beta1   <removed> (1.21.0)
```

Notice the above output returns less than Pluto, because it is only listed APIs removed in the next version.

You get the complete results if you instead specified a much later version:

```shell
kubent --target-version 1.30
```

#### Deprecated APIs Metrics

You can get some raw info like this from metrics:

```shell
kubectl get --raw /metrics | grep apiserver_requested_deprecated_apis
```

```text
# HELP apiserver_requested_deprecated_apis [STABLE] Gauge of deprecated APIs that have been requested, broken out by API group, version, resource, subresource, and removed_release.
# TYPE apiserver_requested_deprecated_apis gauge
apiserver_requested_deprecated_apis{group="",removed_release="",resource="componentstatuses",subresource="",version="v1"} 1
apiserver_requested_deprecated_apis{group="policy",removed_release="1.25",resource="poddisruptionbudgets",subresource="",version="v1beta1"} 1
apiserver_requested_deprecated_apis{group="policy",removed_release="1.25",resource="podsecuritypolicies",subresource="",version="v1beta1"} 1
apiserver_requested_deprecated_apis{group="storage.k8s.io",removed_release="1.27",resource="csistoragecapacities",subresource="",version="v1beta1"} 1
```

#### Kubectl Convert

Use [kubectl convert](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-convert-plugin)
to update API objects in YAML manifests.

```shell
install_kubectl_plugin_convert.sh
```

```shell
kubectl convert -f file.yaml --output-version <group>/<version>
```

### Nova Outdated Helm Charts or Container Images

[:octocat: FairwindsOps/nova](https://github.com/FairwindsOps/nova)

You can use Nova to find outdated helm charts.

```shell
go install github.com/fairwindsops/nova@latest
```

or from [DevOps-Bash-tools](devops-bash-tools.md) repo:

```shell
install_nova.sh
```

```shell
nova find
```

```shell
nova find --containers
```

### PSP - Pod Security Policies

<https://docs.aws.amazon.com/eks/latest/userguide/pod-security-policy-removal-faq.html>

PSPs were removed in 1.25 and need to be migrated.

Find PSPs installed:

```shell
kubectl get psp
```

Check for pods which still use this annotation:

```shell
kubectl get pod -A \
    -o jsonpath='{range.items[?(@.metadata.annotations.kubernetes\.io/psp)]}{.metadata.name}{"\t"}{.metadata.namespace}{"\t"}{.metadata.annotations.kubernetes\.io/psp}{"\n"}' |
column -t
```

You can ignore `eks.privileged` - AWS EKS will automatically migrate that for you on upgrade.

### Ensure High Availability

Ensure High Availability of your Kubernetes apps to ensure they don't go down during rolling upgrade of worker nodes.

#### Pod Disruption Budgets

Ensure enough pods stay up at all times.

<https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets>

#### Topology Spread Constraints

Ensure the pods are spread so a worker node restart doesn't take down multiple replicas.

<https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/>

### Ensure No Docker Socket Usage

[:octocat: aws-containers/kubectl-detector-for-docker-socket](https://github.com/aws-containers/kubectl-detector-for-docker-socket)

If upgrading to Kubernetes 1.24, Docker socket usage is removed.

Find any pods still using Docker socket.

Install [Krew](kubernetes.md#krew---kubectl-plugin-manager) and then use it to install
[kubectl-detector-for-docker-socket](https://github.com/aws-containers/kubectl-detector-for-docker-socket):

```shell
kubectl krew install dds
```

and scan all pods for Docker socket usage:

```shell
kubectl dds
```

## GoNoGo

[:octocat: FairwindsOps/GoNoGo](https://github.com/FairwindsOps/GoNoGo)

From [DevOps-Bash-tools](devops-bash-tools.md):

```shell
install_gonogo.sh
```

```shell
gonogo check
```

```text
I0108 09:00:23.539295   11505 matches.go:101] releases that matched the config: [addons/metrics-server]
{
 "Addons": [
  {
   "Name": "metrics-server",
   "Versions": {
    "Current": "3.6.0",
    "Upgrade": "3.9.1"
   },
   "UpgradeConfidence": 0,
   "ActionItems": [
    {
     "ResourceNamespace": "addons",
     "ResourceKind": "",
     "ResourceName": "metrics-server",
     "Title": "Unsupported cluster version",
     "Description": "The Kubernetes cluster version is greater than the maximum version specified in the bundle spec",
     "Remediation": "",
     "EventType": "",
     "Severity": "",
     "Category": "",
     "Report": ""
    }
   ],
   "Notes": "https://github.com/kubernetes-sigs/metrics-server/releases/tag/v0.6.0",
   "Warnings": [
    "Chart RBAC uses nodes/metrics RBAC resource instead of nodes/stats. If you manage your own RBAC check your settings.",
    "no schema available, unable to validate release"
   ]
  }
 ]
}
```

## Kubepug

[:octocat: kubepug/kubepug](https://github.com/kubepug/kubepug)

Install [krew](kubernetes.md#krew---kubectl-plugin-manager) kubectl plugin manager first.

Then:

```shell
kubectl krew install deprecations
```

```shell
kubectl deprecations
```

Not effective, finds nothing, not even when specifying `--k8s-version=v1.25`,
despite Pluto and Kube-No-Problem finding deprecated APIs.

## Cluster Backup (optional)

See [Kubernetes - Cluster Backup](kubernetes.md#cluster-backup).

## Cluster Upgrade

1. Upgrade Master Control Plane nodes
1. Upgrade Workers nodes
1. Upgrade Add-Ons:
   1. [Core DNS](https://github.com/coredns/coredns)
   1. [Cluster Autoscaler](https://github.com/kubernetes/autoscaler/releases)
   1. [Metrics Server](https://kubernetes-sigs.github.io/metrics-server/)
   1. Karpenter [Upgrade Guide](https://karpenter.sh/docs/upgrading/upgrade-guide/) /
      [Compatability Matrix](https://karpenter.sh/docs/upgrading/compatibility/#compatibility-matrix)
   1. [Linkerd](https://github.com/linkerd/linkerd2)
   1. [Istio](https://github.com/istio/istio)

Check your node versions are upgraded to the same version as the control plane master nodes:

```shell
kubectl version
```

```shell
kubectl get nodes
```

as there can only be some
[version skew](https://kubernetes.io/releases/version-skew-policy/#supported-versions)
permitted between components, which for kubelet is 2-3 minor versions behind, but not ahead of apiserver.

### Cluster AutoScaler

If you want to find the latest versions of the cluster autoscaler that corresponds to your version of Kubernetes, then
you can find this on its [GitHub releases](pages)(https://github.com/kubernetes/autoscaler/releases) or
[ArtifactHub](https://artifacthub.io/packages/helm/cluster-autoscaler/cluster-autoscaler)

Automatically filter using [DevOps-Bash-tools](devops-bash-tools.md):

```shell
github_repo_latest_release_filter.sh kubernetes/autoscaler 1.28
```

Output at time of writing:

```text
1.28.7
```

or if you're looking for the latest chart (which you may override the image version using the above):

```shell
github_repo_latest_release_filter.sh kubernetes/autoscaler chart
```

Output at time of writing:

```shell
cluster-autoscaler-chart-9.45.0
```

Before and after applying the update, check the status and version of the cluster autoscaler:

```shell
kubectl get po -l 'app.kubernetes.io/name=aws-cluster-autoscaler'
```

```shell
kubectl get pods -l 'app.kubernetes.io/name=aws-cluster-autoscaler' -o yaml |
yq '.items[].spec.containers[].image'
```

### AWS EKS Cluster Upgrade

See the [EKS upgrade page](eks-upgrades.md) for AWS specific instructions.

## Verify Workloads

Check your pods are running ok:

```shell
kubectl get pods -A
```

Otherwise you'll be this meme...

## Meme

If you think you can skip these checks above, you may end up like this:

![K8s Upgrades Unresponsive Pods](images/k8s_upgrade_completed_78_pods_unresponsive.jpeg)
