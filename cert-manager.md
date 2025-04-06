# Cert Manager

[:octocat: jetstack/cert-manager](https://github.com/jetstack/cert-manager)

Automatic SSL certificates generated for your Kubernetes ingresses.

Cert Manager is awesome - except when you're stuck on the config or debugging why you're not getting certificates.

Free certs provided by LetsEncrypt CA integration.

ACME - Automated Certificate Management Environment.

<!-- INDEX_START -->

- [Config](#config)
- [DNS Integration Secret](#dns-integration-secret)
- [Troubleshooting](#troubleshooting)

<!-- INDEX_END -->

## Config

[HariSekhon/Kubernetes-configs - cert-manager](https://github.com/HariSekhon/Kubernetes-configs/tree/master/cert-manager)

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Kubernetes-configs&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Kubernetes-configs)

## DNS Integration Secret

If using DNS integration you'll need a secret or a service account for Cert Manager to create the ACME challenge DNS
records.

See the specific DNS configuration either in the configs above or the official docs.

eg for [Cloudflare](cloudflare.md):

```shell
kubectl create secret generic cloudflare-api-token --from-literal=cloudflare-api-token="$CLOUDFLARE_TOKEN"
```

This secret must match the the specific DNS provider's Issuer / ClusterIssuer config to source it.

## Troubleshooting

If you're not getting your SSL cert or having cert warning in your browser, check Cert Manager logs:

```shell
kubectl logs -f -n cert-manager deploy/cert-manager
```

If you see an error like this:

```text
E0229 18:07:30.022849       1 sync.go:126] "Failed to determine the list of Challenge resources needed for the Order" err="no configured challenge solvers can be used for this challenge" logger="cert-manager.orders" resource_name="jenkins-tls-1-2062037248" resource_namespace="jenkins" resource_kind="Order" resource_version="v1"
```

Start debugging the cert manager objects:

```shell
kubectl api-resources | grep cert
```

```shell
kubectl get certificaterequests -n "$NAMESPACE"
```

output:

```text
NAME            APPROVED   DENIED   READY   ISSUER        REQUESTOR                                         AGE
jenkins-tls-1   True                False   letsencrypt   system:serviceaccount:cert-manager:cert-manager   1d
```

Get more info:

```shell
kubectl describe certificaterequests -n "$NAMESPACE"
```

The second `Message` line says it's pending on the order:

```text
Status:
  Conditions:
    Last Transition Time:  2024-02-26T17:54:50Z
    Message:               Certificate request has been approved by cert-manager.io
    Reason:                cert-manager.io
    Status:                True
    Type:                  Approved
    Last Transition Time:  2024-02-26T17:54:50Z
    Message:               Waiting on certificate issuance from order jenkins/jenkins-tls-1-2062037248: "pending"
    Reason:                Pending
    Status:                False
    Type:                  Ready
Events:                    <none>
```

Investigate the order:

```shell
kubectl get orders -n "$NAMESPACE"
```

and you see it is stuck in `pending`:

```text
NAME                       STATE     AGE
jenkins-tls-1-2062037248   pending   1d
```

you can tab-complete this annoying name if you've included [kubectl autocomplete](https://kubernetes.io/docs/reference/kubectl/quick-reference/#bash) (done automatically in [DevOps-Bash-tools](devops-bash-tools.md) environment):

```shell
kubectl describe orders -n "$NAMESPACE" jenkins-tls-1-2062037248
```

output:

```text
Events:
  Type     Reason  Age                From                 Message
  ----     ------  ----               ----                 -------
  Warning  Solver  40m (x3 over 15h)  cert-manager-orders  Failed to determine a valid solver configuration for the set of domains on the Order: no configured challenge solvers can be used for this challenge
  Warning  Solver  30m                cert-manager-orders  Failed to determine a valid solver configuration for the set of domains on the Order: no configured challenge solvers can be used for this challenge
```

Commenting out this section in the `ClusterIssuer` enabled it to work:

```yaml
        #selector:
        #  dnsNames:
        #    - domain.co.uk
        #    - domain.com
```

Even though these match and have been used before. Possible bug as I've done exactly this before in production for years and it worked.

I triple checked the domain names and tried with different domains, same result.

<https://github.com/cert-manager/cert-manager/issues/6528>
