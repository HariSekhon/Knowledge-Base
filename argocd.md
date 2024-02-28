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

## GitOps ArgoCD itself

[ArgoCD Self-Managing App Config](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/overlay/self.yaml)

### App-of-Apps Pattern

[App-of-Apps Config](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/overlay/apps.yaml) - have ArgoCD apps automatically found and loaded from any yamls found in the `/apps` directory

### App-of-Projects Pattern

[App-of-Projects Config](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/overlay/projects.yaml) - have projects automaticaly found and loaded from any yamls in the `projects/` directory

## Azure AD Integration for SSO

[Azure AD Integration Config Template](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/base/cm.azure-ad.patch.yaml)

## GitHub Webhooks Integration

[GitHub Webhooks Integration Template](https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/base/secret.github-webhook.patch.yaml)

## ArgoCD & Kubernetes Scripts

[DevOps-Bash-tools - Kubernetes section](https://github.com/HariSekhon/DevOps-Bash-tools#kubernetes)

###### Partial port from private Knowledge Base 2021+
