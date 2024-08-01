# Kubernetes

## Local Dev

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) has a setting to enable Kubernetes, easiest to use
- [MiniKube](https://minikube.sigs.k8s.io/docs/start/)
- [MiniShift](https://github.com/minishift/minishift) - for OpenShift upstream [okd](https://www.okd.io/)
- [K3d](k3d.md) - quickly boots a [K3s](k3s.md) minimal kubernetes distro (fully functional)
- [Kind](kind.md) - Kubernetes-in-Docker - for testing Kubernetes and use in [CI/CD](ci-cd.md).
Examples of its use are in the [HariSekhon/Kubernetes-configs](https://github.com/HariSekhon/Kubernetes-configs)
GitHub Actions CI/CD workflows.

## Cloud

- AWS [EKS](eks.md)
- GCP [GKE](gke.md)
- Azure [AKS](aks.md)
- [Karpenter](karpenter.md) - open source cluster autoscaler for cloud (easier than using Auto Scaling
  Groups and the traditional cluster autoscaler below
- [Cluster Autoscaler](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler)

## On Premise

- [K3s](k3s.md)
- [Rancher](rancher.md)
- [RKE2](rke2.md)
- [Portworx](portworx.md)

## Machine Learning for Kubernetes

- [Kubeflow](https://www.kubeflow.org/)

## Kubernetes Configs

[HariSekhon/Kubernetes-configs](https://github.com/HariSekhon/Kubernetes-configs)

##### Security: most ingresses I write have IP filters to private addresses and Cloudflare Proxied IPs. You may need to expand this to VPN / office addresses, or the wider internet if you are running public services which really require direct public access without WAF proxied protection like Cloudflare

## Kubernetes Scripts

[DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools#kubernetes)
`kubernetes/` directory.

## Kubernetes `.envrc`

See [direnv](direnv.md)

## Kubernetes Networking

Kubernetes requires:

- all pods can communicate with each other across nodes
- all nodes can communicate with all pods
- no NAT

Kubeadm - must choose network up front. Can switch later but an awful lot of effort

### CNI - Container Network Interface

- standard for pluggable networking in Kubernetes
- configure with JSON, see here:
  https://github.com/containernetworking/cni

#### Flannel

- easiest but does not support network policies
- by CoreOS
- L3 IPv4
- several backends eg. VXLAN
- `flanneld` agent on each node allocates subnet leases for hosts

#### Calico

- flat L3 overlay network
- no IP encapsulation
- simple, flexible, scales well for large environments
- network policies
- Canal component integrates with Flannel
- used by Kubernetes, OpenShift, Docker, Mesos, OpenStack
- Felix agent on each host
- BIRD dynamic IP routing agent used by Felix - distributes routing info to other hosts
  calicoctl

#### Weavenet - by WeaveWorks

Legacy. Weaveworks has gone bankrupt now.

- policies

#### Kube-router

Single binary all-in-one LB, Firewall & Router for K8s

#### Romana

- aimed at large clusters
- integration with kops clusters
- IPAM-aware topology

#### Installing a CNI Plugin

Can create network using resource manifest for that network type, eg:

```shell
kubectl create -f https://git.io/weave-kube
```

#### Plugins by Feature

- allowing VXLan - Canal, Calico, Flannel, Kopeio-networking, WeaveNet
- Layer 2 - Canal, Flannel, Kopeio-networking, WeaveNet
- Layer 3 - Project Calico, Romana, Kube Router
- support Network Policies - Calico, Canal, Kube Router, Romana, WeaveNet (XXX: the rest will silently ignore any configured network policies!)
- can encrypt TCP/UDP traffic - Calico, Kopeio, Weave Net

### Network Troubleshooting

```shell
kubectl -n kube-system get pods
```

```shell
kubectl -n kube-system describe pod calico-node-xxxxx
```

To solve this:

```shell
Readiness probe failed: calico/node is not ready: BIRD is not ready: Failed to stat() nodename file: stat /var/lib/calico/nodename: no such file or directory
```

```shell
hostname -f > /var/lib/calico/nodename
```

```
Readiness probe failed: calico/node is not ready: BIRD is not ready: Error querying BIRD: unable to connect to BIRDv4 socket: dial unix /var/run/bird/bird.ctl: connect: no such file or directory
```

`bird` is run via containerd.

## Tips

- Ingresses:
  - use `name: http` for target instead of `number: 80` as some services use 80 and some 8080, so you'll get an HTTP 503 error if you get it wrong
  - compare the name and number to the service you're pointing to

## Troubleshooting

### Killing a Namespace that's stuck

If you see a namespace that is stuck deleting, you can force the issue at the risk of leaving some pods running:

```shell
kubectl delete ns "$NAMESPACE" --force --grace-period 0
```

Sometimes this isn't enough, and it gets stuck on finalizers or cert-manager pending challenges:

```
NAME                                                                STATE     DOMAIN                 AGE
challenge.acme.cert-manager.io/jenkins-tls-1-1371220808-214553451   pending   jenkins.domain.co.uk   3h1m
```

Use this script from [DevOps-Bash-tools](devops-bash-tools.md) `kubernetes/` directory which kills everything via API
patching:

```shell
kubernetes_delete_stuck_namespace.sh <namespace>
```

###### Partial port from private Knowledge Base page 2015+
