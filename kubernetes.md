# Kubernetes

## Local Dev

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) has a setting to enable kubernetes, easiest to use
- [MiniKube](https://minikube.sigs.k8s.io/docs/start/)
- [MiniShift](https://github.com/minishift/minishift) - for OpenShift upstream [okd](https://www.okd.io/)
- [K3d](https://k3d.io/v5.6.0/) - quickly boots a [K3s](https://k3s.io/) minimal kubernetes distro (fully functional)

## Kubernetes Configs

[HariSekhon/Kubernetes-configs](https://github.com/HariSekhon/Kubernetes-configs)

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


###### Partial port from private Knowledge Base page 2015+
