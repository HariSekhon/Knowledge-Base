# AWS EKS - Elastic Kubernetes Service

NOT PORTED YET

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
