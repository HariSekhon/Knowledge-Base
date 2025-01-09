# EKS Cluster Upgrade

[EKS UserGuid - Update Cluster](https://docs.aws.amazon.com/eks/latest/userguide/update-cluster.html)

[EKS Best Practices - Cluster Upgrades](https://docs.aws.amazon.com/eks/latest/best-practices/cluster-upgrades.html)

Upgrades must be done from one minor version to the next in sequence.

<!-- INDEX_START -->

- [Version Specific Release Notes](#version-specific-release-notes)
- [Pre-Requisite Checks](#pre-requisite-checks)
  - [Update Deprecated / Removed API objects](#update-deprecated--removed-api-objects)
  - [Generic Kubernetes Upgrade Checks](#generic-kubernetes-upgrade-checks)
  - [Enable Master logs to go to CloudWatch Logs](#enable-master-logs-to-go-to-cloudwatch-logs)
  - [Ensure at least 5 Free IPs Available](#ensure-at-least-5-free-ips-available)
  - [Check the IAM role has assume role for your account](#check-the-iam-role-has-assume-role-for-your-account)
  - [Review EKS cluster insights for issues that may affect upgrade](#review-eks-cluster-insights-for-issues-that-may-affect-upgrade)
  - [eksup](#eksup)
  - [AWS Resilience Hub (Optional)](#aws-resilience-hub-optional)
- [Upgrade](#upgrade)
  - [Upgrade Control Plane - Master Nodes](#upgrade-control-plane---master-nodes)
  - [Upgrade Add-Ons](#upgrade-add-ons)
  - [Upgrade Data Plane - Worker Nodes](#upgrade-data-plane---worker-nodes)
    - [Managed Node Groups](#managed-node-groups)
    - [Self-Managed Nodes](#self-managed-nodes)
- [Verify Workloads](#verify-workloads)
- [Meme](#meme)

<!-- INDEX_END -->

If you're using my [DirEnv](direnv.md) [configurations](https://github.com/HariSekhon/Environments) you
should have edited the `EKS_CLUSTER` setting so that it is automatically set when you cd to the right directory,
otherwise set the environment variable manually in your shell.

## Version Specific Release Notes

You must review these to see what changes are happening between versions that might break things:

<https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions-standard.html>

<https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions-extended.html>

## Pre-Requisite Checks

### Update Deprecated / Removed API objects

See the [Kubernetes Upgrades](kubernetes-upgrades.md) page covering finding deprecated / removed APIs for Kubernetes clusters
on any platform.

You will need to upgrade these applications to prevent breakages before upgrading the cluster.

### Generic Kubernetes Upgrade Checks

See the [Kubernetes Upgrades](kubernetes-upgrades.md) page for easier to use tools with nicer outputs like Pluto.

### Enable Master logs to go to CloudWatch Logs

[EKS UserGuide](https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)

Check if cluster logging is enabled to send control plane logs to CloudWatch Logs:

```shell
aws eks describe-cluster --name "$EKS_CLUSTER" --output json | jq -r '.cluster.logging'
```

If it isn't, set it:

```shell
aws eks update-cluster-config --name "$EKS_CLUSTER" \
    --logging '{"clusterLogging":[{"types":["api","audit","authenticator","controllerManager","scheduler"],"enabled":true}]}'
```

Check it's done by querying the `$UPDATE_ID` from the above output:

```shell
aws eks describe-update --name "$EKS_CLUSTER" --update-id "$UPDATE_ID"
```

### Ensure at least 5 Free IPs Available

Check there are at least 5 free IPs are available in the EKS subnets:

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

### Check the IAM role has assume role for your account

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

### Review EKS cluster insights for issues that may affect upgrade

<https://console.aws.amazon.com/eks/home#/clusters>

Select the cluster and then click on `Upgrade insights`.

On the CLI:

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

This gives a simple yes or no answer to if there are deprecated API objects in use:

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

Check AWS logs if any deprecated APIs were used in the last 30 minutes:

```shell
if uname | grep -q Darwin; then
  date(){
    # on Mac use GNU date so the --date="-30 minutes" below works
    command gdate "$@"
  }
fi

QUERY_ID=$(aws logs start-query \
    --log-group-name "/aws/eks/$EKS_CLUSTER/cluster" \
    --start-time $(date -u --date="-30 minutes" "+%s") \
    --end-time $(date "+%s") \
    --query-string 'fields @message | filter `annotations.k8s.io/deprecated`="true"' \
    --query queryId --output text)

echo "Query started (query id: $QUERY_ID), please hold ..." && sleep 5 # give it some time to query

aws logs get-query-results --query-id $QUERY_ID
```

### eksup

<https://clowdhaus.github.io/>

[:octocat: clowdhaus/eksup](https://github.com/clowdhaus/eksup)

```shell
brew install clowdhaus/taps/eksup
```

or download binary release easily from [DevOps-Bash-tools](devops-bash-tools.md):

```shell
install_eksup.sh
```

Run analyze, needs region, doesn't automatically pick up the `$AWS_DEFAULT_REGION`:

```shell
eksup analyze --cluster "$EKS_CLUSTER" --region "${AWS_DEFAULT_REGION:-eu-west-1}"
```

Hit [bug](https://github.com/clowdhaus/eksup/issues/46):

```text
Error: Launch template not found, launch configuration is not supported
```

### AWS Resilience Hub (Optional)

<https://aws.amazon.com/resilience-hub/>

Test the resilience of apps on Kubernetes.

## Upgrade

### Upgrade Control Plane - Master Nodes

You can click `Upgrade Now` in the AWS Console UI, `eksctl` or [AWS CLI](aws.md#aws-cli).

Check the current EKS version:

```shell
aws eks describe-cluster --name "$EKS_CLUSTER" --query cluster.version --output text
```

Initiate the Control Plane upgrade using `eksctl`:

```shell
eksctl upgrade cluster --name "$EKS_CLUSTER" --version "$TARGET_VERSION" --approve  # without --approve does a plan only
```

or AWS CLI:

```shell
aws eks update-cluster-version --name "$EKS_CLUSTER" --kubernetes-version "$TARGET_VERSION"
```

Monitor the progress using this command or the AWS Console UI:

(set the `$UPGRADE_ID` from the output of the above command)

```shell
aws eks describe-update --name "$EKS_CLUSTER" --update-id "$UPDATE_ID"
```

### Upgrade Add-Ons

<https://docs.aws.amazon.com/eks/latest/userguide/updating-an-add-on.html>

Explore installed add-ons:

See section [EKS Cluster Add-Ons](eks.md#eks-cluster-add-ons).

Checks Add-Ons are compatible with the version of Kubernetes you are going to:

- [AWS VPC CNI](https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html)
- [Kube Proxy](https://docs.aws.amazon.com/eks/latest/userguide/managing-kube-proxy.html)
- [CoreDNS](https://docs.aws.amazon.com/eks/latest/userguide/managing-coredns.html)
- [AWS Load Balancer](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html)
- [AWS Node Termination Handler](https://github.com/aws/aws-node-termination-handler)
- [EBS CSI driver](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html#managing-ebs-csi)
- [EFS CSI driver](https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html)

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

Create a new node group with the desired version:

```shell
eksctl create nodegroup --cluster "$EKS_CLUSTER" --name "$NEW_NODE_GROUP" --kubernetes-version "$TARGET_VERSION"
```

For each old node...

Cordon Node:

```shell
kubectl cordon "$NODE_NAME"
```

Drain Node:

```shell
kubectl drain "$NODE_NAME" --ignore-daemonsets # --delete-emptydir-data # --delete-local-data
```

Delete the old node group:

```shell
eksctl delete nodegroup --cluster "$EKS_CLUSTER" --name "$OLD_NODE_GROUP"
```

If you're setting the AMI ID in Terraform / Terragrunt and need to find the right AMI ID:

```shell
EKS_VERSION="1.25"
```

```shell
AMI_ID="$(aws ssm get-parameter --name "/aws/service/eks/optimized-ami/$EKS_VERSION/amazon-linux-2/recommended/image_id"  --query "Parameter.Value" --output text | tee /dev/stderr)"
```

Output:

```text
ami-0522024526aa1f248
```

If using Terragrunt, using `terragrunt.hcl` with cluster version and AMI ID:

```shell
perl -pi -e 's/^(\s*cluster_version\s*=\s*)".*$/$1"'"$EKS_VERSION"'"/' terragrunt.hcl
```

```shell
perl -pi -e 's/^(\s*ami_id\s*=\s*)".*$/$1"'"$AMI_ID"'"/' terragrunt.hcl
```

Verify the node versions:

```shell
kubectl get nodes
```

(you may need to wait a while for the autoscaling group to cycle the nodes, or force the issue by
cordoning and draining each old node as per above, you can then terminate them in the EC2 Console):

## Verify Workloads

Check your pods are running ok:

```shell
kubectl get pods -A
```

Otherwise you'll be this meme...

## Meme

If you think you can skip these checks above, you may end up like this:

![K8s Upgrades Unresponsive Pods](images/k8s_upgrade_completed_78_pods_unresponsive.jpeg)
