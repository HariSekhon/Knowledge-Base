# Karpenter

<https://karpenter.sh/>

Open source cluster autoscaler for cloud.

Easier than using Auto Scaling Groups and the traditional cluster autoscaler.

Adds finalizers to nodes which blocks deletion until all pods are drained.

Particularly well suited to burst scale up and scale down use cases such as machine learning jobs.

<!-- INDEX_START -->

- [Install](#install)
- [Configure](#configure)
- [Test](#test)

<!-- INDEX_END -->

## Install

```shell
helm repo add karpenter https://charts.karpenter.sh
```

```shell
helm repo update
```

```shell
CLUSTER_NAME=mycluster

CLUSTER_ENDPOINT="$(aws eks describe-cluster --name "$CLUSTER_NAME" --query "cluster.endpoint" --output json)"

helm upgrade --install karpenter/karpenter \
             --version 0.5.0 \
             --create-namespace \
             --namespace karpenter \
             --skip-crds karpenter \
             --set serviceAccount.create=false \
             --set controller.clusterName="$CLUSTER_NAME" \
             --set controller.clusterEndpoint="$CLUSTER_ENDPOINT" \
             --wait  # for the defaulting webhook to install before creating a Provisioner
```

## Configure

Adapt template to your needs:

[HariSekhon/Kubernetes-configs - karpenter.yaml](https://github.com/HariSekhon/Kubernetes-configs/tree/blob/master/karpenter.yaml)

```shell
kubectl apply -f karpenter.yaml
```

## Test

Create a deployment to test the scale up:

```shell
DEPLOYMENT_NAME=my-karpenter-test-deployment
```

```shell
kubectl create deployment "$DEPLOYMENT_NAME" \
      --image=public.ecr.aws/eks-distro/kubernetes/pause:3.2 \
      --requests.cpu=1
```

Scale up the deployment to force a scaling event:

```shell
kubectl scale deployment "$DEPLOYMENT_NAME" --replicas 10
```

Watch Karpenter pod logs for scale up event:

```shell
kubectl logs -f -n karpenter $(kubectl get pods -n karpenter -l karpenter=controller -o name)
```

Should show something like this:

```text
2021-11-23T04:46:11.280Z        INFO    controller.allocation.provisioner/default       Starting provisioning loop      {"commit": "abc12345"}
2021-11-23T04:46:11.280Z        INFO    controller.allocation.provisioner/default       Waiting to batch additional pods        {"commit": "abc123456"}
2021-11-23T04:46:12.452Z        INFO    controller.allocation.provisioner/default       Found 9 provisionable pods      {"commit": "abc12345"}
2021-11-23T04:46:13.689Z        INFO    controller.allocation.provisioner/default       Computed packing for 10 pod(s) with instance type option(s) [m5.large]  {"commit": " abc123456"}
2021-11-23T04:46:16.228Z        INFO    controller.allocation.provisioner/default       Launched instance: i-01234abcdef, type: m5.large, zone: us-east-1a, hostname: ip-192-168-0-0.ec2.internal    {"commit": "abc12345"}
2021-11-23T04:46:16.265Z        INFO    controller.allocation.provisioner/default       Bound 9 pod(s) to node ip-192-168-0-0.ec2.internal  {"commit": "abc12345"}
2021-11-23T04:46:16.265Z        INFO    controller.allocation.provisioner/default       Watching for pod events {"commit": "abc12345"}
```

Delete the deployment to test the scale down:

```shell
kubectl delete deployment "$DEPLOYMENT_NAME"
```

Watch Karpenter pod logs for scale down event:

```shell
kubectl logs -f -n karpenter $(kubectl get pods -n karpenter -l karpenter=controller -o name)
```

Should show something like this:

```text
2021-11-23T04:46:18.953Z        INFO    controller.allocation.provisioner/default       Watching for pod events {"commit": "abc12345"}
2021-11-23T04:49:05.805Z        INFO    controller.Node Added TTL to empty node ip-192-168-0-0.ec2.internal {"commit": "abc12345"}
2021-11-23T04:49:35.823Z        INFO    controller.Node Triggering termination after 30s for empty node ip-192-168-0-0.ec2.internal {"commit": "abc12345"}
2021-11-23T04:49:35.849Z        INFO    controller.Termination  Cordoned node ip-192-168-116-109.ec2.internal   {"commit": "abc12345"}
2021-11-23T04:49:36.521Z        INFO    controller.Termination  Deleted node ip-192-168-0-0.ec2.internal    {"commit": "abc12345"}
```
