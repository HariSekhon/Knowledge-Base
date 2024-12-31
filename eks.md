# AWS EKS - Elastic Kubernetes Service

NOT PORTED YET

<!-- INDEX_START -->

- [EKS on Fargate](#eks-on-fargate)
- [EKS Kubectl Access](#eks-kubectl-access)
- [Grant IAM Roles EKS Access](#grant-iam-roles-eks-access)
  - [Newer Native IAM Method](#newer-native-iam-method)
  - [Old ConfigMap Method](#old-configmap-method)
- [EKS Resizeable Disk](#eks-resizeable-disk)
- [EKS Cluster AddOns](#eks-cluster-addons)
- [EKS Cluster Upgrade](#eks-cluster-upgrade)
  - [Update Deprecated / Removed API objects](#update-deprecated--removed-api-objects)
  - [Upgrade Control Plane](#upgrade-control-plane)
  - [Upgrade Worker Nodes](#upgrade-worker-nodes)
    - [Managed Node Groups](#managed-node-groups)
    - [Self-Managed Nodes](#self-managed-nodes)
  - [Upgrade Add-Ons](#upgrade-add-ons)
  - [Verify Workloads](#verify-workloads)

<!-- INDEX_END -->

## EKS on Fargate

Serverless Kubernetes service to avoid having to deal with node pool management.

<https://docs.aws.amazon.com/eks/latest/userguide/fargate.html>

## EKS Kubectl Access

First install AWS CLI as per the [AWS](aws.md) page.

Then run the `eks_kube_creds.sh` script from the DevOps-Bash-tools repo's `aws/` directory.

This will find and configure kube config for all your kubernetes clusters in the current AWS account.

```shell
aws_kube_creds.sh
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

Then see [Kubernetes](kubernetes.md) page for configs, scripts and `.envrc`.

## Grant IAM Roles EKS Access

<https://docs.aws.amazon.com/eks/latest/userguide/grant-k8s-access.html>

### Newer Native IAM Method

This is preferred as long as your cluster meets the
[version prerequisites](https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html).

Compare your cluster version and update using:

```shell
aws eks describe-cluster --name "$EKS_CLUSTER" \
  --query 'cluster.{"Kubernetes Version": version, "Platform Version": platformVersion}'
```

If new enable, enable it (this is irreversible):

```shell
aws eks update-cluster-config --name "$EKS_CLUSTER" --access-config authenticationMode='API_AND_CONFIG_MAP'
```

Then create access entries:

```shell
aws eks create-access-entry --cluster-name "$EKS_CLUSTER" \
    --principal-arn "arn:aws:iam::$AWS_ACCOUNT_ID:role/devs" \
    --type STANDARD \
    --user MyK8sRoleBinding \
    --kubernetes-groups MyK8sRoleBinding
```

<https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html>

### Old ConfigMap Method

Use this if the cluster version is old or you don't want to change the access mode in production just yet.

**WARNING: If you get this edit wrong you could lose access to your cluster**

For this reason it is recommended to use `eksctl` to edit the AWS `auth-map` configmap for safety:

```shell
eksctl get iamidentitymapping --cluster "$EKS_CLUSTER"
```

To get the role from an account currently authenticated using it:

```shell
AWS_ROLE="$(aws sts get-caller-identity --query 'Arn' --output text | sed 's|.*role/||; s|/.*$||' | tee /dev/stderr)"
```

If using AWS SSO it's look something like `AWSReservedSSO_<ROLE>_1234567890abcdef`.

```shell
eksctl create iamidentitymapping --cluster "$EKS_CLUSTER" --arn "arn:aws:iam::$AWS_ACCOUNT_ID:role/$AWS_ROLE" --username 'admin:{{SessionName}}' --group 'system:masters' --no-duplicate-arns
````

Since you can't update, you would need to delete to modify the above,
for example if you missed off the `:{{SessionName}}` suffix to the `--username 'admin'`

```shell
eksctl delete iamidentitymapping --cluster $EKS_CLUSTER  --arn="arn:aws:iam::$AWS_ACCOUNT_ID:role/$AWS_ROLE"
```

See the configmap:

```shell
kubectl get -n kube-system configmap aws-auth -o yaml
```

Raw old school editing method (DO NOT USE - see WARNING above):

```shell
kubectl edit -n kube-system configmap aws-auth
```

## EKS Resizeable Disk

Either create a new storageclass that is resizeable and use that for all future apps:

[storageclass-aws-standard-resizeable.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/storageclass-aws-standard-resizeable.yaml)

Or patch the default storageclass:

```shell
$ kubectl get sc
NAME               PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
ebs-sc (default)   ebs.csi.aws.com         Retain          WaitForFirstConsumer   true                   134d
```

```shell
kubectl patch sc ebs-sc -p '{"allowVolumeExpansion": true}'
```

I've patched the default storage class in production and resized Atlantis data pvc using the same procedure as the
[Jenkins-on-Kubernetes](jenkins-on-kubernetes.md#increase-jenkins-server-disk-space-on-kubernetes)
notes , it works.

## EKS Cluster AddOns

List clusters:

```shell
eksctl get cluster
```

or

```shell
aws eks list-clusters
```

List Available EKS cluster addons:

```shell
aws eks describe-addon-versions | jq -r '.addons[].addonName' | sort
```

List `eksctl` installed EKS cluster addons (may not show ones installed by charts):

```shell
eksctl get addons --cluster "$EKS_CLUSTER"
```

List addon pods:

```shell
kubectl get pods -n addons
```

## EKS Cluster Upgrade

1. [Update Deprecated / Removed API objects](#update-deprecated--removed-api-objects)
1. [Upgrade the Control Plane](#upgrade-control-plane)
1. [Upgrade EKS Node groups](#upgrade-worker-nodes)
1. [Upgrade 3rd party add-ons](#upgrade-add-ons) that are version specific
1. [Verify Workloads](#verify-workloads) are running ok

If you're using my [DirEnv](direnv.md) [configurations](https://github.com/HariSekhon/Environments) you
should have edited the `EKS_CLUSTER` setting so that it is automatically set when you cd to the right directory,
otherwise set the environment variable manually in your shell.

### Update Deprecated / Removed API objects

See the [Kubernetes Upgrades](kubernetes-upgrades.md) page covering this for Kubernetes clusters on any platform.

### Upgrade Control Plane

Check the current EKS version:

```shell
aws eks describe-cluster --name "$EKS_CLUSTER" --query cluster.version --output text
```

Initiate the Control Plane upgrade:

```shell
aws eks update-cluster-version --name "$EKS_CLUSTER" --kubernetes-version "$TARGET_VERSION"
```

Monitor the progress using this command or the AWS UI:

(set the `$UPGRADE_ID` from the output of the above command)

```shell
aws eks describe-update --name <cluster_name> --update-id "$UPDATE_ID"
```

### Upgrade Worker Nodes

#### Managed Node Groups

Cordon nodes to have them drained of pods and prevent new pod scheduling:

```shell
kubectl cordon "$NODE_NAME"
```

```shell
aws eks update-nodegroup-version --cluster-name "$EKS_CLUSTER" \
                                 --nodegroup-name "$NODE_GROUP" \
                                 --kubernetes-version "$TARGET_VERSION"
```

Monitor the progress using this command or the AWS UI:

(set the `$UPGRADE_ID` from the output of the above command)

```shell
aws eks describe-update --cluster-name "$EKS_CLUSTER" --nodegroup-name "$NODE_GROUP" --update-id "$UPDATE_ID"
```

#### Self-Managed Nodes

For each node...

Cordon Node:

```shell
kubectl cordon "$NODE_NAME"
```

Drain Node:

```shell
kubectl drain "$NODE_NAME" --ignore-daemonsets --delete-local-data
```

Create a new node group with the desired version:

```shell
eksctl create nodegroup --cluster "$EKS_CLUSTER" --name "$NEW_NODE_GROUP" --kubernetes-version "$TARGET_VERSION"
```

Delete the old node group:

```shell
eksctl delete nodegroup --cluster "$EKS_CLUSTER" --name "$OLD_NODE_GROUP"
```

Verify the node versions:

```shell
kubectl get nodes
```

### Upgrade Add-Ons

Update Add-ons:

```shell
eksctl update addon --name vpc-cni --cluster "$EKS_CLUSTER"
```

```shell
eksctl update addon --name kube-proxy --cluster "$EKS_CLUSTER"
```

```shell
eksctl update addon --name coredns --cluster "$EKS_CLUSTER"
```

### Verify Workloads

Check your pods are running ok:

```shell
kubectl get pods -A
```
