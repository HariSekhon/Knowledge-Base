# Rancher

Rancher is a dashboard UI for managing Kubernetes clusters.

You can manage both on-premise clusters, eg. installed with [RKE2](rke2.md) kubernetes distribution,
or cloud clusters like [AWS EKS](eks.md) (I've done both).

<!-- INDEX_START -->

- [Install Rancher](#install-rancher)
- [Rancher CLI](#rancher-cli)
  - [Command Reference](#command-reference)
  - [Example usage](#example-usage)
  - [Kubectl UI Shell](#kubectl-ui-shell)
  - [Set up local `kubectl` - Download Rancher Kubeconfig](#set-up-local-kubectl---download-rancher-kubeconfig)
- [Rancher Fleet](#rancher-fleet)

<!-- INDEX_END -->

## Install Rancher

Ready to install Kustomize + Helm:

[HariSekhon/Kubernetes-configs - rancher/](https://github.com/HariSekhon/Kubernetes-configs/tree/master/rancher)

## Rancher CLI

[Install & authenticate doc](https://ranchermanager.docs.rancher.com/reference-guides/cli-with-rancher/rancher-cli).

Automated in [DevOps-Bash-tools](devops-bash-tools.md) repo:

```shell
install_rancher_cli.sh
```

Create an API token at [https://$RANCHER_HOST/dashboard/account](https://$RANCHER_HOST/dashboard/account).

Export environment variables for the newly created access key and secret key:

```shell
export RANCHER_HOST=...
export RANCHER_ACCESS_KEY=...
export RANCHER_SECRET_KEY=...
```

Authenticate the Rancher CLI:

```shell
rancher login "https://$RANCHER_HOST" --token "$RANCHER_ACCESS_KEY:$RANCHER_SECRET_KEY"
```

You'll be prompted for a project.

See the list of servers you're logged in to:

```shell
rancher server ls
```

Show the current cluster/project context:

```shell
rancher context current
```

Switch to another project in Rancher, will prompt with a list of projects:

```shell
rancher context switch
```

Show Rancher settings:

```shell
rancher settings ls
```

To get just a single setting, eg. to retrieve the rancher server version:

```shell
rancher settings get server-version
```

Get Rancher server version using json format to parse and extract just the value field containing the version string:

```shell
rancher settings get server-version -o json | jq -r '.Setting.value'
```

### Command Reference

<https://ranchermanager.docs.rancher.com/reference-guides/cli-with-rancher/rancher-cli#commands>

```shell
rancher --help
```

### Example usage

Tip: you can leave the `ls` off several of the commands to list clusters, nodes / machines, namespaces etc.,
but not server.

List clusters:

```shell
rancher clusters  # ls
```

List projects:

```shell
rancher projects ls
```

List servers on the currently selected cluster:

```shell
rancher nodes  # ls
```

List servers across all clusters and their status:

```shell
rancher machines  # ls
```


- unfortunately neither of these above two commands list the RKE2 versions on each node like the UI does
- the `ID` column has different contents between `nodes` and `machines` commands
- `nodes` shows a `State` column (eg. `active`/`cordoned`) as well as two additional fields `Pool` and `Description`
which may be empty, while `machines` shows a `Phase` field which contains `Running`/`Provisioning`

Show workloads in the current project:

```shell
rancher ps
```

Show namespaces:

```shell
rancher namespaces  # ls
```

Run kubectl proxied commands (slow):

```shell
rancher kubectl ...
```

List pods via kubectl:

```shell
rancher kubectl get pods -A
```

Faster is to download the kubeconfig and use direct kubectl.

### Kubectl UI Shell

There is a Kubectl shell in the top right of the Rancher UI (```Ctrl-` ``` keyboard shortcut).

The problem with this shell is that it is for beginner / light use only.

You'll get 1/3 to 2/3 of a web page shell height without localized shell environment and
[DevOps-Bash-tools](devops-bash-tools.md) scripts to make it easier to work with Kubernetes.

It'll also cut out on you if you have a network wifi change.

Set up your local `kubectl` kubeconfig instead for serious usage.

### Set up local `kubectl` - Download Rancher Kubeconfig

You can download the kubeconfig for a cluster from the UI, see the `Download Kubeconfig` button on the top right.

Using script in [DevOps-Bash-tools](devops-bash-tools.md), download all kubeconfigs to a directory structure with
`.envrc` in each directory to auto-load them via a simple `cd` to each directory:

```shell
rancher_kube_creds.sh
```

## Rancher Fleet

Fleet [documentation](https://fleet.rancher.io/).

- CRDS + Controller to pull Kubernetes yaml from Git
- dynamically converts to Helm charts to deploy. Is this actually idempotent like ArgoCD / FluxCD?

Has a separate chart repo to Rancher:

```shell
brew install helm
```
```shell
helm repo add fleet https://rancher.github.io/fleet-helm-charts/
```

Install Fleet:

```shell
helm -n cattle-fleet-system install --create-namespace --wait fleet-crd fleet/fleet-crd
```

```shell
helm -n cattle-fleet-system install --create-namespace --wait fleet fleet/fleet
```

Get fleet status:

```shell
kubectl -n fleet-local get fleet
```
