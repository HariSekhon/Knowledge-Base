# Jenkins on Kubernetes

This is the best way to run Jenkins with auto-spawning agents for scaling up and down.

<!-- INDEX_START -->

- [Kubernetes Configs](#kubernetes-configs)
  - [JCasC - Jenkins Configuration as Code](#jcasc---jenkins-configuration-as-code)
  - [GCP - create Node Pool of Larger Nodes for Jenkins](#gcp---create-node-pool-of-larger-nodes-for-jenkins)
  - [Default Admin User + Password](#default-admin-user--password)
  - [Reset the Jenkins admin password when using Kubernetes Helm Chart](#reset-the-jenkins-admin-password-when-using-kubernetes-helm-chart)
- [Jenkins on Kubernetes Diagram](#jenkins-on-kubernetes-diagram)
- [CloudBees on Kubernetes](#cloudbees-on-kubernetes)
  - [Install CloudBees CLI](#install-cloudbees-cli)
- [Jenkins X](#jenkins-x)
- [Old Manual Configuration of Jenkins on Kubernetes](#old-manual-configuration-of-jenkins-on-kubernetes)
- [Increase Jenkins Server Disk Space on Kubernetes](#increase-jenkins-server-disk-space-on-kubernetes)
- [Troubleshooting](#troubleshooting)
  - [Recovery if you deleted the PersistentVolumeClaim](#recovery-if-you-deleted-the-persistentvolumeclaim)

<!-- INDEX_END -->

## Kubernetes Configs

[HariSekhon/Kubernetes-configs](https://github.com/HariSekhon/Kubernetes-configs#jenkins-on-kubernetes)

Configs are in the `jenkins/` directory.

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Kubernetes-configs&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Kubernetes-configs)

### JCasC - Jenkins Configuration as Code

<https://plugins.jenkins.io/configuration-as-code/>

JCasC updates the password dynamically from the `values.yaml` (or per environment jcasc patch as per in the repo) using
a sidecar that dynamically notices and reloads the config.

### GCP - create Node Pool of Larger Nodes for Jenkins

You're probably going to need a bigger node pool for the Jenkins server which can only vertically scale
and will otherwise get stuck in a `pending` state when you increase the resource requests/limits and `-Xmx`.

Create a small pool with 16GB nodes because Jenkins server frequently scales past 6GB and doesn't schedule on
`e2-standard-2` (8GB RAM) so use `e2-standard-4` (16GB RAM):

```shell
gcloud beta container node-pools create "jenkins" \
    --cluster "$CLOUDSDK_CONTAINER_CLUSTER" \
    --machine-type "e2-standard-4" \
    --num-nodes "1" \
    --enable-autoscaling \
    --min-nodes "0" \
    --max-nodes "1" \
    --location-policy "BALANCED" \
    --enable-autoupgrade \
    --enable-autorepair \
    --max-surge-upgrade 1 \
    --max-unavailable-upgrade 0
```

### Default Admin User + Password

User (usually `admin`):

```shell
kubectl get secret -n jenkins jenkins -o 'jsonpath={.data.jenkins-admin-user}' | base64 --decode
```

Password:

```shell
kubectl get secret -n jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
```

WARNING: The Jenkins admin password secret gets changed to a new random value every time you apply the Jenkins Helm
chart via Kustomize (see [bug report](https://github.com/jenkinsci/helm-charts/issues/1026)).

You can also get the secrets from the container, it's just a bit longer, but it's exactly the same as the above and
has the same bug:

```shell
kubectl exec -ti -n jenkins jenkins-0 -c jenkins -- cat /run/secrets/additional/chart-admin-user
```

```shell
kubectl exec -ti -n jenkins jenkins-0 -c jenkins -- cat /run/secrets/additional/chart-admin-password
```

### Reset the Jenkins admin password when using Kubernetes Helm Chart

Whether you lost the password or got hit by [this bug](https://github.com/jenkinsci/helm-charts/issues/1026), the
[traditional reset](jenkins.md#reset-the-jenkins-admin-password)
won't work with the Jenkins helm chart if `securityRealm` -> `local` section is set because JCasC resets
the admin password from the `jenkins` secret whenever it changes, which will hit you every pod restart.

Stop the helm chart from recreating the secret every time by setting this in the chart `values.yaml` and applying it:

```yaml
controller:
  admin:
    existingSecret: jenkins
```

Then force the `jenkins-0` server pod to restart:

```shell
kubectl rollout restart sts jenkins
```

Now recover the initial admin password to log in:

```shell
kubectl get secret -n jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
```

If you've set `existingSecret` before any initial deployment so that the `jenkins` secret is never create or you lost
the secret that JCasC uses (perhaps because ArgoCD pruned it) you can (re)create it like this:

```shell
kubectl create secret generic -n jenkins jenkins \
    --from-literal=jenkins-admin-user="admin" \
    --from-literal=jenkins-admin-password="$(pwgen -s 20 -c 1)"
```

then restart Jenkins again to force JCasC to reset Jenkins to this new password and flush any caches:

```shell
kubectl rollout restart sts jenkins
```

## Jenkins on Kubernetes Diagram

This is an example of a production Jenkins-on-Kubernetes I built and managed for a client.

![](https://raw.githubusercontent.com/HariSekhon/Diagrams-as-Code/master/images/jenkins_kubernetes_cicd.svg)

## CloudBees on Kubernetes

Deploy this config:

[HariSekhon/Kubernetes-configs - cloudbees/ directory](https://github.com/HariSekhon/Kubernetes-configs/tree/master/cloudbees)

### Install CloudBees CLI

in [DevOps-Bash-tools](devops-bash-tools.md):

```shell
install/install_cloudbees.sh
```

```shell
cloudbees check kubernetes
```

gets this output, even on production clusters with several working ingresses

```none
[KO] Ingress service exists
```

output from a live EKS cluster:

```none
[OK] Kubernetes Client version is higher or equal to 1.10 - v1.18.8
[OK] Kubernetes client can be created
[OK] Kubernetes server is accessible
[OK] Kubernetes Server version is higher or equal to 1.10 - v1.21.2-eks-0389ca3
[OK] Client and server have same major version - 1
[KO] Client and server have less than 1 minor version difference - 1.18.8 vs 1.21.2-eks-0389ca3. Fix your PATH to use a compatible kubectl client.
[KO] Ingress service exists
[SKIPPED] Ingress has an external address
[SKIPPED] Ingress deployment exists
[SKIPPED] Ingress deployment has at least 1 ready replica
[SKIPPED] Host name resolves to ingress external address - Add --host-name='mycompany.com' to enable this check
[SKIPPED] Can access the ingress controller using http
[SKIPPED] Can access the ingress controller using https
[OK] Has a default storage class - gp2
[OK] Storage provisioner is supported - gp2
----------------------------------------------
Summary: 15 run, 7 passed, 2 failed, 6 skipped
error: there are 2 failed checks
```

output from a live GKE cluster:

```none
[OK] Kubernetes Client version is higher or equal to 1.10 - v1.18.8
[OK] Kubernetes client can be created
[OK] Kubernetes server is accessible
[OK] Kubernetes Server version is higher or equal to 1.10 - v1.19.14-gke.1900
[OK] Client and server have same major version - 1
[KO] Client and server have less than 1 minor version difference - 1.18.8 vs 1.19.14-gke.1900. Fix your PATH to use a compatible kubectl client.
[OK] Ingress service exists - kube-system/jxing-nginx-ingress-controller
[OK] Ingress has an external address - 35.189.220.163
[SKIPPED] Ingress deployment has at least 1 ready replica
[SKIPPED] Host name resolves to ingress external address - Add --host-name='mycompany.com' to enable this check
[KO] Can access the ingress controller using http - Accessing http://x.x.x.x/ won't work : Get "http://x.x.x.x/": dial tcp x.x.x.x:80: connect: connection refused
[KO] Can access the ingress controller using https - Accessing https://x.x.x.x/ won't work : Get "https://x.x.x.x/": dial tcp x.x.x.x:443: connect: connection refused
[OK] Has a default storage class - standard
[KO] Storage provisioner is supported - Please create a storage class using the disk type 'pd-ssd'
```

## Jenkins X

<https://jenkins-x.io/>

Tries to bundle everything - nice in theory, but this increases complexity and reduces flexibility.

This isn't really Jenkins - it uses Tekton pipelines.

Normal Jenkins-on-Kubernetes above is easier, works better as more widely used and tested,
and is more compatible with the traditional Jenkins people have been using for over a decade, including all the plugins
and features.

### Install

```shell
helm init --stable-repo-url https://charts.helm.sh/stable
```

Workaround for broken helm init url in older version of helm bundled is [here](https://stackoverflow.com/questions/61954440/how-to-resolve-https-kubernetes-charts-storage-googleapis-com-is-not-a-valid).

```shell
jx boot
```

```shell
jx status
```

## Old Manual Configuration of Jenkins on Kubernetes

In the UI click:

```none
Manage Jenkins
    -> Manage Nodes and Clouds
        -> Configure Clouds
            -> add Kubernetes
```

Settings:

```none
Credentials -> add -> Jenkins -> GCP service account

Jenkins URL -> http://jenkins-ui.jenkins.svc.cluster.local:8080

Jenkins tunnel -> jenkins-discovery.jenkins.svc.cluster.local:50000

Pod Templates
  -> Add Pod Template
    -> copy pod template from k8s repo jenkins agent-pod.yaml (https://github.com/HariSekhon/Kubernetes-configs/blob/master/jenkins/base/agent-pod.yaml)
    -> Usage -> "Use this node as much as possible" (default: "Only build jobs with label expressions matching this node" <- won't get used)
```

## Increase Jenkins Server Disk Space on Kubernetes

The tricks is doing this without losing your job history data.

You first need to have been using a [resizeable disk](https://github.com/HariSekhon/Kubernetes-configs/blob/master/jenkins/base/storageclass-gcp-standard-resizeable.yaml) configuration.

**WARNING: do NOT delete the PersistentVolumeClaim**

Otherwise the Jenkins server statefulset will create a new blank persistent volume, losing your state.
Then you'll have to follow the more difficult Recovery Steps further down.

**Ensure Persistent Volume will be Retained**

First, ensure that the Jenkins persistent volume is set to be retained so you don’t lose the `/var/jenkins_home` volume
where the build history is stored (losing it will also fail future pipelines milestones due to build numbers being reset
which requires
[Groovy Console Scripting](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/jenkins/jenkins_clear_build_history_all_jobs.groovy)
to fix it).

Find the persistent volume:

```shell
kubectl get pv | grep jenkins
```

You should see `Retain` in the 4th field rather than `Delete` (delete is the default):

```none
pvc-228857c7-2230-407f-80be-6ff3c4f0b946   30Gi       RWO            Retain           Bound    jenkins/jenkins-home-jenkins-0   gcp-standard-resizeable            2y161d
```

If it's not set to `Retain` then edit it:

```shell
kubectl edit -n jenkins \
  "$(kubectl get pvc -n jenkins | \
      grep jenkins-home | \
      awk 'print $1; exit')"
```

Increase the storage size request in the persistent volume claim template in the jenkins
[server.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/jenkins/base/server.yaml)
or [values.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/jenkins/base/values.yaml)
if using Helm install.

Merge and apply the Pull Request with the resized storage request in the `values.yaml` if using helm chart
or `server.yaml` if using older custom manifest install.

Delete the Jenkins statefulset (needed because K8s doesn’t allow updating the storage field):

```shell
kubectl delete sts -n jenkins jenkins
```

Update the Jenkins persistent volume claim (**WARNING: don’t delete / recreate or it’ll create a new blank volume**):

```shell
kubectl edit pvc -n jenkins jenkins-home-jenkins-0
```

Check the pvc has the new size:

```shell
kubectl get pvc -n jenkins
```

Check the persistent volume was automatically resized by the cloud provider to meet the new pvc request size:

```shell
kubectl get pv | grep jenkins
```

Redeploy Jenkins via ArgoCD / Helm / Kustomize / `kubectl` to recreate the server statefulset with the new size.

Check the Jenkins server is running again:

```shell
kubectl get po -n jenkins jenkins-0
```

## Troubleshooting

### Recovery if you deleted the PersistentVolumeClaim

If you delete the PVC, then it'll create a new blank persistent volume, losing your state.

If you have set your PersistentVolume to `Retain`
(which should have been the first thing you did when you installed Jenkins)
and at the very least before you started this operation, then you can recover this, but it's tricky.

To recover, edit the PVC and replace the `volumeName` field with the old volume name.

Unfortunately you can't edit in place so dump to yaml and edit.

```shell
kubectl get -n jenkins pvc/jenkins-home-jenkins-0 -o yaml > /tmp/jenkins-pvc.yaml
```

Edit it:

```shell
vim /tmp/jenkins-pvc.yaml
```

Delete the PVC, which hangs, on the STS. If using ArgoCD it's recreated almost instantly,
so have to race to recreate the PVC instantly, chain the commands and execute them all in 1 second:

```shell
kubectl delete pvc jenkins-home-jenkins-server-0 &
kubectl delete sts jenkins-server
kubectl create -f /tmp/jenkins-pvc.yaml
```

```shell
kubectl get pv,pvc -n jenkins | grep jenkins
```

You need to fix this `Lost`:

```none
persistentvolumeclaim/jenkins-home-jenkins-0   Lost     persistentvolume/pvc-7fecff9a-7ec7-42a4-bc4f-b54286f089c2   0                         gcp-standard-resizeable   61s
```

Now allow the old PV to be claimed by the new PVC uid.

Get the UID of the claiming PVC:

```shell
kubectl get -o json persistentvolumeclaim/jenkins-home-jenkins-server-0 | jq -r '.metadata.uid'
```

**WARNING: DON'T EDIT THE PV UID IT'LL GET LOST**

```shell
kubectl edit pv ...  # increase the size of the pv
```

```shell
kubectl delete pvc jenkins-home-jenkins-0 &
kubectl delete sts jenkins-server
```

The new pvc will now bind to the original PV.

Then redeploy the statefulset again (automatic via ArgoCD) or via Helm / Kustomize / `kubectl`
to use this new PVC ponting to the original PV with your job history data.

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=DevOps-Bash-tools&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/DevOps-Bash-tools)

**Ported from private Knowledge Base page 2020+**
