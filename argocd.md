# ArgoCD

## Install Quickly

Ready made config to deploy to Kubernetes - will immediately bring up a cluster:

https://github.com/HariSekhon/Kubernetes-configs/tree/master/argocd

Deploy from the overlay directory and edit the `ingress*.yaml` with the URL of the FQDN you want to use (you should
have configured ingress and cert-manager to get the SSL url available).

## Find the ArgoCD default admin password

```shell
kubectl -n argocd get secret -n argocd argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 --decode
```

## ArgoCD templates

Project:

https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/overlay/project.yaml

App:

https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/overlay/app.yaml

## GitOps ArgoCD itself:

https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/overlay/self.yaml

### App-of-Apps Pattern

Have ArgoCD apps automatically found and loaded from any yamls found in the `/apps` directory:

https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/overlay/apps.yaml

### App-of-Projects Pattern

Have projects automaticalyly found and loaded from any yamls in the `projects/` directory:

https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/overlay/projects.yaml

## Azure AD Integration for SSO

https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/base/cm.azure-ad.patch.yaml

## GitHub Webhooks Integration

https://github.com/HariSekhon/Kubernetes-configs/blob/master/argocd/base/secret.github-webhook.patch.yaml

## ArgoCD & Kubernetes Scripts:

https://github.com/HariSekhon/DevOps-Bash-tools#kubernetes
