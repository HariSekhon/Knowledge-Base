# ArgoCD

## Install Quickly

Ready made config to deploy to Kubernetes - will immediately bring up a cluster:

[ArgoCD on Kubernetes Config](https://github.com/HariSekhon/Kubernetes-configs/tree/master/argocd)

Deploy from the overlay directory and edit the `ingress*.yaml` with the URL of the FQDN you want to use (you should
have configured ingress and cert-manager to get the SSL url available).

## Find the ArgoCD default admin password

```shell
kubectl -n argocd get secret -n argocd argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 --decode
```

## ArgoCD Kustomize + Helm Integration for GitOps

Have ArgoCD use [Kustomize](kustomize.md) to materialize Helm charts, patch and combine them with other yamls
such as custom ingresses and manage them all in a single ArgoCD app in a GitOps fashion:

[Kustomize Template](https://github.com/HariSekhon/Kubernetes-configs/blob/master/kustomization.yaml)

## ArgoCD templates

[Project Config Template](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/overlay/project.yaml)

[App Config Template](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/overlay/app.yaml)

## ArgoCD & Kubernetes Scripts

[DevOps-Bash-tools - Kubernetes section](https://github.com/HariSekhon/DevOps-Bash-tools#kubernetes)

## GitOps ArgoCD itself

[ArgoCD Self-Managing App Config](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/overlay/self.yaml)

### App-of-Apps Pattern

[App-of-Apps Config](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/overlay/apps.yaml) - have ArgoCD apps automatically found and loaded from any yamls found in the `/apps` directory

### App-of-Projects Pattern

[App-of-Projects Config](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/overlay/projects.yaml) - have projects automaticaly found and loaded from any yamls in the `projects/` directory

## GitHub Webhooks Integration

[GitHub Webhooks Integration Template](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/base/secret.github-webhook.patch.yaml)


## Azure AD Authentication for SSO

https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/microsoft/#azure-ad-app-registration-auth-using-oidc

[Azure AD Authentication Config Template](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/base/cm.azure-ad.patch.yaml)

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


###### Partial port from private Knowledge Base page 2021+
