# AWS EKS - Elastic Kubernetes Service

NOT PORTED YET

<!-- INDEX_START -->

- [Best Practices](#best-practices)
- [EKS on Fargate](#eks-on-fargate)
- [EKS Kubectl Access](#eks-kubectl-access)
- [Get Cluster Version](#get-cluster-version)
- [Grant IAM Roles EKS Access](#grant-iam-roles-eks-access)
  - [Newer Native IAM Method](#newer-native-iam-method)
  - [Old ConfigMap Method](#old-configmap-method)
- [EKS Resizeable Disk](#eks-resizeable-disk)
- [EKS Cluster AddOns](#eks-cluster-addons)
- [EKS Cluster Upgrade](#eks-cluster-upgrade)
  - [Update Deprecated / Removed API objects](#update-deprecated--removed-api-objects)
  - [Pre-requisite Checks](#pre-requisite-checks)
  - [Upgrade Control Plane - Master Nodes](#upgrade-control-plane---master-nodes)
  - [Upgrade Add-Ons](#upgrade-add-ons)
  - [Upgrade Data Plane - Worker Nodes](#upgrade-data-plane---worker-nodes)
    - [Managed Node Groups](#managed-node-groups)
    - [Self-Managed Nodes](#self-managed-nodes)
  - [Verify Workloads](#verify-workloads)

<!-- INDEX_END -->

## Best Practices

<https://docs.aws.amazon.com/eks/latest/best-practices/introduction.html>

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

## Get Cluster Version

```shell
aws eks describe-cluster --name "$EKS_CLUSTER" --query "cluster.version" --output text
```

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

or

```shell
aws eks list-addons --cluster-name "$EKS_CLUSTER" --query 'addons[].addonName' --output text
```

List version of a specific addon:

```shell
aws eks describe-addon --cluster-name "$EKS_CLUSTER" --addon-name vpc-cni --query "addon.addonVersion" --output text
```

List addon pods:

```shell
kubectl get pods -n addons
```

## EKS Cluster Upgrade

<https://docs.aws.amazon.com/eks/latest/userguide/update-cluster.html>

<https://docs.aws.amazon.com/eks/latest/best-practices/cluster-upgrades.html>

Upgrades must be done from one minor version to the next in sequence.

1. [Update Deprecated / Removed API objects](#update-deprecated--removed-api-objects)
1. [Pre-Requisite Checks](#pre-requisite-checks)
1. [Upgrade the Control Plane - Master Nodes](#upgrade-control-plane---master-nodes)
1. [Upgrade 3rd party add-ons](#upgrade-add-ons) that are version specific
1. [Upgrade the Data Plane - Worker Nodes](#upgrade-data-plane---worker-nodes)
1. [Verify Workloads](#verify-workloads) are running ok

If you're using my [DirEnv](direnv.md) [configurations](https://github.com/HariSekhon/Environments) you
should have edited the `EKS_CLUSTER` setting so that it is automatically set when you cd to the right directory,
otherwise set the environment variable manually in your shell.

### Update Deprecated / Removed API objects

See the [Kubernetes Upgrades](kubernetes-upgrades.md) page covering this for Kubernetes clusters on any platform.

### Pre-Requisite Checks

Check there are at least 5 IPs available in the EKS subnets:

```shell
aws ec2 describe-subnets --subnet-ids \
  $(aws eks describe-cluster --name "$EKS_CLUSTER" \
  --query 'cluster.resourcesVpcConfig.subnetIds' \
  --output text) \
  --query 'Subnets[*].[SubnetId,AvailabilityZone,AvailableIpAddressCount]' \
  --output table
```

or use from [DevOps-Bash-tools](devops-bash-tools.md):

```shell
aws_eks_available_ips.sh <cluster>
```

Check the IAM role has assume role for your account:

```shell
ROLE_ARN="$(
    aws eks describe-cluster \
        --name "$EKS_CLUSTER" \
        --query 'cluster.roleArn' \
        --output text
)"

echo "$ROLE_ARN"

aws iam get-role \
    --role-name "${ROLE_ARN##*/}" \
    --query 'Role.AssumeRolePolicyDocument'
```

Output should look like this:

```text
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```

Review EKS cluster insights for issues that may affect upgrade:

```shell
aws eks list-insights --cluster-name "$EKS_CLUSTER"
```

Show only failing ones:

```shell
aws eks list-insights --cluster-name "$EKS_CLUSTER" --query 'insights[?insightStatus.status != `PASSING`]'
```

Or only ones in the `UPGRADE_READINESS`:

```shell
aws eks list-insights --cluster-name "$EKS_CLUSTER" --query 'insights[?category == `UPGRADE_READINESS`]'
```

This gives a simple yes or no answer to if there are deprecated API objects in use.
See the [Kubernetes Upgrades](kubernetes-upgrades.md) page for tools to give you more specific details:

```text
[
    {
        "id": "6419ee9f-8299-4bc9-9d43-95a1b1016edb",
        "name": "Deprecated APIs removed in Kubernetes v1.25",
        "category": "UPGRADE_READINESS",
        "kubernetesVersion": "1.25",
        "lastRefreshTime": "2024-12-31T23:04:33+07:00",
        "lastTransitionTime": "2023-11-23T13:49:31+07:00",
        "description": "Checks for usage of deprecated APIs that are scheduled for removal in Kubernetes v1.25. Upgrading your cluster before migrating to the updated APIs supported by v1.25 could cause application impact.",
        "insightStatus": {
            "status": "ERROR",
            "reason": "Deprecated API usage detected within last 30 days and your cluster is on Kubernetes v1.24."
        }
    },
    {
        "id": "712cdf7f-bcab-4ad5-a690-b1fbd92426cd",
        "name": "Deprecated APIs removed in Kubernetes v1.27",
        "category": "UPGRADE_READINESS",
        "kubernetesVersion": "1.27",
        "lastRefreshTime": "2024-12-31T23:04:33+07:00",
        "lastTransitionTime": "2023-11-23T13:49:31+07:00",
        "description": "Checks for usage of deprecated APIs that are scheduled for removal in Kubernetes v1.27. Upgrading your cluster before migrating to the updated APIs supported by v1.27 could cause application impact.",
        "insightStatus": {
            "status": "WARNING",
            "reason": "Deprecated API usage detected within last 30 days and your cluster is on Kubernetes v1.25 or lower, or existing resources using deprecated APIs present in cluster."
        }
    }
]
```

You can get more details on the actual API objects:

```shell
aws eks describe-insight --cluster-name "$EKS_CLUSTER" --id "$INSIGHT_ID"  # from the last command output
```

### Upgrade Control Plane - Master Nodes

Check the current EKS version:

```shell
aws eks describe-cluster --name "$EKS_CLUSTER" --query cluster.version --output text
```

Initiate the Control Plane upgrade:

```shell
eksctl upgrade cluster --name "$EKS_CLUSTER" --version "$TARGET_VERSION" --approve
```

or

```shell
aws eks update-cluster-version --name "$EKS_CLUSTER" --kubernetes-version "$TARGET_VERSION"
```

Monitor the progress using this command or the AWS UI:

(set the `$UPGRADE_ID` from the output of the above command)

```shell
aws eks describe-update --name "$EKS_CLUSTER" --update-id "$UPDATE_ID"
```

### Upgrade Add-Ons

<https://docs.aws.amazon.com/eks/latest/userguide/updating-an-add-on.html>

Explore installed add-ons:

See section [EKS Cluster AddOns](#eks-cluster-addons).

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

or

```shell
aws eks update-addon \
    —cluster-name "$EKS_CLUSTER" \
    —addon-name vpc-cni —addon-version "$version" \
    --service-account-role-arn arn:aws:iam::111122223333:role/role-name \
    —configuration-values '{}' \
    —resolve-conflicts PRESERVE
```

### Upgrade Data Plane - Worker Nodes

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

### Verify Workloads

Check your pods are running ok:

```shell
kubectl get pods -A
```
