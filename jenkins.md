# Jenkins

## Quick Jenkins in Docker and SysAdmin Scripts

[HariSekhon/DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools#cicd---continuous-integration--continuous-deployment)

## Jenkins Shell Scripts

Scripts for common Jenkins operations using the Jenkins CLI and API:

[HariSekhon/DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools/tree/master/jenkins)
`jenkins/` directory.

## Jenkins Groovy

[Groovy](groovy.md) is the language of Jenkins, and it is awesome.

If you want to do anything advanced in Jenkins, you need to know Groovy.

### Jenkins Groovy Console

You can paste Groovy code snippets into the Script Console in Jenkins, which is located at:

`$JENKINS_URL/script`

Some `*.groovy` scripts are mixed in between the shell scripts
[here](https://github.com/HariSekhon/DevOps-Bash-tools/tree/master/jenkins).

## Jenkins Shared Libraries (Groovy)

[HariSekhon/Jenkins](https://github.com/HariSekhon/Jenkins) repo.

## Jenkins Google Auth Plugin

[jenkinsci/google-login-plugin](https://github.com/jenkinsci/google-login-plugin) repo.

## Jenkins on Kubernetes

[HariSekhon/Kubernetes-configs](https://github.com/HariSekhon/Kubernetes-configs#jenkins-on-kubernetes)

Configs are in the `jenkins/` directory.

### Default Admin User + Password

User:
```shell
kubectl get secret -n jenkins jenkins -o 'jsonpath={.data.jenkins-admin-user}' | base64 --decode
```

Password:
```shell
kubectl get secret -n jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
```

WARNING: The Jenkins admin password secret gets changed to a new random value every time you apply the Jenkins Helm
chart via Kustomize (see [bug report](https://github.com/jenkinsci/helm-charts/issues/1026))

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
above won't work with the Jenkins helm chart because it resets the admin password from the secret every pod restart
due to JCasC.

Stop the helm chart from recreating the secret every time by setting this in the chart `values.yaml`:
```yaml
controller:
  admin:
    existingSecret: jenkins
```

```shell
kubectl rollout restart sts jenkins
```

Then recover the initial admin password to log in:
```shell
kubectl get secret -n jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
```

## CloudBees

Managed hosted Jenkins control plane.

Runs Jenkins controllers and agents on your own Kubernetes.

Commercial proprietary management layer

Licensed by number of users, not build minutes since that is run locally.

https://docs.cloudbees.com/docs/cloudbees-ci/latest/feature-definition

### Pricing

Roughly $1k per user + VAT, depending on whether 8x5 or 24x7 support. Prices are always subject to change,
negotiation and scale.

### Install CloudBees on Kubernetes

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

```shell
[KO] Ingress service exists
```

output from a live EKS cluster:

```shell
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

```
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

## Troubleshooting

### Reset the Jenkins admin password

On a traditional Jenkins install (not using the Kubernetes helm chart, see Kubernetes section for that):

SSH to the jenkins server and run:

```shell
sed -i 's|<useSecurity>true</useSecurity>|<useSecurity>false</useSecurity>|' "$JENKINS_HOME/config.xml"
# check it worked
grep -i useSecurity "$JENKINS_HOME/config.xml"
```
Then restart Jenkins, access it without auth, update the admin password, undo the config change, and restart again.

### Shell "process apparently never started in"

Execute in Script Console at `$JENKINS_URL/script`:
```groovy
org.jenkinsci.plugins.durabletask.BourneShellScript.LAUNCH_DIAGNOSTICS=true
```

## Jenkins on Kubernetes Diagram

![](https://raw.githubusercontent.com/HariSekhon/Diagrams-as-Code/master/images/jenkins_kubernetes_cicd.svg)

###### Partial port from private Knowledge Base page 2013+
