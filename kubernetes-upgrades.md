# Kubernetes Upgrades

Before you upgrade a Kubernetes cluster, you must ensure you won't break any existing apps running on it.

<!-- INDEX_START -->

- [Check for Deprecated API objects](#check-for-deprecated-api-objects)
  - [Kube-No-Trouble](#kube-no-trouble)
  - [Pluto](#pluto)
  - [Deprecated APIs Metrics](#deprecated-apis-metrics)
  - [Kubectl Convert](#kubectl-convert)
- [PSP - Pod Security Policies](#psp---pod-security-policies)
- [Cluster Upgrade](#cluster-upgrade)
  - [AWS EKS Cluster Upgrade](#aws-eks-cluster-upgrade)
- [Meme](#meme)

<!-- INDEX_END -->

## Check for Deprecated API objects

Any apps using deprecated API objects will need to be upgraded first.

Check using more than one tool in case they give you slightly different results
as you can see below with Kubent and Pluto:

- [Kubent](#kube-no-trouble)
- [Pluto](#pluto)
- [Deprecated APIs Metrics](#deprecated-apis-metrics)
- [Kubectl Convert](#kubectl-convert)

### Kube-No-Trouble

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

### Pluto

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

### Deprecated APIs Metrics

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

### Kubectl Convert

Use [kubectl convert](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-convert-plugin)
to update API objects in YAML manifests.

```shell
install_kubectl_plugin_convert.sh
```

```shell
kubectl convert -f file.yaml --output-version <group>/<version>
```

## PSP - Pod Security Policies

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

## Cluster Upgrade

1. Upgrade Master Control Plane nodes
1. Upgrade Workers nodes
1. Upgrade Add-Ons:
   1. [Core DNS](https://github.com/coredns/coredns)
   1. Cluster [Autoscaler](https://github.com/kubernetes/autoscaler/releases) /
      [Karpenter](https://karpenter.sh/docs/upgrading/upgrade-guide/)

### AWS EKS Cluster Upgrade

See the [EKS page upgrade section](eks.md#eks-cluster-upgrade) for AWS specific instructions.

## Meme

If you think you can skip these checks above, you may end up like this:

![K8s Upgrades Unresponsive Pods](images/k8s_upgrade_completed_78_pods_unresponsive.jpeg)
