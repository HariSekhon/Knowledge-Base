# Jenkins

## Quick Jenkins in Docker and SysAdmin Scripts

https://github.com/HariSekhon/DevOps-Bash-tools#cicd---continuous-integration--continuous-deployment

## Jenkins Shell Scripts

Scripts for common Jenkins operations using the Jenkins CLI and API:

https://github.com/HariSekhon/DevOps-Bash-tools/tree/master/jenkins

## Jenkins Groovy

[Groovy](groovy.md) is the language of Jenkins, and it is awesome.

If you want to do anything advanced in Jenkins, you need to know Groovy.

### Jenkins Groovy Console

You can paste Groovy code snippets into the Script Console in Jenkins, which is located at:

`$JENKINS_URL/script`

Some `*.groovy` scripts are mixed in between the shell scripts
[here](https://github.com/HariSekhon/DevOps-Bash-tools/tree/master/jenkins).

## Jenkins Shared Libraries (Groovy)

https://github.com/HariSekhon/Jenkins

## Jenkins on Kubernetes

Configs are here:

https://github.com/HariSekhon/Kubernetes-configs?tab=readme-ov-file#jenkins-on-kubernetes

### Default Admin Password

```shell
kubectl get secret -n jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
```

### Reset your admin password on Kubernetes

```shell
kubectl exec -ti -n jenkins jenkins-0 -c jenkins -- /bin/bash
```
inside the container:
```shell
sed -i 's|<useSecurity>true</useSecurity>|<useSecurity>false</useSecurity>|' /var/jenkins_home/config.xml
# check it worked
grep -i useSecurity /var/jenkins_home/config.xml
exit
```

```shell
kubectl rollout restart sts jenkins
```
This seems to not come up without auth like on an installed instance but resets to use the default admin password:

```shell
kubectl get secret -n jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
```

## Troubleshooting

### Shell "process apparently never started in"

Execute in Script Console at `$JENKINS_URL/`:
```groovy
org.jenkinsci.plugins.durabletask.BourneShellScript.LAUNCH_DIAGNOSTICS=true
```
