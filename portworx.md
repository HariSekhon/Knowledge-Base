# Portworx - Kubernetes Storage

- Portworx Enterprise - clustered software defined storage (SDS) for [Kubernetes](kubernetes.md) persistent volumes
  - Freemium 5 node version
- Portworx Data Services - SaaS control plane to administer multiple Kubernetes clusters using Portworx Enterprise
  - Control Plane - UI, API, and a catalog of data services
  - 2 x K8s extensions:
    - deployment operator

<!-- INDEX_START -->
  - [Portworx Enterprise Install](#portworx-enterprise-install)
  - [Administration](#administration)
  - [Portworx CLI](#portworx-cli)
<!-- INDEX_END -->

### Portworx Enterprise Install

[Install on Rancher](https://docs.portworx.com/portworx-enterprise/platform/kubernetes/rancher/install) doc.

Config file:

```
/etc/pwx/config.json
```

Environment variables:

```
/etc/pwx/pw_env
```

### Administration

Set the Portworx namespace variable for use in future commands:

```shell
export PORTWORX_NAMESPACE=portworx
```

or infer it from whichever namespace has the storage controller, assuming only one on cluster:

```shell
PORTWORX_NAMESPACE=$(kubectl get stc -A -o jsonpath='{.items[].metadata.namespace}' | head -n 1)
```

If you're on Rancher, set your kube config:

```shell
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
```
Optionally alias `kubectl` to the Rancher version:
```shell
alias kubectl=/var/lib/rancher/rke2/bin/kubectl
```

Show all Portworx pods:

```shell
kubectl get pods -n "$PORTWORX_NAMESPACE" -o wide | grep -e portworx -e px
```

Get the admin token:

```shell
ADMIN_TOKEN=$(kubectl -n "$PORTWORX_NAMESPACE" get secret px-admin-token -o jsonpath='{.data.auth-token}' | base64 -d)
```


### Portworx CLI

From [install](https://docs.portworx.com/portworx-enterprise/platform/kubernetes/rancher/install) doc:

You can run the `pxctl` CLI from a portworx node or inside a Kubernetes portworx pod.

Find a portworx pod:

```shell
PORTWORX_POD=$(kubectl get pods -o name -l name=portworx -n "$PORTWORX_NAMESPACE" | head -n 1 | sed 's|^pod/||')
```

Exec into the found pod:

```shell
kubectl exec -ti "$PORTWORX_POD" -n "$PORTWORX_NAMESPACE" -- /bin/bash
```

#### Inside the Pod or a server with Portworx installed

```shell
export PATH="$PATH:/opt/pwx/bin"
```

Verify cluster status:

```shell
pxctl status
```

```shell
kubectl get storagecluster -n "$PORTWORX_NAMESPACE"
```
