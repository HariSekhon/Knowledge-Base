# Jenkins

The most powerful CI/CD ever.

Simple at the shallow end (see [Jenkins in Docker in one command](#jenkins-in-docker-in-one-command)).

Non-trivial at the advanced end (auto-scaling on [Kubernetes](#jenkins-on-kubernetes),
Jenkins [Plugins](#jenkins-plugins),
Groovy [Shared Library](#jenkins-shared-libraries-groovy) programming).

At least intermediate level Groovy programming is mandatory once you start using
Shared Libraries between pipelines, or even code snippets in the administration
[Script Console](#jenkins-script-console---groovy).

<!-- INDEX_START -->
- [Jenkinsfile - Scripted vs Declarative pipelines](#jenkinsfile---scripted-vs-declarative-pipelines)
  - [Declarative](#declarative)
  - [Scripted](#scripted)
  - [Jenkinsfile Snippet Generator](#jenkinsfile-snippet-generator)
- [Quick Jenkins in Docker and SysAdmin Scripts](#quick-jenkins-in-docker-and-sysadmin-scripts)
- [Jenkins CLI](#jenkins-cli)
- [Jenkins Shell Scripts](#jenkins-shell-scripts)
- [Jenkins Plugins](#jenkins-plugins)
  - [Restarts](#restarts)
- [Jenkins Jobs auto-saved to Git](#jenkins-jobs-auto-saved-to-git)
- [Jenkins Groovy](#jenkins-groovy)
  - [Jenkins Script Console - Groovy](#jenkins-script-console---groovy)
- [Jenkins Shared Libraries (Groovy)](#jenkins-shared-libraries-groovy)
- [Jenkins API](#jenkins-api)
- [Desktop Menu Notifications](#desktop-menu-notifications)
  - [CCtray XML Plugin](#cctray-xml-plugin)
- [Jenkins on Docker in one command](#jenkins-on-docker-in-one-command)
- [Jenkins Slaves on Bare Metal / VMs](#jenkins-slaves-on-bare-metal--vms)
- [Jenkins on Kubernetes](#jenkins-on-kubernetes)
- [Google Auth SSO](#google-auth-sso)
- [Azure AD auth SSO](#azure-ad-auth-sso)
- [CloudBees](#cloudbees)
  - [Pricing](#pricing)
  - [CloudBees on Kubernetes](#cloudbees-on-kubernetes)
- [Jenkins X](#jenkins-x)
- [Tips](#tips)
- [Troubleshooting](#troubleshooting)
  - [Reset the Jenkins admin password](#reset-the-jenkins-admin-password)
  - [Shell "process apparently never started in"](#shell-process-apparently-never-started-in)
- [Other Resources](#other-resources)
<!-- INDEX_END -->

## Jenkinsfile - Scripted vs Declarative pipelines

### Declarative

- newer
- adds SCM Checkout stage by default
- can Restart from Stage (not available in Scripted Pipelines)
- def variable outside of pipeline block
- use script block to get the mutation variable benefits of scripted pipeline

### Scripted

- older
- can use Groovy programming code like in shared libraries

### Jenkinsfile Snippet Generator

```
$JENKINS_URL/pipeline-syntax/
```

## Quick Jenkins in Docker and SysAdmin Scripts

[HariSekhon/DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools#cicd---continuous-integration--continuous-deployment)

Get the default initial admin password quickly from Docker or Kubernetes by running:

```shell
jenkins_password.sh
```

## Jenkins CLI

Download:

```shell
wget "$JENKINS_URL/jnlpJars/jenkins-cli.jar"
```

Run:

```shell
java -jar jenkins-cli.jar help
```

[jenkins_cli.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/jenkins/jenkins_cli.sh)
does this automatically and its `--help` tells you what sorts of environment variables you need for auth and
connectivity which the jar is not good at.

## Jenkins Shell Scripts

Scripts for common Jenkins operations using the Jenkins CLI and API:

[HariSekhon/DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools/tree/master/jenkins)
`jenkins/` directory.

## Jenkins Plugins

https://plugins.jenkins.io/

Plugins are the greatest strength and weakness of Jenkins, depending on how you look at it.

Jenkins has all of the power but also the complexity of managing the extensions, additional configuration and plugin
upgrades.


To get a list of plugins on an existing Jenkins server, one per line:

```shell
java -jar jenkins-cli.jar -s "$JENKINS_URL" list-plugins | awk '{print $1}' | sort
```

See here for a great list of plugins that I've used in production across companies:

[HariSekhon/Kubernetes - jenkins/base/values.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/54ad50efc573f7a69b36be1bd504d0e214fa73b5/jenkins/base/values.yaml#L136)

### Restarts

Waits for builds to finish:

```
$JENKINS_URL/safeRestart
```

Doesn't wait for builds to finish:

```
$JENKINS_URL/restart
```

## Jenkins Jobs auto-saved to Git

Auto-backport Jenkins job XML configurations to Git for tracking, diffing and reloading in case of disaster recovery.

Groovy shared library function:

[jenkinsJobsDownloadConfigurations.groovy](https://github.com/HariSekhon/Jenkins/blob/master/vars/jenkinsJobsDownloadConfigurations.groovy)

or script it yourself by calling one of these scripts and then Git committing the downloaded XMLs:

[jenkins_jobs_download_configs.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/jenkins/jenkins_jobs_download_configs.sh)

[jenkins_jobs_download_configs_cli.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/jenkins/jenkins_jobs_download_configs_cli.sh)

Inspired by [Rancid](https://shrubbery.net/rancid/) which I was using 2010-2013 to back up my Cisco & Juniper
network configurations to Subversion and later Git (I hacked the code to support the latter). I've written similarly
functional code Git backport code for other systems like IBM BigInsights, Datameer etc.
([DevOps-Perl-tools](devops-perl-tools.md) repo).

## Jenkins Groovy

[Groovy](groovy.md) is the language of Jenkins, and it is awesome.

If you want to do anything advanced in Jenkins, you need to know Groovy.

### Jenkins Script Console - Groovy

You can paste Groovy code snippets into the Script Console in Jenkins, which is located at:

`$JENKINS_URL/script`

Some `*.groovy` scripts are mixed in between the shell scripts
[here](https://github.com/HariSekhon/DevOps-Bash-tools/tree/master/jenkins).

## Jenkins Shared Libraries (Groovy)

[HariSekhon/Jenkins](https://github.com/HariSekhon/Jenkins) repo.

Functions should either follow java reverse fqdn naming convention or more simple flat `vars/funcName.groovy`.
Filename must be camelCase or lowercase to work.

Configure the Jenkins Shared Library repo containing the Groovy code in the global System Configuration
and give it a name for easy referencing:

```
Configure Jenkins
-> Configure System
    -> Global Pipeline Libraries
        -> Add - give a NAME and point it to Git repo where var/ content is
```

Then in `Jenkinsfile` reference the named configured repo


```groovy
@Library('NAME@branchOrTag') _
```

`@branch/tag` suffix is required, otherwise gets `ERROR: No version specified for library NAME`

Trailing underscore `_` is required to import all functions, otherwise syntax error from next token:

```groovy
 org.codehaus.groovy.control.MultipleCompilationErrorsException: startup failed:

 WorkflowScript: 3: unexpected token: pipeline @ line 3, column 1.

    pipeline {
 ```

Or using the [pipeline-github-lib](https://plugins.jenkins.io/pipeline-github-lib/) plugin you can use a dynamic repo via URL path
to a public git repo - this is useful for development pointing to a dev repo / branch:

```groovy
@Library('github.com/harisekhon/jenkins@master') _
```

Then call functions at top level of `Jenkinsfile` if inserting a whole Pipeline,
or within a `steps{}` section if inserting normal functions.

```groovy
funcName("param1", "param2")
```

#### External Scripts

Don't use external shell scripts or similar as they have to be in the source repo, not the shared library repo,
so you can't actually share such external scripts among different builds in different repos without checking them out
from another git repo as a separate step in the `Jenkinsfile` pipeline because otherwise the script won't be found.

## Jenkins API

See [jenkins_api.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/jenkins/jenkins_api.sh)

```
/api/json
```

```
/job/$job/api/json
```

```
curl "$JENKINS_URL/job/test%20ok/api/json?pretty=true"
```

## Desktop Menu Notifications

- [CCMenu](https://ccmenu.org/) - Mac OSX menu watcher
- [BuildNotify](https://anaynayak.github.io/buildnotify/) - for Linux

### CCtray XML Plugin

Provides the `/cc.xml/` endpoint for notification tools above.

https://plugins.jenkins.io/cctray-xml/

Then put this in your CCMenu or similar tool:

```shell
<JENKINS_URL>/cc.xml/
```

## Jenkins on Docker in one command

From the [DevOps-Bash-tools](devops-bash-tools.md) repo:

```shell
jenkins/jenkins.sh
```

- boots Jenkins in Docker
- installs plugins
- prints admin creds to stdout
- creates a Pipeline build job for the local repo
- executes the build job
- automatically opens the Jenkins UI on Mac, or prints the url on Linux

Uses [docker-compose/jenkins.yml](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/docker-compose/jenkins.yml)
- , can optionally edit config to:
  - use `JAVA_OPTS` to tweak heap size
  - mount `/var/jenkins_home` to local machine for persistence

## Jenkins Slaves on Bare Metal / VMs

- Manage Jenkins
  - Nodes
    - New Node
      - use [ssh-slaves](https://plugins.jenkins.io/ssh-slaves/)
        plugin to automatically deploy agents via pre-distributed SSH keys on the servers

## Jenkins on Kubernetes

See [Jenkins-on-Kubernetes](jenkins-on-kubernetes.md)

## Google Auth SSO

[jenkinsci/google-login-plugin](https://github.com/jenkinsci/google-login-plugin)

Note: don't commit the JCasC security `googleOAuth2` section to Git as it contains the `clientId` and `clientSecret`.
Just delete the security `local` so that it doesn't overwrite and revert to local authentication.

Instructions are in this [README.md](https://github.com/jenkinsci/google-login-plugin/blob/master/README.md).

## Azure AD auth SSO

In Azure AD UI:

- `App Registrations`
  - `New Registration`
    - Overview - get the `Application (client) ID` and `Directory (tenant) ID`
    - `Authentication`
      - set `Redirect URI` to be `https://$JENKINS_URL/securityRealm/finishLogin` substituting your real jenkins url
      - tick `ID tokens`
    - `API Permissions`
      - `Azure Active Directory Graph`
        - `Directory.Read.All (Delegated)`
        - `Directory.Read.All (Application)`
        - `User.Read.All (Delegated)`
      - `Microsoft Graph`
        - `Directory.Read.All (Delegated)`
        - `Directory.Read.All (Application)`
        - `User.Read (Delegated)`
        - `User.Read.All (Application)`
      - if you have perms click `Grant admin consent for MyCompany` before this will work to be able to read groups, requires AAD Admin permission
    - `Certificates & Secrets` -> `New client secret` (copy and paste to Jenkins)
    - `Manifest` -> change `"groupMembershipClaims": null` to "`groupMembershipClaims": "SecurityGroup"`, which combined with the Authentication ID tokens sends the group info in the token (it still won't show up in the Jenkins user info, but it works and gets rid of the lack of permissions to retrieve group error)
      - see https://github.com/jenkinsci/azure-ad-plugin/blob/dev/README.md#group-support

In Jenkins UI:

- `Manage Jenkins`
  - `Configure Global Security`
    - `Azure Active Directory` (deprecated plugin, so this might be different in saml plugin now)
      - enter `application client id`, `directory tenant id` and `secret`
      - click `Verify`
  - `Authorization`
    - `Azure Matrix-based security`
      - grant perms to your user/group (should autocomplete if above AAD steps were done right)
        - (not to be confused with the old Matrix-based security bullet point, although both seem to work but only the Azure one gives you autocomplete of groups, while the latter simply needs the group name to match, the azure plugin can differentiate between Outlook365 groups and Security groups)
      - `Save`
- Go back to base Jenkins URL to do AAD login, ignore error pages not from starting point
- If you find yourself locked out, follow [tradition password reset](jenkins.md#reset-the-jenkins-admin-password) or [JCasC password reset](jenkins-on-kubernetes.md#reset-the-jenkins-admin-password-when-using-kubernetes-helm-chart)

## CloudBees

Managed hosted Jenkins control plane - commercial proprietary management layer.

Runs Jenkins controllers and agents on your own Kubernetes.

The real problem this solves is 'Islands of Jenkins' since there is a limit to the vertical scalability of the Jenkins
server leading to provincial team oriented Jenkins installations which is a management and governance hassle for larger
enterprises.

Licensed by number of users, not build minutes since that is run locally.

https://docs.cloudbees.com/docs/cloudbees-ci/latest/feature-definition

### Pricing

Roughly $1k per user + VAT, depending on whether 8x5 or 24x7 support. Prices are always subject to change,
negotiation and scale.

### CloudBees on Kubernetes

See [Jenkins on Kubernetes - CloudBees section](jenkins-on-kubernetes.md#cloudbees-on-kubernetes)

## Jenkins X

See [Jenkins on Kubernetes - Jenkins X section](jenkins-on-kubernetes.md#jenkins-x)

## Tips

1. Use Plugins - they're awesome
   1. uninstall ones you're not using to save RAM
1. Standardize your Jenkins agents via automation
   1. config management for Bare Meta / VMs
   1. preferably [Jenkins on Kubernetes](jenkins-on-kubernetes.md) dynamically spawning agents from pod template
1. Don't run builds on Jenkins server since builds will contend for important server resources needed for job
coordination
   1. Builds on server that's only for trivial small setups, PoCs, local docker testing etc.
   1. Jenkins server is a vertical scaling bottleneck
   1. Can cause inconsistencies between builds on agents vs server
1. Speed up builds via caching
   1. Docker layer caching
   1. Incremental code builds
1. Integrate with other tools (usually via plugins):
   1. Sonar, Jira, Gerrit, Allure
   1. Artifactory / Nexus
   1. Slack for notifications
1. Use Jenkins LTS releases for stability
1. Test your plugin upgrades on a dev/test instance first as they can break anything on Jenkins
1. High number of Pipeline Jobs and frequent build executions will degrade Jenkins server performance
   1. past roughly 150 jobs depending on your execution frequency you'll probably need to split to another Jenkins server
   1. The resulting 'Islands of Jenkins' multiple UI servers is where [CloudBees](#cloudbees) sells to enterprise a
management control plane single pane of glass

## Troubleshooting

### Reset the Jenkins admin password

On a traditional Jenkins install (not using the Kubernetes helm chart, see Kubernetes section for that):

SSH to the jenkins server and run:

```shell
sed -i 's|<useSecurity>true</useSecurity>|<useSecurity>false</useSecurity>|' "$JENKINS_HOME/config.xml"
```

Check it worked:

```shell
grep -i useSecurity "$JENKINS_HOME/config.xml"
```

Then restart Jenkins, access it without auth, update the admin password, undo the config change, and restart again.

### Shell "process apparently never started in"

Execute in Script Console at `$JENKINS_URL/script`:

```groovy
org.jenkinsci.plugins.durabletask.BourneShellScript.LAUNCH_DIAGNOSTICS=true
```

## Other Resources

https://www.slideshare.net/andrewbayer/7-habits-of-highly-effective-jenkins-users


**Ported from private Knowledge Base page 2013+**
