# GCP - Google Cloud Platform

## DevOps Bash tools for GCP, GKE, GCE etc.

[HariSekhon/DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools)

## Install GCloud SDK CLI

Follow the [install doc](https://cloud.google.com/sdk/docs/install) or paste this to run an automated install script
which auto-detects and handles Mac or Linux:

```shell
git clone https://github.com/HariSekhon/DevOps-Bash-tools
```
```shell
bash-tools/install/install_gcloud_sdk.sh
```

Initialize your config and authenticate, following the prompts:
```shell
gcloud init
```

## Add SSH key to project

```shell
gcloud compute os-login ssh-keys add --key-file="$HOME/.ssh/id_rsa.pub"
```

If you're struggling to log in check your username eg. `hari_sekhon_domain_com@x.x.x.x` instead of `harisekhon@x.x.x.x`.

## Add SSH key to specific VM

Since the metadata SSH needs to be in the format:

```yaml
<username>:<ssh_key>
```

```shell
export VM=server1
export SSH_GCP_USERNAME=harisekhon
export SSH_KEY_PUB="$HOME/.ssh/id_rsa.pub"
gcloud compute instances add-metadata "$VM" --metadata-from-file ssh-keys=<(echo -n "$SSH_GCP_USERNAME:"; cat "$SSH_KEY_PUB")
```

You can iterate this using a script like [gce_foreach_vm.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/gcp/gce_foreach_vm.sh)
in the [DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools) repo which has a regex filter for a subset
of VMs if you only want to grant access to that subset.

Otherwise use the project wide SSH keys above.

Check you can see it under metadata ssh-keys
```shell
gcloud compute instances describe "$VM"
```

## Set up access to GKE - Google Kubernetes Engine

First set up your GCloud SDK CLI as above.

Run the `gke_kube_creds.sh` script from the DevOps-Bash-tools repo's `gcp/` directory.

This will find and configure all your kubernetes clusters in the current project.

```shell
gke_kube_creds.sh
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

## See all the details you can query for a VM

See `gcloud topic filters` for the details on the `--filter` matching.

Prefer [regex](regex.md), it's the sharpest most accurate and flexible, but make sure it's anchored to not match other
nodes eg. `node1` should not match `node10`.

```shell
gcloud compute instances list --filter="name ~ ^${VM_NAME}$" --format=text
```

Find the field that contains the IP address:

```shell
gcloud compute instances list --filter="name ~ ^${VM_NAME}$" --format=text | grep -i ip
```

## Get the IP Address of a specific VM

Use this if you are running a script like a Solr create collections against the IP address of a Solr node in the SolrCloud cluster.

```shell
gcloud compute instances list --filter="name ~ ^${VM_NAME}$" --format='get(networkInterfaces[0].networkIP)'
```

## Get the names + IPs of all or a selection of VMs by regex name match

Clone [DevOps-Bash-tools](devops-bash-tools.md), then:

```shell
gcp/gce_host_ips.sh <optional_regex>
```

## Get the IP of a random node in a cluster

Useful if you're running `curl` commands against an Elasticsearch or SolrCloud cluster.

```shell
gcloud compute instances list --filter="name ~ ^${VM_NAME_PATTERN}$" --format='get(networkInterfaces[0].networkIP)' | shuf | head -n1
```

## Get the IP address of a Load Balancer

Useful to quickly get to an internal named load balancer by IP address to jump to the UI of an Elasticsearch or SolrCloud cluster.

```shell
gcloud compute forwarding-rules list --filter="name ~ ^${LOAD_BALANCER_NAME}$" --format='value(IPAddress)'
```

## Get the IP of your Google FileStore NFS server

Quickly compare this to your config such as your
[Jenkins JCasC config per environment](https://github.com/HariSekhon/Kubernetes-configs/blob/master/jenkins/overlay/jcasc-cm.patch.yaml#L101)
to ensure your config is pointing to the right IP

Notice the filestore name is in format `projects/<PROJECT_ID>/locations/europe-west2-b/instances/<NAME>` so we match the suffix `/${NAME}`
```shell
gcloud filestore instances list --filter="name ~ /${FILESTORE_NAME}$" --format='value(networks[0].ipAddresses[0])'
```

Partial port from private Knowledge Base 2015+
