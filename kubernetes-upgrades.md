## Kubernetes Upgrades

Before you upgrade a Kubernetes cluster, you must ensure you won't break any existing apps running on it.

### Check for Deprecated API objects

Any apps using deprecated API objects will need to be upgraded first.

Install FairwindsOps [Pluto](https://pluto.docs.fairwinds.com/).

Quickly using [DevOps-Bash-tools](devops-bash-tools.md):

```shell
install_pluto.sh
```

```shell
pluto detect-all-in-cluster
```

```
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

### PSP - Pod Security Policies

<https://docs.aws.amazon.com/eks/latest/userguide/pod-security-policy-removal-faq.html>

PSPs were removed in 1.25 and need to be migrated.

Find PSPs installed

```shell
kubectl get psp
```

Check for pods which still use this annotation:

```shell
kubectl get pod -A \
    -o jsonpath='{range.items[?(@.metadata.annotations.kubernetes\.io/psp)]}{.metadata.name}{"\t"}{.metadata.namespace}{"\t"}{.metadata.annotations.kubernetes\.io/psp}{"\n"}' |
column -t
```
