# Kind - Kubernetes in Docker

<https://kind.sigs.k8s.io/>

Useful for CI/CD testing.

You can see this used in my GitHub Actions for repo [HariSekhon/Kubernetes-configs](https://github.com/HariSekhon/Kubenretes-configs), used for testing the yaml configurations on a live test kubernetes cluster.

<!-- INDEX_START -->

- [Install](#install)
- [Create Cluster](#create-cluster)
  - [Create using a config](#create-using-a-config)
- [Commands](#commands)

<!-- INDEX_END -->

## Install

From [DevOps-Bash-tools](devops-bash-tools.md) repo:

```shell
install_kind.sh
```

## Create Cluster

Creates with name `kind`, waits for 5 mins until control plane becomes available:

```shell
kind create cluster --name 'kind' --wait 5m
```

### Create using a config

[HariSekhon/Templates - kind.yaml](https://github.com/HariSekhon/Templates/blob/master/kind.yaml)

Tip: be careful not to do this in an isolated `KUBECONFIG` where the context will then be lost (eg. the fancy [direnv](direnv.md) `.envrc-kubernetes` from my repos):

```shell
kind create cluster --config="$templates/kind.yaml"
```

## Commands

To recover the local isolated kube config (will ruin the other contexts though):

```shell
kind get kubeconfig --name knative >> "$KUBECONFIG"
```

```shell
kind get clusters
```

```shell
kind delete cluster
```

Copy locally built docker image into Kind cluster:

```shell
kind load docker-image "$DOCKER_IMAGE":"$TAG"
```

Get list of images - may need to replace 'kind' with name of the cluster:

```shell
docker exec -it 'kind-control-plane' crictl images
```

```shell
kind export logs  # ./somedir
```

```text
Exported logs to: /tmp/396758314
```

**Ported from private Knowledge Base pages 2023+**
