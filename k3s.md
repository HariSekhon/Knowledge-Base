# K3s

<https://k3s.io/>

<!-- INDEX_START -->

- [Key Points](#key-points)
- [QuickStart](#quickstart)
  - [Install](#install)
  - [Add agent](#add-agent)
- [Server & Agent](#server--agent)
- [Modes](#modes)
- [Install Agents](#install-agents)
- [Install Kubernetes Dashboard](#install-kubernetes-dashboard)
- [Shut down K3s](#shut-down-k3s)

<!-- INDEX_END -->

## Key Points

- lightweight k8s compatible implementation
- single 70MB binary kubernetes distro
- built for IoT & Edge computing, good for CI, embedded etc.
- low resource usage < 512MB RAM
- even installs on Raspberry Pi
- created by Rancher and now part of CNCF - the only CNCF k8s distro
- uses a docker image from k3s repo to spin up K3s nodes in [Docker](docker.md)
- uses SQLite backend by default
- etcd3, MySQL, Postgres backends available
- secure by default
- bundles:
  - containerd
  - Flannel (CNI)
  - CoreDNS
  - Traefik Proxy (Ingress)
  - Service LB (the component formerly known as Klipper)
    - must `--disable servicelb` to use MetalLB instead
  - `HelmChart` & `HelmChartConfigs` CRDs
  - Embedded network policy controller
  - Embedded local-path-provisioner
  - Host utilities (`iptables`, `socat` etc.)
- K3s service configures on systemd or openrc based systems to start automatically
- installs `kubectl`, `crictl`, `ctr`, `k3s-killall.sh`, and `k3s-uninstall.sh`
- kubeconfig file written to `/etc/rancher/k3s/k3s.yaml`
  - `kubectl` installed by k3s will automatically use this

## QuickStart

### Install

```shell
curl -sfL https://get.k3s.io | sh
sleep 30
k3s kubectl get node
```

### Add agent

Set `K3S_NODE_NAME` environment variable if don't have unique hostnames:

```shell
curl -sfL https://get.k3s.io | K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken sh -
```

## Server & Agent

Both server + agent run kubelet, container runtime and CNI

```shell
k3s server  # runs control-plane and datastore components
```

```shell
k3s agent
```

Any yamls under here are created/updated but not removed:

```text
/var/lib/rancher/k3s/server/manifests/ccm.yaml
/var/lib/rancher/k3s/server/manifests/coredns.yaml
/var/lib/rancher/k3s/server/manifests/local-storage.yaml
/var/lib/rancher/k3s/server/manifests/metrics-server.yaml
/var/lib/rancher/k3s/server/manifests/rolebindings.yaml
/var/lib/rancher/k3s/server/manifests/traefik.yaml
```

## Modes

- Single Server - embedded SQLite DB - can still connect several other agents to server but no control-plane HA
- HA K3s - 3+ servers - embedded Etcd (3+ masters)
- 2+ Servers - external datastore Etcd / MySQL / Postgres

Agent uses `--server <seed_node>` registration address to get the list of masters and then connects to all of them for resilience.

Agent registers to server using cluster secret + sends agent's own generated secret `/etc/rancher/node/password`.

Server stores the agent's secret in `kube-system` namespace as `<host>.node-password.k3s`.

Run this on each master to install it:

Old used MySQL like so, do it with Etcd now instead of this:

```shell
export K3S_DATASTORE_ENDPOINT="mysql://k3s:$$K3S_MYSQL_PASSWORD@$MYSQL_HOST:3306/k3s"
```

```shell
curl -sfL https://get.k3s.io | sh -s - server --node-taint CriticalAddOnsOnly:NoExecute --tls-san "$IP_ADDRESS"
```

Show master:

```shell
k3s kubectl get node
```

To add more servers, get token from any server - grants full administrative access to the cluster:

```shell
sudo cat /var/lib/rancher/k3s/server/token
```

and export it:

```shell
export K3S_TOKEN=...
```

Get token to install agents - if this wasn't specified this is just a symlink to `server-token`:

```shell
sudo cat /var/lib/rancher/k3s/server/agent-token
```

```shell
export K3S_AGENT_TOKEN=...  # above output
```

Newer releases can use `k3s token` for dynamic expiring tokens (can only be used to join agents):

```shell
k3s token create
```

```shell
export KUBECONFIG="/etc/rancher/k3s/k3s.yaml"
```

```shell
kubectl get node
```

## Install Agents

Run this on each agent to install it.

`K3S_URL` tells the <https://get.k3s.io> script to install agent:

```shell
export K3S_URL=https://192.168.1.10:6443
export K3S_TOKEN="..."  # from cat command above
```

```shell
curl -sfL https://get.k3s.io | sh -s - server --node-taint CriticalAddOnsOnly:NoExecute --tls-san 192.168.1.10
```

See masters and agents:

```shell
k3s kubectl get node
```

```shell
sudo cat /etc/rancher/k3s/k3s.yaml | sed "s/127.0.0.1/$YOUR_LB_IP_TO_K3S_MASTERS/" >> ~/.kube/config
```

## Install Kubernetes Dashboard

[HariSekhon/Kubernetes-configs - kubernetes-dashboard](https://github.com/HariSekhon/Kubernetes-configs/blob/master/kubernetes-dashboard/)

## Shut down K3s

```shell
/usr/local/bin/k3s-killall.sh
```

**Ported from private Knowledge Base page 2019+**
