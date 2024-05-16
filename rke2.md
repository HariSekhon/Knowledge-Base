# RKE - Rancher Kubernetes Engine

This is a locally installable Kubernetes distribution bundling [k3s](k3s.md) and other components.

https://docs.rke2.io/

### RKE2 Versions vs Kubernetes Versions

**RKE2 versions match Kubernetes versions.**

Kubernetes versions are important for API object compatibility as Kubernetes is often changing/deprecating/removing
objects they support between versions over the years, which breaks applications that are not upgraded to support the
corresponding Kubernetes API version.

RKE2 versions are prefixed to align with Kubernetes versions eg. RKE2 `v1.28.9+rke2r1` will install Kubernetes `v1.28.9`.

### CLI - Kubectl Kubeconfig

On an RKE2 node you can do:

```shell
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
```

Now run `kubectl` commands as per usual.
