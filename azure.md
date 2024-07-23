# Azure

## DevOps Bash tools for Azure, AKS, VMs etc

[HariSekhon/DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools)

## Install Azure CLI

Follow the [install doc](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) or paste this to run an automated install script
which auto-detects and handles Mac or Linux:

```shell
git clone https://github.com/HariSekhon/DevOps-Bash-tools
```

```shell
bash-tools/install/install_azure_cli.sh
```

Then authenticate using one of the [documented methods](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli) eg:
```shell
az login
```

## Set up access to AKS - Azure Kubernetes Service

First set up your Azure CLI as above.

Run the `aks_kube_creds.sh` script from the DevOps-Bash-tools repo's `azure` directory.

This will find and configure all your kubernetes clusters in the current project.

```shell
az aks get-credentials --resource-group myResourceGroup --name myAKSCluster
```

```shell
kubectl config get-contexts
```

switch to the cluster you want:

```shell
kubectl config use-context <name>
```

```shell
kubectl get pods --all-namespaces
```

Then see [Kubernetes](kubernetes.md) for configs, scripts and `.envrc`.

## VMs

Use ZRS (zone-redundant storage) rather than LRS (locally-redundant storage),
price is ~50% more but still fairly trivial in overall cost compared to the compute its attached to
eg. spending £20 a month on storage for a $450 a month VM.

<https://learn.microsoft.com/en-gb/azure/storage/common/storage-redundancy>

###### Partial port from private Knowledge Base page 2017+
