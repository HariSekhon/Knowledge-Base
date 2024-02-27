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

Configs are here:

[HariSekhon/Kubernetes-configs](https://github.com/HariSekhon/Kubernetes-configs#readme)
`jenkins/` directory

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
