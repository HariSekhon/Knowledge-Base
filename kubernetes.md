# Kubernetes

## Local Dev

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) has a setting to enable kubernetes, easiest to use
- [MiniKube](https://minikube.sigs.k8s.io/docs/start/)
- [MiniShift](https://github.com/minishift/minishift) - for OpenShift upstream [okd](https://www.okd.io/)
- [K3d](https://k3d.io/v5.6.0/) - quickly boots a [K3s](https://k3s.io/) minimal kubernetes distro (fully functional)
- [Kind](https://kind.sigs.k8s.io/) - Kubernetes in Docker for testing Kubernetes and use in [CI/CD](ci-cd.md).
Examples of its use are in the [HariSekhon/Kubernetes-configs](https://github.com/HariSekhon/Kubernetes-configs)
GitHub Actions CI/CD workflows.

## Kubernetes Configs

[HariSekhon/Kubernetes-configs](https://github.com/HariSekhon/Kubernetes-configs)

##### Security: most ingresses I write have IP filters to private addresses and Cloudflare Proxied IPs. You may need to expand this to VPN / office addresses, or the wider internet if you are running public services which really require direct public access without WAF proxied protection like Cloudflare

## Kubernetes Scripts

[DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools#kubernetes)
`kubernetes/` directory.

## Kubernetes `.envrc`

See [.envrc](envrc.md)

## Tips

- Ingresses:
  - use `name: http` for target instead of `number: 80` as some services use 80 and some 8080 so you'll get a 503 error if you get it wrong
  - compare the name and number to the service you're pointing to

## Troubleshooting

### Killing a Namespace that's stuck

If you see a namespace that is stuck deleting, you can force the issue at the risk of leaving some pods running:

```shell
kubectl delete ns "$NAMESPACE" --force --grace-period 0
```

Sometimes this isn't enough and it gets stucks on finalizers or cert-manager pending challenges:

```
NAME                                                                STATE     DOMAIN                 AGE
challenge.acme.cert-manager.io/jenkins-tls-1-1371220808-214553451   pending   jenkins.domain.co.uk   3h1m
```

Use this script from [DevOps-Bash-tools](devops-bash-tools.md) `kubernetes/` directory which kills everything via API
patching:

```shell
kubernetes_delete_stuck_namespace.sh <namespace>
```

###### Partial port from private Knowledge Base page 2015+
