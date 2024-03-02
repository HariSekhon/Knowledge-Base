# ArgoCD

https://argo-cd.readthedocs.io/en/stable/

Declarative GitOps Continuous Delivery for Kubernetes.

- Kubernetes native - everything is defined in k8s yamls via CRDs so easy to revision control + diff + apply all configs
- Project and Applications configurations must be installed to the `argocd` namespace for ArgoCD to pick them up
- Sync only detects / replaces parts that are different from the manifests in Git
  - if you add / change a field that is not in the Git manifests then ArgoCD won't change it as it doesn't change the entire object
- Projects restrict Git source, destination cluster + namespace, permissions
- Applications in project deploy k8s manifests from Git repo


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
```

or script in in [DevOps-Bash-tools](devops-bash-tools.md) figures out OS and downloads latest version:

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

## Azure AD Authentication for SSO

[Official Doc](https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/microsoft/#azure-ad-app-registration-auth-using-oidc)

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

https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/google/#openid-connect-using-dex

### Troubleshooting

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

#### ArgoCD web UI hands with "Loading" after Google login, check the logs:

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

https://github.com/argoproj/argo-cd/issues/17377

Two options in `argocd-rbac-cm` are given in [rbac-cm.patch.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/base/rbac-cm.patch.yaml):

1. find the group id and assign a role to assign in the policy line (preferred)
1. change `policy.default: role:readonly` to `policy.default: role:admin` (allows all users to click everything,
   but most will be reset by [GitOps ArgoCD itself](#gitops-argocd-itself) except for the Git repo connector)


###### Ported from private Knowledge Base page 2021+
