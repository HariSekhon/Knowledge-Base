# Kustomize

[Kustomize](https://kustomize.io/) is the standard build tool for Kubernetes manifest aggregation and patching.

<!-- INDEX_START -->

- [Install](#install)
- [Commands](#commands)
- [ArgoCD](#argocd)
- [Template `kustomization.yaml`](#template-kustomizationyaml)
- [Kubernetes Kustomizations and Configs](#kubernetes-kustomizations-and-configs)

<!-- INDEX_END -->

## Install

```shell
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
```

## Commands

`cd` to a directory with `kustomization.yaml`, then run:

```shell
kustomize build
```

if your `kustomization.yaml` include the helmCharts operator you must specify the `--enable-helm` switch:

```shell
kustomize build --enable-helm
```

compare changes to currently loaded manifests in the cluster:
```shell
kustomize build --enable-helm | kubectl diff -f -
```

apply the yaml manifests:
```shell
kustomize build --enable-helm | kubectl apply -f -
```

Newer versions of `kubectl` have kustomize built-in, just specify `-k` to activate

eg.

```shell
kubectl diff -k .
```
but this is weaker than using standalone `kustomize` but `kubectl` doesn't use the `--enable-helm` switch so fails on
Kustomizations which pull in Helm charts:
```yaml
error: accumulating resources: accumulation err='accumulating resources from '../base': '/Users/hari/github/k8s/jenkins/base' must resolve to a file': recursed accumulation of path '/Users/hari/github/k8s/jenkins/base': trouble configuring builtin HelmChartInflationGenerator with config: `
includeCRDs: true
name: jenkins
namespace: jenkins
releaseName: jenkins
repo: https://charts.jenkins.io
valuesFile: values.yaml
version: 4.12.1
`: must specify --enable-helm
```

## ArgoCD

Once you have this working, you should be getting your [ArgoCD](argocd.md) to automatically apply your Kustomize +
Helm manifests.

This makes Helm becomes fully self-healing GitOps.

## Template `kustomization.yaml`

[HariSekhon/Kubernetes-configs - kustomization.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/kustomization.yaml)

## Kubernetes Kustomizations and Configs

[HariSekhon/Kubernetes-configs](https://github.com/HariSekhon/Kubernetes-configs) repo.

**Partial port from private Knowledge Base page 2020+**
