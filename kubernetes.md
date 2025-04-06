# Kubernetes

<!-- INDEX_START -->

- [Local Dev](#local-dev)
- [Cloud](#cloud)
- [On Premise](#on-premise)
- [Machine Learning](#machine-learning)
- [Configs](#configs)
- [Scripts](#scripts)
- [`.envrc`](#envrc)
- [Scheduling](#scheduling)
- [Networking](#networking)
  - [CNI - Container Network Interface](#cni---container-network-interface)
    - [Flannel](#flannel)
    - [Calico](#calico)
    - [Weavenet - by WeaveWorks](#weavenet---by-weaveworks)
    - [Kube-router](#kube-router)
    - [Romana](#romana)
    - [Installing a CNI Plugin](#installing-a-cni-plugin)
    - [Plugins by Feature](#plugins-by-feature)
  - [Network Troubleshooting](#network-troubleshooting)
- [Ingress](#ingress)
  - [Ingress Controllers](#ingress-controllers)
- [Autoscaling](#autoscaling)
  - [HPA - Horizontal Pod Autoscaler](#hpa---horizontal-pod-autoscaler)
  - [VPA - Vertical Pod Autoscaler](#vpa---vertical-pod-autoscaler)
  - [KEDA - Kubernetes Event-Driven Autoscaling](#keda---kubernetes-event-driven-autoscaling)
- [Tips](#tips)
  - [K9s](#k9s)
  - [Kubecolor](#kubecolor)
  - [Increase StatefulSet disk size](#increase-statefulset-disk-size)
  - [Quick Port-Forwarding to a Pod](#quick-port-forwarding-to-a-pod)
  - [Krew - Kubectl Plugin Manager](#krew---kubectl-plugin-manager)
- [Cluster Backup](#cluster-backup)
- [Troubleshooting](#troubleshooting)
  - [Capture Pod Logs & Stats](#capture-pod-logs--stats)
  - [Killing a Namespace that's stuck](#killing-a-namespace-thats-stuck)

<!-- INDEX_END -->

## Local Dev

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) has a setting to enable Kubernetes, easiest to use
- [MiniKube](https://minikube.sigs.k8s.io/docs/start/)
- [MiniShift](https://github.com/minishift/minishift) - for OpenShift upstream [okd](https://www.okd.io/)
- [K3d](k3d.md) - quickly boots a [K3s](k3s.md) minimal kubernetes distro (fully functional)
- [Kind](kind.md) - Kubernetes-in-Docker - for testing Kubernetes and use in [CI/CD](cicd.md).
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

## AI & Machine Learning

- [K8sGPT](https://k8sgpt.ai/)
- [Kubeflow](https://www.kubeflow.org/)

## Configs

[HariSekhon/Kubernetes-configs](https://github.com/HariSekhon/Kubernetes-configs)

**Security: most ingresses I write have IP filters to private addresses and Cloudflare Proxied IPs. You may need to expand this to VPN / office addresses, or the wider internet if you are running public services which really require direct public access without WAF proxied protection like Cloudflare**

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Kubernetes-configs&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Kubernetes-configs)

## Scripts

[DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools#kubernetes)
`kubernetes/` directory.

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=DevOps-Bash-tools&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/DevOps-Bash-tools)

## `.envrc`

See [direnv](direnv.md)

## Scheduling

Kubernetes node size is important and a trade-off of efficiency -
too small and you won't be able to fit the requested pod for an application or batch job on the new node vs
too big leaves the rest of the node's resources unutilized - for which you're paying cloud billing.

If the app resources more resources than a new node size,
the scheduler will realize that even spinning up a new node of the configured size won't be enough to run the app / job
and it will become stuck in an unschedulable state.

## Networking

Kubernetes requires:

- all pods can communicate with each other across nodes
- all nodes can communicate with all pods
- no NAT

Kubeadm - must choose network up front. Can switch later but an awful lot of effort

### CNI - Container Network Interface

- standard for pluggable networking in Kubernetes
- configure with JSON, see here:
  [:octocat: containernetworking/cni](https://github.com/containernetworking/cni)

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

```text
Readiness probe failed: calico/node is not ready: BIRD is not ready: Error querying BIRD: unable to connect to BIRDv4 socket: dial unix /var/run/bird/bird.ctl: connect: no such file or directory
```

`bird` is run via containerd.

## Ingress

### Ingress Controllers

Set up a stable HTTPS entrypoint to your apps with DNS and SSL.

- [Nginx](https://kubernetes.github.io/ingress-nginx/) ([config](https://github.com/HariSekhon/Kubernetes-configs/blob/master/ingress-nginx/base/))
- [Kong](https://konghq.com/) ([config](https://github.com/HariSekhon/Kubernetes-configs/blob/master/kong/base/))
- [Traefik](https://traefik.io/traefik/) ([config](https://github.com/HariSekhon/Kubernetes-configs/blob/master/traefik/base/))
- [HAProxy](https://haproxy.org/) ([config](https://github.com/HariSekhon/Kubernetes-configs/blob/master/haproxy))
- [Ambassador](https://getambassador.io/)

## Autoscaling

Scales by adjusting the number of requested replicas in Deployments or Statefulsets.

### HPA - Horizontal Pod Autoscaler

- v1 - scale on a simple rudimentary metric like pod average % utilization
- v2 - scale on multiple metrics
  - unfortunatately [ArgoCD does not support v2 yet](https://github.com/argoproj/argo-cd/issues/9145)

### VPA - Vertical Pod Autoscaler

Monitors the pod resource usage, gives recommendations for right-sizing, can adjust the resource requests.

### KEDA - Kubernetes Event-Driven Autoscaling

[KEDA](https://keda.sh/) autoscales on more practical accurate metrics like requests per second.

## Tips

- Ingresses:
  - use `name: http` for target instead of `number: 80` as some services use 80 and some 8080, so you'll get an HTTP 503 error if you get it wrong
  - compare the name and number to the service you're pointing to

### K9s

<https://k9scli.io/>

### Kubecolor

[:octocat: kubecolor/kubecolor](https://github.com/kubecolor/kubecolor)

<https://kubecolor.github.io/>

### Increase StatefulSet disk size

See [Jenkins-on-Kubernetes](jenkins-on-kubernetes.md#increase-jenkins-server-disk-space-on-kubernetes) doc
for a real world example.

### Quick Port-Forwarding to a Pod

In most cases you should `kubectl port-forward` to a service, but in cases where you need a specific pod or no service
is available, such as [Spark-on-Kubernetes](spark.md) or other batch jobs, this is a real convenience.

From [DevOps-Bash-tools](devops-bash-tools.md) repo, gives an interactive list of pods which can be pre-filtered by name
or label arg, and can automatically open the forwarded localhost URL:

```shell
kubectl_port_forward.sh
```

eg.

```shell
kubectl_port_forward.sh "$NAMESPACE" spark-role=driver
```

For [Spark-on-Kubernetes](spark.md) jobs, this sub-script variant already includes the `spark-role=driver` label filter
to make the command shorter:

```shell
kubectl_port_forward_spark.sh "$NAMESPACE"
```

### Krew - Kubectl Plugin Manager

[:octocat: https://github.com/kubernetes-sigs/krew](kubernetes-sigs/krew)

<https://krew.sigs.k8s.io/>

Installs and updates `kubectl` plugins.

From [DevOps-Bash-tools](devops-bash-tools.md):

```shell
install_kubectl_plugin_krew.sh
```

Usage instructions:

[Krew Quickstart User Guide](https://krew.sigs.k8s.io/docs/user-guide/quickstart/)

## Cluster Backup

[:octocat: vmware-tanzu/velero](https://github.com/vmware-tanzu/velero)

## Troubleshooting

### Capture Pod Logs & Stats

From [DevOps-Bash-tools](devops-bash-tools.md) repo,
run `--help` on each script if you need to specify namespace or pod name regex filter:

```shell
kubectl_pods_dump_stats.sh
```

```shell
kubectl_pods_dump_logs.sh
```

Then tar the local outputs to send to the support team eg. for [Informatica](informatica.md) support:

```shell
tar czvf "support-bundle-$(date '+%F_%H%M').tar.gz" \
         "kubectl-pod-stats.$(date '+%F')_"*.txt \
         "kubectl-pod-log.$(date '+%F')_"*.txt
```

### Killing a Namespace that's stuck

If you see a namespace that is stuck deleting, you can force the issue at the risk of leaving some pods running:

```shell
kubectl delete ns "$NAMESPACE" --force --grace-period 0
```

Sometimes this isn't enough, and it gets stuck on finalizers or cert-manager pending challenges:

```text
NAME                                                                STATE     DOMAIN                 AGE
challenge.acme.cert-manager.io/jenkins-tls-1-1371220808-214553451   pending   jenkins.domain.co.uk   3h1m
```

Use this script from [DevOps-Bash-tools](devops-bash-tools.md) `kubernetes/` directory which kills everything via API
patching:

```shell
kubernetes_delete_stuck_namespace.sh <namespace>
```

**Partial port from private Knowledge Base page 2015+**
