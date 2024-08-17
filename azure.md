# Azure

NOT PORTED YET

<!-- INDEX_START -->
- [DevOps Bash tools for Azure, AKS, VMs etc](#devops-bash-tools-for-azure-aks-vms-etc)
- [Install Azure CLI](#install-azure-cli)
- [Set up access to AKS - Azure Kubernetes Service](#set-up-access-to-aks---azure-kubernetes-service)
- [VMs](#vms)
- [Data](#data)
<!-- INDEX_END -->

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

## Data

Data is always replicated 3x in primary region. Options:

- LRS (locally-redundant storage)
  - replicates within same AZ - not recommended for HA or durability
  - 11 nines durability
  - synchronously writes to all 3 replicas
- ZRS (zone-redundant storage)
  - multi-zone - replicates to 3 AZs
  - 12 nines durability
  - synchronously writes to all 3 replicas
  - app still needs transient fault handling to account for DNS failover time - retry policies with exponential back-off
  - use this - price is ~50% more but still fairly trivial in overall cost compared to the compute its attached to
    eg. spending only $15 a month on a 100GB storage disk SSD for a $450 a month VM with 8vCPUs and 64GB RAM.

<https://learn.microsoft.com/en-gb/azure/storage/common/storage-redundancy>

###### Partial port from private Knowledge Base page 2017+
