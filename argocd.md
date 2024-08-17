# ArgoCD

https://argo-cd.readthedocs.io/en/stable/

Declarative GitOps Continuous Delivery of applications on Kubernetes.

- Good UI
- Kubernetes native - everything is defined in k8s yamls via CRDs so easy to
  [GitOps ArgoCD itself](#gitops-argocd-itself)
- Can manage multiple Kubernetes clusters (although you might want to split this for scaling)
- Project and Applications configurations must be installed to the `argocd` namespace for ArgoCD to pick them up
- Sync only detects / replaces parts that are different from the manifests in Git
  - if you add / change a field that is not in the Git manifests then ArgoCD won't change it as it doesn't change the entire object
- Projects restrict Git source, destination cluster + namespace, permissions
- Applications in project deploy k8s manifests from Git repo
- Active community

<!-- INDEX_START -->
- [Install Quickly](#install-quickly)
- [Find the ArgoCD default admin password](#find-the-argocd-default-admin-password)
- [ArgoCD templates](#argocd-templates)
- [ArgoCD & Kubernetes Scripts](#argocd--kubernetes-scripts)
- [ArgoCD Kustomize + Helm Integration for GitOps](#argocd-kustomize--helm-integration-for-gitops)
- [GitOps ArgoCD itself](#gitops-argocd-itself)
  - [App-of-Apps Pattern](#app-of-apps-pattern)
  - [App-of-Projects Pattern](#app-of-projects-pattern)
- [GitHub Webhooks Integration](#github-webhooks-integration)
- [ArgoCD CLI](#argocd-cli)
  - [Authenticate the CLI](#authenticate-the-cli)
- [Clusters](#clusters)
- [Applications](#applications)
- [Azure AD Authentication for SSO](#azure-ad-authentication-for-sso)
- [Google Authentication for SSO](#google-authentication-for-sso)
  - [Troubleshooting GCP Auth](#troubleshooting-gcp-auth)
- [GitHub Webhooks](#github-webhooks)
- [CI/CD - Jenkins CI -> ArgoCD Integration](#cicd---jenkins-ci---argocd-integration)
- [Prometheus metrics + Grafana dashboard](#prometheus-metrics--grafana-dashboard)
- [Notifications](#notifications)
- [Troubleshooting](#troubleshooting)
  - [Kustomize Manifest Generation Error](#kustomize-manifest-generation-error)
  - [Manifest cached error not updating in an hour](#manifest-cached-error-not-updating-in-an-hour)
- [#kubectl delete -n argocd "$pod"](#kubectl-delete--n-argocd-pod)
<!-- INDEX_END -->

#### Components

- `argocd-server` - API server & UI
- `argocd-application-controller` - monitors live k8s vs repo
- `argocd-repo-server` - maintains cache of git repo + generates k8s manifests (kustomize/helm)

## Install Quickly

Ready made config to deploy to Kubernetes - will immediately bring up a cluster:

[ArgoCD on Kubernetes Config](https://github.com/HariSekhon/Kubernetes-configs/tree/master/argocd)

Deploy from the overlay directory and edit the `ingress*.yaml` with the URL of the FQDN you want to use (you should
have configured ingress and cert-manager to get the SSL url available).

## Find the ArgoCD default admin password

```shell
kubectl -n argocd get secret -n argocd argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 --decode
```

## ArgoCD templates

[Project Config Template](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/overlay/project.yaml)

[App Config Template](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/overlay/app.yaml)

## ArgoCD & Kubernetes Scripts

[DevOps-Bash-tools - Kubernetes section](https://github.com/HariSekhon/DevOps-Bash-tools#kubernetes)

## ArgoCD Kustomize + Helm Integration for GitOps

Have ArgoCD use [Kustomize](kustomize.md) to materialize Helm charts, patch and combine them with other yamls
such as custom ingresses and manage them all in a single ArgoCD app in a GitOps fashion:

[Kustomize Template](https://github.com/HariSekhon/Kubernetes-configs/blob/master/kustomization.yaml)

## GitOps ArgoCD itself

Revision control and diff all ArgoCD configuration by defining it all in YAMLs using native K8s objects defined by CRDs.

[ArgoCD Self-Managing App Config](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/overlay/self.yaml)

### App-of-Apps Pattern

[App-of-Apps Config](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/overlay/apps.yaml) - have ArgoCD apps automatically found and loaded from any yamls found in the `/apps` directory

### App-of-Projects Pattern

[App-of-Projects Config](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/overlay/projects.yaml) - have projects automaticaly found and loaded from any yamls in the `projects/` directory

## GitHub Webhooks Integration

[GitHub Webhooks Integration Template](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/base/secret.github-webhook.patch.yaml)

## ArgoCD CLI

On Mac:

```shell
brew install argocd
```

or download from server for either Mac or Linux:

```shell
os="$(uname -s | tr '[:upper:]' '[:lower:]')"
mkdir -p -v ~/bin
curl -L -o ~/bin/argocd "https://$ARGOCD_HOST/download/argocd-$os-amd64" &&
chmod +x ~/bin/argocd
export PATH="$PATH:$HOME/bin"
```

or script in in [DevOps-Bash-tools](devops-bash-tools.md) repo which figures out the OS and downloads the latest CLI
version binary from GitHub:

```shell
install_argocd.sh
```

### Authenticate the CLI

Get the initial admin password:

```shell
PASSWORD="$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 --decode)"
```

`ARGOCD_HOST` must not have an `https://` prefix

```shell
argocd login "$ARGOCD_HOST" --username admin --password "$PASSWORD" --grpc-web
```

or use the `argocd-grpc.domain.com` url if you've set up the extra ingress, but this didn't work in testing.

Change admin password - can delete the obsolete `argocd-initial-admin-secret` after that as its no longer used:

```shell
argocd account update-password
```

Generate long lived JWT
[token](https://argo-cd.readthedocs.io/en/stable/user-guide/commands/argocd_account_generate-token/)
(this environment variable keeps the CLI authenticated).
Requires enabling `apiKey` permission using
[cm.users.patch.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/base/cm.users.patch.yaml).

```shell
export ARGOCD_AUTH_TOKEN="$(argocd account generate-token)"
```

Create an SSH key for Private Repo access:

```shell
ssh-keygen -f ~/.ssh/argocd_github_key
```

Load it to a Kubernetes secret which is referenced from
[cm-repos.patch.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/base/cm.repos.patch.yaml):

```shell
kubectl create secret generic github-ssh-key -n argocd --from-file=private-key=$HOME/.ssh/argocd_github_key
```

## Clusters

Add clusters to deploy to.

If you're only deploying to the local cluster where ArgoCD UI is running then you can just use ``

Find cluster's context name from your local kubeconfig:

```shell
kubectl config get-contexts -o name
```

Add the cluster from the kubectl cluster context configuration:

```shell
argocd cluster add "$context_name"  # --grpc-web avoids warning message connecting through https ingress
```

Installs `argocd-manager` to `kube-system` namespace in this cluster with admin `ClusterRole`.

## Applications

Add Applications to deploy to clusters.

Create and apply an [argocd-app.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/overlay/app.yaml)
and let ArgoCD deploy it.

You can also deploy an app imperatively via the CLI, although this should not be done for serious work which should go
through GitOps using above template.

```shell
kubectl create ns guestbook
```

```shell
argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git \
                            --path guestbook \
                            --dest-server https://kubernetes.default.svc \
                            --dest-namespace guestbook \
                            --grpc-web
```

`--dest-server https://kubernetes.default.svc` -
means in-cluster. Specify external Master URL for deploying to other clusters.

List all ArgoCD apps:

```shell
argocd app list
```

Get info on the specific `guestbook` app we just deployed:

```shell
argocd app get guestbook
```

Trigger a sync of the `guestbook` app.

```shell
argocd app sync guestbook
```

Override image version to deploy for Dev / Staging environments:

This command only overrides this exact `image` with the new `tag`:

```shell
argocd app set "$name" --kustomize-image "eu.gcr.io/$CLOUSDK_CORE_PROJECT/$image:$tag"
```

## Azure AD Authentication for SSO

[Official Doc - Azure AD auth](https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/microsoft/#azure-ad-app-registration-auth-using-oidc)

[Azure AD Authentication Config Template](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/base/cm.azure-ad.patch.yaml)

For CLI access:

- add section for `Mobile & Desktop applications` with URI `https://$ARGOCD_HOST/auth/callback`
- App Registration section:
  - Authentication page:
    - set `Allow public client flows` to `Yes` at the bottom
    - to work around [this issue](https://github.com/argoproj/argo-cd/issues/6462)

[Medium article on Azure AD auth](https://medium.com/dzerolabs/configuring-sso-with-azure-active-directory-on-argocd-d20be4ba753b)

## Google Authentication for SSO

Remember: don't git commit the `argocd-cm` configmap addition of the `dex.config` key on that page which contains the `clientID` and `clientSecret`.

It's not necessary to expose this in Git as ArgoCD self-management won't strip out the field since there is no such field in the Git configmap.

[Official Doc - Google auth](https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/google/#openid-connect-using-dex)


### Troubleshooting GCP Auth

#### Getting immediately kicked back out when clicking the `Log in via Google` button

```shell
kubectl logs -f -n argocd deploy/argocd-server
```

If you see this:

```
level=info msg="finished unary call with code OK" grpc.code=OK grpc.method=Get grpc.service=cluster.SettingsService grpc.start_time="2024-03-02T01:41:21Z" grpc.time_ms=100.663 span.kind=server system=grpc
```

Even a browser hard refresh doesn't solve it.

A restart the ArgoCD server pod fixes it:

````shell
kubectl rollout restart deploy/argocd-server
````

Seems like a [bug](https://github.com/argoproj/argo-cd/issues/13526).

#### ArgoCD web UI hands with "Loading" after Google login, check the logs

```shell
kubectl logs -f -n argocd deploy/argocd-server
```

If you see this error:

```
level=warning msg="Failed to verify token: failed to verify token: Failed to query provider
\"https://argocd-production.domain.co.uk/api/dex\": Get \"https://argocd-production.domain.co.uk/api/dex/.well-known/openid-configuration\": dial tcp 10.x.x.x:443: i/o timeout"
```

There is no reason the pods shouldn't be able to connect to the internal ingress as all private IPs are allows in the [config]():

After brain racking, it turns out a reboot of the argocd-server pod after Dex configuration solves it:

````shell
kubectl rollout restart deploy/argocd-server
````

I have no explanation for this behaviour other than it's a probable [bug](https://github.com/argoproj/argo-cd/issues/17378)
that gets solved by a resetting the argocd-server state.

#### RBAC user wildcard `*` does not work in `policy.csv`

[GitHub Issue](https://github.com/argoproj/argo-cd/issues/17377)

Two options in `argocd-rbac-cm` are given in [rbac-cm.patch.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/base/rbac-cm.patch.yaml):

1. find the group id and assign a role to assign in the policy line (preferred)
1. change `policy.default: role:readonly` to `policy.default: role:admin` (allows all users to click everything,
   but most will be reset by [GitOps ArgoCD itself](#gitops-argocd-itself) except for the Git repo connector)

## GitHub Webhooks

For faster triggers than polling GitHub repo:

[Official Doc - webhooks](https://argoproj.github.io/argo-cd/operator-manual/webhook/)

## CI/CD - Jenkins CI -> ArgoCD Integration

[Official Doc - Automation from CI Pipelines](https://argoproj.github.io/argo-cd/user-guide/ci_automation/)

Update the image version in a Git repo which ArgoCD watches.

If using [Kustomize](kustomize.md), this is the easiest way to update the version number,
Jenkins can run this in shell steps, like this Jenkins Shared Library -
[gitKustomizeImage.groovy](https://github.com/HariSekhon/Jenkins/blob/master/vars/gitKustomizeImage.groovy):

```shell
kustomize edit set image eu.gcr.io/myimage:v2.0
git add . -m "Jenkins updated myimage to v2.0"
git push
```

Ensure ArgoCD CLI is configured and authenticated via these environment variables:

```shell
export ARGOCD_SERVER=argocd.mycompany.com
export ARGOCD_AUTH_TOKEN=<JWT token generated from project>  # further up under setting up CLI
```

Trigger a sync of the ArgoCD app to not wait for it to detect the change, and have your CI/CD pipeline wait for the
result, like this Jenkins Shared Library -
[argoDeploy.groovy](https://github.com/HariSekhon/Jenkins/blob/master/vars/argoDeploy.groovy) and
[argoSync.groovy](https://github.com/HariSekhon/Jenkins/blob/master/vars/argoSync.groovy):

```shell
argocd app sync "$app"
argocd app wait "$app"
```

See the [HariSekhon/Jenkins](https://github.com/HariSekhon/Jenkins) Shared Library for more production code related to
ArgoCD, [Docker](docker.md), [GCP](gcp.md) and other technologies.

## Prometheus metrics + Grafana dashboard

[Official Doc - metrics](https://argoproj.github.io/argo-cd/operator-manual/metrics/)

## Notifications

[Official Doc - notifications](https://argo-cd.readthedocs.io/en/stable/operator-manual/notifications/)

## Troubleshooting

### Kustomize Manifest Generation Error

Upgrade to Kustomize 4 - see
[repo-server.kustomize.patch.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/base/repo-server.kustomize.patch.yaml)
for how to download a newer version than ArgoCD bundles.

### Manifest cached error not updating in an hour

1. UI Refresh button drop down -> hard refresh
1. delete the /tmp cache in `argocd-repo-server` pod:

```shell
pod=$(kubectl get po -n argocd -o name -l app.kubernetes.io/name=argocd-repo-server)
kubectl exec -ti -n argocd "$pod" -- sh -c 'rm -rf /tmp/*'
#kubectl delete -n argocd "$pod"
```

###### Ported from private Knowledge Base page 2021+
