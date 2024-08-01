# Karpenter

<https://karpenter.sh/>

Open source cluster autoscaler for cloud

Easier than using Auto Scaling Groups and the traditional cluster autoscaler

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
