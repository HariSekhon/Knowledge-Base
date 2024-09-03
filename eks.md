# AWS EKS - Elastic Kubernetes Service

NOT PORTED YET

<!-- INDEX_START -->

- [EKS on Fargate](#eks-on-fargate)
- [EKS Kubectl Access](#eks-kubectl-access)
- [EKS Upgrades](#eks-upgrades)

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

## EKS Upgrades

See the [Kubernetes Upgrades](kubernetes-upgrades.md) page.
