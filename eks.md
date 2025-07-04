# AWS EKS - Elastic Kubernetes Service

NOT PORTED YET

<!-- INDEX_START -->

- [Best Practices](#best-practices)
- [EKS on Fargate](#eks-on-fargate)
- [EKS Kubectl Access](#eks-kubectl-access)
- [Eksctl](#eksctl)
- [Get Cluster Version](#get-cluster-version)
- [AWS Load Balancer](#aws-load-balancer)
- [Grant IAM Roles EKS Access](#grant-iam-roles-eks-access)
  - [Newer Native IAM Method](#newer-native-iam-method)
  - [Old ConfigMap Method](#old-configmap-method)
- [EKS Resizeable Disk](#eks-resizeable-disk)
- [EKS Cluster Add-Ons](#eks-cluster-add-ons)
- [EKS Cluster Upgrades](#eks-cluster-upgrades)
- [Extended Support](#extended-support)

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

## Eksctl

The official CLI of EKS.

Easier to use than [AWS CLI](aws.md#aws-cli) for EKS.

From [DevOps-Bash-tools](devops-bash-tools.md):

```shell
install_eksctl.sh
```

## Get Cluster Version

```shell
aws eks describe-cluster --name "$EKS_CLUSTER" --query "cluster.version" --output text
```

## AWS Load Balancer

<https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/>

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

## EKS Cluster Add-Ons

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

## EKS Cluster Upgrades

See the [EKS Cluster Upgrades](eks-upgrades.md) doc.

## Extended Support

[UserGuide - Extended Support](https://docs.aws.amazon.com/eks/latest/userguide/disable-extended-support.html)

Extended support costs more, you may want to switch to standard support.

Note: this will force upgrades earlier when the cluster's version falls out of standard support, which is only 14
months, so you will need to plan
and upgrade more regularly, which is recommended best practice anyway.
See [upgrade policy](https://docs.aws.amazon.com/eks/latest/userguide/view-upgrade-policy.html).

See the
[Available Versions and Release Calender](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html#available-versions)
for when you need to upgrade versions for Standard or Extended support.

You can always see available versions and their status of standard vs extended and dates via the AWS CLI.

(requires a fairly new version of AWS CLI)

```shell
brew upgrade awscli
```

```shell
aws eks describe-cluster-versions --output table
```

Disable extended support and stay on the more recent versions only:

```shell
aws eks update-cluster-config --name "$EKS_CLUSTER" --upgrade-policy "supportType=STANDARD"
```
