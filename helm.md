# Helm

Package Manager for [Kubernetes](kubernetes.md).

Helm is the original Kubernetes app manager before the rise of [Kustomize](kustomize.md) and still the primary
mechanism of deploying public Kubernetes applications.

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Helm v3](#helm-v3)
  - [Install](#install)
  - [Repos](#repos)
  - [Search for Packages](#search-for-packages)
  - [Install Chart](#install-chart)
  - [Docker Registries](#docker-registries)
- [Create Your Own Helm Chart](#create-your-own-helm-chart)
  - [Create template](#create-template)
  - [Edit](#edit)
  - [Lint](#lint)
  - [Install Custom Chart](#install-custom-chart)
- [Chart Repo](#chart-repo)
  - [GitHub](#github)
  - [GCS](#gcs)
- [Helm + Kustomize](#helm--kustomize)
  - [Kustomize + Helm dynamically](#kustomize--helm-dynamically)
  - [Kustomize + Helm statically](#kustomize--helm-statically)
  - [Static Templating Helm Tarball](#static-templating-helm-tarball)
- [Old: Helm v2](#old-helm-v2)

<!-- INDEX_END -->

## Key Points

- templated Kubernetes YAML manifests
- release is a deployed combination of Chart bundle + your custom `values.yaml` variables
- stores release info in k8s secret in same namespace as the release, no DB needed
- `Chart.yaml` - master file with name, version, description, maintainers, sources
- `requirements.yaml` - links to other charts this one depends on eg. MySQL/MariaDB
- `values.yaml` - variable defaults, common to use your own values.yaml with an upstream chart
- `templates/` - dir of Kubernetes YAML resource manifests Go templates, that use values.yaml variables
- hooks - pre-install / post-install / delete / upgrade / rollback
  - usage examples include to load a configmap / secret or run a backup at specific point in the deployment lifecycle

## Helm v3

- no more Tiller pod needed like v2 (was considered a security bad practice)
- software installation no longer generates a name automatically.
  One must be provided, or use the `--generate-name` option

### Install

[Install Guide](https://helm.sh/docs/intro/install/)

On Mac with [Homebrew](brew.md):

```shell
brew install helm
```

or

```shell
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
```

or portable binary install with optional version specified using script from [DevOps-Bash-tools](devops-bash-tools.md):
repo:

```shell
install_helm.sh  # <version>
```

### Repos

Add repos from which to search and install helm chart packages.

Helm repos you should probably have installed:

| Repo Label       | URL                                 |
|------------------|-------------------------------------|
| stable           | https://charts.helm.sh/stable       |
| bitnami          | https://charts.bitnami.com/bitnami  |
| fairwinds-stable | https://charts.fairwinds.com/stable |

Table generated from [HariSekhon/Kubernetes-configs](https://github.com/HariSekhon/Kubernetes-configs) file
[helm-repos.txt](https://github.com/HariSekhon/Kubernetes-configs/blob/master/helm-repos.txt)
by script
[generate_repos_markdown_table.sh](https://github.com/HariSekhon/Kubernetes-configs/blob/master/generate_repos_markdown_table.sh)

These repos can be quickly installed in one command using the script
[install_repos.sh](https://github.com/HariSekhon/Kubernetes-configs/blob/master/install_repos.sh):

```shell
./github/k8s/install_repos.sh
```

or the old fashioned manual way:

```shell
helm repo add stable https://charts.helm.sh/stable
```

<!-- Old Stable repo: ~~helm repo add stable https://kubernetes-charts.storage.googleapis.com~~ -->

```shell
helm repo add bitnami https://charts.bitnami.com/bitnami
```

```shell
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
```

### Search for Packages

Refresh the package lists:

```shell
helm repo update
```

Search ArtifactHub:

```shell
helm search hub database
```

Search your locally installed repos:

```shell
helm search repo stable
```

```shell
helm search repo bitnami
```

```shell
helm search repo fairwinds-stable
```

Show chart metadata:

```shell
helm show chart bitnami/mysql
```

Show chart metadata, values.yaml and notes (warning this is a huge output):

```shell
helm show all bitnami/mysql
```

Show available versions:

```shell
helm search repo fairwinds-stable/goldilocks --versions
```

### Install Chart

```shell
helm show values stable/mysql > values.yaml
```

Name must be lowercase:

```shell
helm install "$name" -f values.yaml stable/nginx-ingress
```

`--set key=value,key2=value2` CLI values overrides - saved in a configmap, run `helm get values "$name"` to see them

WARNING: `helm status` doesn't detect if k8s objects deleted / modified - this is why you need [ArgoCD](argocd.md)
for GitOps:

```shell
helm status "$name"
```

Show user customized values:

```shell
helm get values "$name"
```

Also repairs missing objects eg. a deleted svc:

```shell
helm upgrade "$name" -f values.yaml stable/mysql
```

`--reset-values` clears the custom config values:

```shell
helm upgrade "$name" stable/mysql --reset-values
```

```shell
helm uninstall "$name"  # --keep-history    - for 'helm status' to show as uninstalled
```

List all installed applications in all namespaces:

```shell
helm list --all-namespaces
```

or shorthand:

```shell
helm ls -A
```

See revisions deployed (starts at 1):

```shell
helm history "$name"
```

Can even undelete a release:

```shell
helm rollback "$name" "$revision"
```

Extract Chart and templates from cache, copy `values.yaml` to `custom.yaml`:

```text
~/.cache/helm/repository/mariadb-7.3.14.tgz
```

Install a chart from a local tarball:

```shell
helm install "$name" chart-0.1.1.tgz
```

Install a chart from a local directory containing the unpacked tarball contents seen in the
[Create Your Own Helm Chart](#create-your-own-helm-chart) section below:

```shell
helm install "$name" chart/
```

or

```shell
helm install "$name" https://.../foo-1.2.3.tgz
```

### Docker Registries

```shell
helm registry login -u myuser localhost:5000
```

```shell
helm registry logout
```

```shell
helm chart save mychart/ localhost:5000/myrepo/mychart:2.7.0
```

```shell
helm chart list
```

```shell
helm chart export localhost:5000/myrepo/mychart:2.7.0
```

```shell
helm chart push   localhost:5000/myrepo/mychart:2.7.0
```

```shell
helm chart pull   localhost:5000/myrepo/mychart:2.7.0
```

```shell
helm chart remove localhost:5000/myrepo/mychart:2.7.0
```

## Create Your Own Helm Chart

I personally prefer to create [Kustomize](kustomize.md) deployments for internal apps as they're more flexible and
you don't have to anticipate all variations and created template variables for them all up front.

But some people are still using Helm charts for internal apps, so here is how you do it.

### Create template

```shell
helm create "$name"
```

creates a `$name/` directory with `tree` contents:

```text
$name/
├── Chart.yaml   # names app and remote dependency charts
├── charts       # for dependency charts, you probably won't need this
├── templates    # K8s yaml content templates
│   ├── NOTES.txt
│   ├── _helpers.tpl
│   ├── deployment.yaml
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── service.yaml
│   ├── serviceaccount.yaml
│   └── tests
│       └── test-connection.yaml
└── values.yaml  # the file you usually configure for public charts

4 directories, 10 files
```

### Edit

Edit the `templates/` and `values.yaml` files to suit your needs.

Print the yaml that Helm generates:

```shell
helm template "$USER-test" .
```

### Lint

Defaults to checking `$PWD/Chart.yaml`:

```shell
helm lint
```

or given directory containing `Chart.yaml`:

```shell
helm lint "$name"
```

### Install Custom Chart

Install it from source assuming you're in the "$name/" directory to your currently configured Kubernetes `kubectl`
cluster context:

```shell
helm install "$USER-test" .
```

Generate `"$name"-0.1.0.tgz`

```shell
helm package "$name"
```

Install from tarball:

```shell
helm install "$name" ./"$name"-0.1.0.tgz
```

## Chart Repo

### GitHub

Turn a GitHub repo into helm chart repo:

<https://helm.sh/docs/howto/chart_releaser_action/>

### GCS

Manual Repo on [GCS](https://cloud.google.com/storage):

<https://helm.sh/docs/howto/chart_repository_sync_example/>

Create an index file supporting the given URL:

```shell
helm repo index "$chartsdir"/ --url https://"$bucket_name".storage.googleapis.com
```

Sync the dir to GCS to serve:

```shell
gsutil rsync -d "$chartsdir/" "gs://$bucket_name"
```

## Helm + Kustomize

### Kustomize + Helm dynamically

In [kustomization.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/kustomization.yaml):

```shell
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

helmCharts:
  - name: myapp
    repo: https://...
    version: 1.0.0
    releaseName: myrelease
    namespace: myapp
    includeCRDs: true
    valuesFile: values.yaml
```

### Kustomize + Helm statically

This has the benefit that you can revision control the helm yaml to see the diffs and control changes more tightly:

```shell
helm show values "$repo/$chart" > values.yaml
```

```shell
helm template "$name" "$repo/$chart" --version "$version" --values values.yaml > output.yaml
```

Add `output.yaml` to [kustomization.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/kustomization.yaml)
resources and run `kustomize build` and `kubectl apply` as usual:

```shell
kustomize build | kubectl apply -f -
```

You can then proceed to add standard Kustomize patches as usual too.

### Static Templating Helm Tarball

```shell
helm fetch --untar stable/mariadb
```

```shell
helm template -f values.yaml mariadb/ > mariadb.yaml
```

#### Longer way

```shell
mkdir -p charts
```

```shell
helm fetch \
  --untar \
  --untardir charts \
  stable/nginx-ingress
```

```shell
mkdir -p base
```

```shell
helm template \
  --name ingress-controller \
  --output-dir base \
  --namespace ingress \
  --values values.yaml \
  charts/nginx-ingress
```

```shell
mv base/nginx-ingress/templates/* base/nginx-ingress &&
rm -rf base/nginx-ingress/templates
```

Instantiate new [Templates](https://github.com/HariSekhon/Templates)

```shell
new namespace.yaml
```

```shell
new kustomization.yaml  # list all the *.yaml name under resources: and add patches to override/extend
```

## Old: Helm v2

```shell
curl https://git.io/get_helm.sh | bash
```

Create helm service acccount and grant it ClusterRole full access in GKE using [Template](https://github.
com/HariSekhon/Templates) repo:

```shell
kubectl apply -f "$templates/k8s_tiller-serviceaccount.yaml"
```

Installs Tiller in cluster - Tiller needs access to entire cluster and is going away:

```shell
helm init --service-account helm
```

```shell
kubectl get deploy,svc tiller-deploy -n system
```

Rest of commands are same as above sections.

Change from ClusterIP to LoadBalancer service:

```shell
helm upgrade --set service.type='LoadBalancer' myrelease stable/wordpress
```

Tiller will delete even persistent disks:

```shell
helm delete myrelease
```

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Kubernetes-configs&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Kubernetes-configs)

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=DevOps-Bash-tools&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/DevOps-Bash-tools)

**Ported from private Knowledge Base page 2019+**
