# Portworx - Kubernetes Storage

- clustered storage for [Kubernetes](kubernetes.md) persistent volumes
- Freemium 5 node version

### Install

[Install on Rancher](https://docs.portworx.com/portworx-enterprise/platform/kubernetes/rancher/install) doc.

Config file:

```
/etc/pwx/config.json
```

Environment variables:

```
/etc/pwx/pw_env
```

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
ADMIN_TOKEN=$(kubectl -n $NAMESPACE get secret px-admin-token -o jsonpath='{.data.auth-token}' | base64 -d)
```


### Portworx CLI

From [install](https://docs.portworx.com/portworx-enterprise/platform/kubernetes/rancher/install) doc:

You need to find and exec into a Kubernetes pod to run the `pxctl` CLI.

Find a portworx pod:

```shell
PORTWORX_POD=$(kubectl get pods -n "$PORTWORX_NAMESPACE" -l name=portworx | awk '{print $1; exit}')
```

Exec into the found pod:

```shell
kubectl exec "$PX_CLUSTER_POD" -n "$PORTWORX_NAMESPACE" -- /bin/bash
```

#### Inside the Pod

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

