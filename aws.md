# AWS - Amazon Web Services

## DevOps Bash tools for AWS, EKS, EC2 etc

[HariSekhon/DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools)

## Install AWS CLI

Follow the [install doc](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
or paste this to run an automated install script which auto-detects and handles Mac or Linux:

```shell
git clone https://github.com/HariSekhon/DevOps-Bash-tools
```

```shell
bash-tools/install/install_aws_cli.sh
```

Then [configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)
depending on if you're using SSO or access keys etc.

## Set up access to EKS - Elastic Kubernetes Services

First set up your AWS CLI as above.

Run the `eks_kube_creds.sh` script from the DevOps-Bash-tools repo's `aws/` directory.

This will find and configure all your kubernetes clusters in the current AWS account.

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

Then see [Kubernetes](kubernetes.md) for configs, scripts and `.envrc`.

###### Partial port from private Knowledge Base page 2012+
