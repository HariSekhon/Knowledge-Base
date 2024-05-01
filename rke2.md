# RKE - Rancher Kubernetes Engine

This is a locally installable Kubernetes distribution bundling [k3s](k3s.md) and other components.

https://docs.rke2.io/

### CLI - Kubectl Kubeconfig

On an RKE2 node you can do:

```shell
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
```

Now run `kubectl` commands as per usual.
