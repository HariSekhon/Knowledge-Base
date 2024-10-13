# K3d

<https://k3d.io/>

Wrapper CLI that runs [K3s](k3s.md) in Docker (this is also a workaround for k3s not being available on Mac arm64 yet).

- create/grows/shrink k3s clusters via CLI
- manage Kubeconfigs for the k3s clusters

<!-- INDEX_START -->

- [Template Config](#template-config)
- [Commands](#commands)
- [KubeConfig](#kubeconfig)

<!-- INDEX_END -->

## Template Config

[HariSekhon/Templates - k3d.yaml](https://github.com/HariSekhon/Templates/blob/master/k3d.yaml)

## Commands

```shell
k3d cluster create test  # default name: 'default'
```

```text
INFO[0000] Prep: Network
INFO[0000] Created network 'k3d-test'
INFO[0000] Created image volume k3d-test-images
INFO[0000] Starting new tools node...
INFO[0000] Starting Node 'k3d-test-tools'
INFO[0001] Creating node 'k3d-test-server-0'
INFO[0001] Creating LoadBalancer 'k3d-test-serverlb'
INFO[0001] Using the k3d-tools node to gather environment information
INFO[0001] Starting new tools node...
INFO[0001] Starting Node 'k3d-test-tools'
INFO[0002] Starting cluster 'test'
INFO[0002] Starting servers...
INFO[0002] Starting Node 'k3d-test-server-0'
INFO[0006] All agents already running.
INFO[0006] Starting helpers...
INFO[0006] Starting Node 'k3d-test-serverlb'
INFO[0012] Injecting records for hostAliases (incl. host.k3d.internal) and for 3 network members into CoreDNS configmap...
INFO[0014] Cluster 'test' created successfully!
INFO[0015] You can now use it like this:
kubectl cluster-info
```

```shell
k3d node list
```

```text
NAME                   ROLE           CLUSTER   STATUS
k3d-default-server-0   server         default   running
k3d-default-serverlb   loadbalancer   default   running
k3d-default-tools                     default   running
```

```shell
k3d registry list
```

```text
NAME   ROLE   CLUSTER   STATUS
```

```shell
k3d cluster list
```

```text
NAME      SERVERS   AGENTS   LOADBALANCER
default   1/1       0/0      true
```

Add node (only works if cluster was created with more than 1 server or `--cluster-init` flag):

```shell
k3d node create "$servername" --cluster "$name" --role server
```

Shut down the k3s cluster docker containers when you don't need them:

```shell
k3d cluster stop
```

Start them back up:

```shell
k3d cluster start
```

Push a locally built docker image into the internal registry:

```shell
k3d image import "$DOCKER_IMAGE":"$DOCKER_TAG"
```

## KubeConfig

Writes to `$HOME/.k3d/kubeconfig-mycluster.yaml`

```shell
k3d kubeconfig write "$name"
```

```shell
export KUBECONFIG=$(k3d kubeconfig write "$name")
```

```shell
k3d kubeconfig get "$name:" > k3d-"$name".yaml  # --all
```

Add to `$KUBECONFIG` file:

```shell
k3d kubeconfig merge "$name" --kubeconfig-merge-default  # --all
```

```shell
k3d kubeconfig merge "$name" --output /some/other/file.yaml
```

**Ported from private Knowledge Base page 2023+**
