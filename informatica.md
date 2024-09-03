# Informatica

Informatica is a data integration UI tool.

Modern Informatica UI is cloud hosted SaaS solution called IICS - Informatica Intelligent Cloud Services.

<!-- INDEX_START -->

- [Organizations](#organizations)
- [Informatica Login & Environments](#informatica-login--environments)
  - [Local Authentication](#local-authentication)
- [Billing](#billing)
- [Runtime Environments - Serverless vs Local](#runtime-environments---serverless-vs-local)
- [Agents](#agents)
  - [Agent Installation](#agent-installation)
  - [Agent Details](#agent-details)
  - [Agent Startup / Shutdown](#agent-startup--shutdown)
  - [Kubernetes - Advanced Jobs](#kubernetes---advanced-jobs)
- [Connections - Sources and Destinations Integrations](#connections---sources-and-destinations-integrations)
  - [JDBC Connector Install](#jdbc-connector-install)
  - [Enable `JDBCV2` Connector on the Secure Agent Group](#enable-jdbcv2-connector-on-the-secure-agent-group)
  - [JDBC Connector Configuration](#jdbc-connector-configuration)
  - [JDBC Configuration Fixes](#jdbc-configuration-fixes)
  - [JDBC Increase Java Heap Size](#jdbc-increase-java-heap-size)
- [Monitoring & Alerting](#monitoring--alerting)
  - [Job Monitoring](#job-monitoring)
- [Support](#support)
- [Troubleshooting](#troubleshooting)
  - [Restarting the Secure Agent](#restarting-the-secure-agent)
  - [VM Restarts require Graceful Restart of the Secure Agent](#vm-restarts-require-graceful-restart-of-the-secure-agent)
  - [Secure agent's OI Data Collector stuck in "Starting Up" phase or Error](#secure-agents-oi-data-collector-stuck-in-starting-up-phase-or-error)
  - [Vertica ODBC Connector Error](#vertica-odbc-connector-error)
  - [Disk Space](#disk-space)
  - [Log Disk Space Cleanup](#log-disk-space-cleanup)
  - [Kubernetes version error `K8s_10152`](#kubernetes-version-error-k8s10152)
  - [Kubernetes - Capture Pod Logs & Stats](#kubernetes---capture-pod-logs--stats)
  - [Kubernetes - Capture Spark Driver JStack Thread Dump](#kubernetes---capture-spark-driver-jstack-thread-dump)
- [Meme](#meme)

<!-- INDEX_END -->

## Organizations

In the Informatica UI at the top right you can see have different organizations.

Underneath the parent organization will be sub-organizations created for each team or department.

You can also verify which environment you are logged in to by going to Organizations section at the top of the
left-panel menu where you can see the Organization Overview details which has a section called `Environment Type`
which will contain a drop down of one of the following: Sandbox, Development, QA, Production.

Notice there is also an option on that page to store credentials on Informatica Cloud or Local Secure Agent.

Other interesting details include timezone, notification emails for success/failure/warnings, local password policies.

## Informatica Login & Environments

The Informatica Cloud URL is here:

[Informatica Cloud login portal](https://dm-us.informaticacloud.com/identity-service/home)

The user account you log in with determines which environment you get into.

You need a different user account name for each environment (you can set this to anything including your email address
or a custom username string).

Informatica supports SAML SSO and local authentication for users.

Landing URLs after login will look something like this depending on which region your IICS is running in:

<https://usw3.dm-us.informaticacloud/cloudshell/showProducts>

<https://na2.dm-us.informaticacloud/cloudshell/showProducts>

More of the administration you will be doing will be under the `Administration` app from the landing
selection of `My Services`.

### Local Authentication

Using built-in local authentication,
users must be added to the
[Users](https://na2.dm-us.informaticacloud.com/cloudUI/products/administer/main/users) section on the left-panel.

## Billing

Billing info can be found under
[Metering](https://usw3.dm-us.informaticacloud.com/cloudUI/products/administer/main/metering/ipu) in the left panel
of the UI.

Data integration billing is currently 0.025 / Hour(s) while Advanced Data Integration is 0.19 / Hour(s).

## Runtime Environments - Serverless vs Local

It's possible to create a serverless environment or your own local runtime environment.

In the left panel menu these are configured in either
[Serverless Environments](https://usw3.dm-us.informaticacloud.com/cloudUI/products/administer/main/environments),
or
[Runtime Environments](https://usw3.dm-us.informaticacloud.com/cloudUI/products/administer/main/runtimeEnvironments)
for local agents or
[Advanced Clusters](https://usw3.dm-us.informaticacloud.com/cloudUI/products/administer/main/advancedCluster)
for kubernetes.

Local Runtime Environment Agents and Kubernetes have the following advantages over serverless environment:

1. It can be cheaper, depending on your usage pattern
1. You retain more control of data not leaving your infrastructure for governance purposes
1. Kubernetes has the additional advantage of being able to burst up and down to avoid incurring constant charges of
   cloud VMs for local runtime environments.

## Agents

Informatica agents can be installed on Linux eg. using straight EC2 agents running on RHEL 9 using AMIs which include
the RHEL licensing.

Use separate agents for each environment.

You can see agents at
[Runtime Environments](https://na2.dm-us.informaticacloud.com/cloudUI/products/administer/main/runtimeEnvironments)
in the left panel in Informatica Cloud web UI.

The Cloud VMs need to be opened to the Informatica UI source IP address for it to access the agent.

Cloud VM Agents are on open internet protected by security group rules (software firewall).

### Agent Installation

Informatica Agent software can be downloaded from the Informatica UI and installed by running the Informatica agent
installer binary after the VM is provisioned.

Then just add the agent token from the Informatica UI.

Docs:

[Installing the Secure Agent on Linux](https://docs.informatica.com/integration-cloud/cloud-data-integration-for-powercenter/current-version/installation-guide/installing_secure_agents/install_the_secure_agent_on_linux/downloading_and_installing_the_secure_agent_on_linux.html)

[Downloading and installing the Secure Agent](https://docs.informatica.com/cloud-common-services/administrator/h2l/1449-secure-agent-quick-start-for-linux/secure_agent_quick_start_for_linux/downloading-and-installing-the-secure-agent.html)
(includes token creation screenshots)

[VM minimum specs](https://docs.informatica.com/integration-cloud/data-ingestion-and-replication/current-version/database-ingestion-and-replication/database-ingestion-and-replication/database-ingestion-and-replication-system-requirements.html)

[Informatica Pod Availability & Networking](https://docs.informatica.com/cloud-common-services/pod-availability-and-networking/current-version.html)

There are a list of IP addresses of Informatica Cloud infrastructure in the heading links for each region in the doc
above, which should only be needed if egress filtering for the secure agent to phone home to the Informatica Cloud
management UI.

### Agent Details

In the Dev account which is shared, our agent is `SMBU_AGENT_GRP (1)`. Do not touch the other agent as it does not
belong to our team.

| Agent Component               | Description                                                                                                                                                                   |
|-------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Elastic Server                 | Runs the CDI elastic jobs that run on the Kubernetes cluster                                                                                                                  |
| Mass Ingestion                 | Ingests data                                                                                                                                                                  |
| OI Data Collector             | Collects agent data to show in the Informatica Cloud UI                                                                                                                      |
| Process Server                 | Sends email notifications. We created SMTP user and configured in Informatica                                                                                                 |
| Data Integration Server      | Manages all the jobs, both local normal and advanced jobs Spark jobs. This converts CDI jobs to Spark and then hands off to Elastic Server to manage the job on on Kubernetes |
| Common Integration Components | Runs the commands specified in a Command Task step of a taskflow.                                                                                                             |

On the EC2 agent, the path for the scripts to start and stop components and logs can be found under:

```none
/home/ec2-user/infaagent/apps/agentcore
```

(`infa` with an r - not `infra` - that is not a typo)

### Agent Startup / Shutdown

```shell
cd /home/ec2-user/infaagent/apps/agentcore
```

```shell
./infaagent startup
```

There is no feedback from this command and it takes several minutes to start up. Be patient.

Some minimal output is here:

```shell
tail -f infaagent.log
```

But you will mainly need to refresh the agent status page in the Informatica UI under Administration left pane section
`Runtime Environments` and then click on the name of the agent to see which components are green.

Shutdown also takes a very long time too in case you need to restart services cleanly:

```shell
./infaagent shutdown
```

The `infaagent` binary is very crude and does not respond to `--help` or `status` args.

See the agent startup/shutdown log here:

```shell
less /home/ec2-user/infaagent/apps/agentcore/infaagent.log
```

### Kubernetes - Advanced Jobs

You can run jobs on Kubernetes - called Advanced Jobs.

Informatica limits the number of jobs based on CPU cores so being able to
scale on demand using Kubernetes balances cost and parallel processing performance eg.
run 30 jobs in parallel or scale down to 0 when jobs are not running.

Informatica has a serverless offering but it is more expensive.

The Agent needs to be set up with the EKS context to reference in Informatica below.

Kubernetes is configured in Informatica UI under the `Administration` portal applet -> `Advanced Clusters` in the
left pane.

In this section, for each configuration created the following key settings are configured:

- EKS context - `arn:aws:eks:eu-west-1:123456789012:cluster/eks-my-cluster`
- kubeconfig - `/home/ec2-user/.kube/config`
- Cluster Version - `1.27`
- Namespace - `prod`
- Number of Worker Nodes - Min: `1`, Max: `5`
- Cluster Idle Timeout - `10` minutes
- Node Selector Labels - eg. key `nodegroup` value `jobs`

Two different Informatica Cloud environments can share the same EKS context but just specify different namespaces
eg. `dev` or `prod`.

**WARNING: Informatica Agent automatically updates in the background and new versions enforce Kubernetes version checks which can break Kubernetes jobs**

This means that your working Kubernetes jobs can suddenly break when the informatica agent decides that it is not a
supported version any more.

For example if you're running 1.24 and then informatica agent enforces 1.27 - 1.29 versions, it will refuse to run
any jobs.

## Connections - Sources and Destinations Integrations

In the left panel under
[Connections](https://na2.dm-us.informaticacloud.com/cloudUI/products/administer/main/ConnectionListWS),
there are a bunch of credentials and URLs to connect to sources like S3, [JDBC](jdbc.md) and destinations like Azure
Synapse.

### JDBC Connector Install

[JDBC connector install doc](https://docs.informatica.com/integration-cloud/data-integration-connectors/current-version/jdbc-v2-connector/connections-for-jdbc-v2/prerequisites/install-the-type-4-jdbc-driver.html)

Download the [JDBC](jdbc.md) jar version matching your DB type and version
(eg. AWS RDS configuration tab `Engine version` field) and then copy it to the following locations:

```none
/home/ec2-user/infaagent/ext/connectors/thirdparty/informatica.jdbc_v2/common/
```

```none
/home/ec2-user/infaagent/ext/connectors/thirdparty/informatica.jdbc_v2/spark/
```

eg.

```shell
JDBC_JAR="mysql-connector-j-*.jar"
```

or

```shell
JDBC_JAR="mssql-jdbc-12.8.1.jre8.jar"
```

(the above jre8 version of the jar works with even Java 17 when testing)

or

```shell
JDBC_JAR="vertica-jdbc-24.2.0-1.jar"
```

Copy the JDBC jar to the locations where Informatica secure agent will detect it:

```shell
for x in common spark; do
  cp -iv "$JDBC_JAR" "/home/ec2-user/infaagent/ext/connectors/thirdparty/informatica.jdbc_v2/$x/"
done
```

Officially you're supposed to restart the agent but in testing the connection succeeded without this:

```shell
cd /home/ec2-user/infaagent/apps/agentcore &&
./infaagent shutdown &&
./infaagent startup
```

### Enable `JDBCV2` Connector on the Secure Agent Group

You will need to enable the connector on the agent group under `Runtime Environments` for the agent to be visible in
the drop-down list when creating the connector configuration below.

- click the three dots to the far right of the agent
- from the drop-down menu click `Enable or Disable Service, Connectors`
- click on `Connectors` at the top
- click the box to the left of the `JDBCV2` connector to enable on the agent

You only need to do this the first time you add any JDBC connector to an agent.

See this
[KB article](https://knowledge.informatica.com/s/article/FAQ-Unable-to-see-all-connectors-and-services-on-agent-installed-after-MAY-21-monthly-release-in-IICS?language=en_US) for screenshots.

### JDBC Connector Configuration

Follow this doc:

[HOW TO: Create a JDBC connection in Cloud Application Integration](https://knowledge.informatica.com/s/article/589377?language=en_US)

### JDBC Configuration Fixes

The connection string will need the following appended to it in most cases where SSL is not used, such as a vanilla
RDS instance:

```none
?useSSL=false
```

eg.

```none
jdbc:mysql://x.x.x.x:3306/my-db?useSSL=false
```

```none
jdbc:sqlserver://x.x.x.x:1433;databaseName=MY-DB;encrypt=false;
```

The `useSSL=false`, `encrypt=false`, or `ssl=false` settings for MySQL, Microsoft SQL Server or Vertica respectively
were needed for the connection to succeed to RDS.

Informatica documentation was missing this.

Use the same [JDBC](jdbc.md) jar version as the database, eg. check the RDS configuration tab `Engine version` field.

MySQL JDBC driver class name:

Informatica documentation was also wrong about the driver class.
Inspecting the `mysql-connector-j-8.0.33.jar` as per the [JDBC](jdbc.md) doc showed the correct class should be:

```none
com.mysql.jdbc.Driver
```

NOT what the Informatica doc said:

```none
jdbc.mysql.MySQLDriver
```

For other JDBC connection details, see the [JDBC](jdbc.md) doc.

### JDBC Increase Java Heap Size

Large data transfers may result in this error:

```none
[ERROR] java.lang.OutOfMemoryError: Java heap space
```

See this [KB article](https://knowledge.informatica.com/s/article/336913?language=en_US)
to increase the Java Heap Size for the Data Integration Server.

Ensure it is restarted from the `Runtime Environment` agent tab which has a per component restart (it should restart
automatically after setting change with no downtime due to starting a new component and then shutting down the old one).

## Monitoring & Alerting

Since running out of disk space breaks the secure agent, it is important to add yourself to the email alerts and
preempt running out of disk space.

Under the global My Services -> `Operational Insights` app -> left-pane  `Alerts` -> top tab `Infrastructure Alerts`

eg.

<https://na2.dm-us.informaticacloud.com/mona/alerts/infrastructure>

<https://usw3.dm-us.informaticacloud.com/mona/alerts/infrastructure>

(the prefix will vary depending on your IICS region)

Go to the agent in the `Secure Agents` left-pane and in the `Email` section add your user account to receive alerts
and check the thresholds (defaults: 90% of Disk Space / CPU / RAM for 30 minutes).

You won't be able to see local users until they have activated their accounts via email invitation.

### Job Monitoring

Go to the UI applet `Monitor`.

It will show you a list of `Running Jobs`.

In the left-pane, you can select `All Jobs` to see past jobs that have failed.

You can type `failed` in the top right search box and re-run failed jobs from the icon to the right
end of the job row.

## Support

Informatica Support URL:

<https://support.informatica.com/s/?language=en_US>

## Troubleshooting

A lot of issues are caused by transient secure agent process issues or running out of disk space.

In a lot of cases restarting the secure agent is enough to solve the problem (after freeing up disk space).

### Restarting the Secure Agent

This takes approximately 15-20 minutes.

```shell
cd /home/ec2-user/infaagent/apps/agentcore &&
./infaagent shutdown &&
./infaagent startup
```

### VM Restarts require Graceful Restart of the Secure Agent

Sometimes the AWS EC2 agent becomes unresponsive and requires a hard restart via AWS.

After the VM comes back up, a simple startup sometimes brings the processes up to green but the jobs do not succeed.

In this case do a full graceful restart as per above to solve it.

### Secure agent's OI Data Collector stuck in "Starting Up" phase or Error

First kill the `OpsInsightsDataCollector` process:

Check you're matching the right thing:

```shell
pgrep -a -f '/OpsInsightsDataCollector/'
```

Kill it (try a normal kill first, not a `-9` hard kill):

```shell
pkill -f '/OpsInsightsDataCollector/'
```

Then in Informative UI under `Runtime Environment`:

- click on the agent, and on the agent page:
  - under `Agent Service Start or Stop` section further down the page:
    1. select `Service:` field drop down `OI Data Collector`
    1. click the `Stop` button next to it if it's present to reset the state
    1. click the `Start` button next to it

This is quicker than restarting the entire secure agent.

### Vertica ODBC Connector Error

```none
The connection test failed because of the following error: Can't find resource for bundle java.util.PropertyResourceBundle, key Error establishing socket to host and port, Reason: Connection refused.; nested exception is:

com.informatica.saas.common.exception.SaasException: Can't find resource for bundle java.util.PropertyResourceBundle, key Error establishing socket to host and port, Reason: Connection refused.
```

You may be forgiven for thinking the `Connection refused` part in the above error is caused by your Vertica DB being
down.

However, another clue is in ` Can't find resource for bundle java.util.PropertyResourceBundle`.

Check the disk space isn't full (see further down).

A simple secure agent restart fixes this issue.

### Disk Space

Check the disk space on partitions:

```shell
df -h
````

Find out where your disk space is going on a full partition such as the `/` root partition:

```shell
du -max / | sort -k1n | tail -n 1000
```

You may find a log such as `/tmp/vertica_odbc_conn_1.log` taking up 25GB of space. You can delete this if you are
not using it for debugging as this is a cumulative log going back months.
You can also add logrotate to automatically rotate and truncate this.

Insert, Upsert, and `InfaS3Staging*/*` temp files are often a problem in `/tmp`.

Find those temp files older than 1 day and consider deleting them:

```shell
find /tmp -type f -name 'insert*' -mtime +1 -o \
          -type f -name 'upsert*' -mtime +1 -o \
          -type f -name '*.tmp'   -mtime +1 -o \
          -type f -name '*.azb'   -mtime +1 -o \
          -type f -path '/tmp/InfaS3Staging*' -mtime +1 2>/dev/null |
xargs --no-run-if-empty du -cam | sort -k1n
```

Verify they are really old by looking at their last timestamps:

```shell
find /tmp -type f -name 'insert*' -mtime +1 -o \
          -type f -name 'upsert*' -mtime +1 -o \
          -type f -name '*.tmp'   -mtime +1 -o \
          -type f -name '*.azb'   -mtime +1 -o \
          -type f -path '/tmp/InfaS3Staging*' -mtime +1 2>/dev/null |
xargs --no-run-if-empty ls -lhtr
```

If you're happy to delete them as old stale files:

```shell
find /tmp -type f -name 'insert*' -mtime +1 -o \
          -type f -name 'upsert*' -mtime +1 -o \
          -type f -name '*.tmp'   -mtime +1 -o \
          -type f -name '*.azb'   -mtime +1 -o \
          -type f -path '/tmp/InfaS3Staging*' -mtime +1 \
          -exec rm -f {} \; 2>/dev/null
```

Then remove any empty directories under `/tmp` such as `/tmp/InfaS3Staging*` to clean up your view:

```shell
rmdir /tmp/* 2>/dev/null
```

Add these two commands above to the user's crontab that is running Informatica agent (eg. `ec2-user`) by running:

```shell
crontab -e
```

and pasting this line in:

```none
0 0 * * * find /tmp -type f -name 'insert*' -mtime +1 -o -type f -name 'upsert*' -mtime +1 -o -type f -name '*.tmp'   -mtime +1 -o -type f -name '*.azb'   -mtime +1 -o -type f -path '/tmp/InfaS3Staging*' -mtime +1 -exec rm -f {} \; 2>/dev/null ; rmdir /tmp/* 2>/dev/null
```

### Log Disk Space Cleanup

On one production agent I found 111GB of logs under this path in over 18500 small files in the last 1 month retention:

```none
/home/ec2-user/infaagent/apps/Data_Integration_Server/logs
```

This cronjob solves this:

```crontab
0 0 * * * find /home/ec2-user/infaagent/apps/Data_Integration_Server/logs -name "*.log" -mtime +3 -exec rm {} \;
```

### Kubernetes version error `K8s_10152`

The Informatica Secure Agent automatically updates itself, and newer versions will enforce Kubernetes cluster
version match.

This error will manifest itself in `Mapping (Advanced Mode)` jobs that use Kubernetes with a job `Error Message` field
like this:

```none
WES_internal_error_Failed to start cluster for [01CLDB25000000000003]. Error reported while starting cluster [500 {"code":"CLUSTER.FAIL_operation_error","message":"Cluster CREATE failed due to the following error: Failed to perform cluster operation [ClusterOpCode.ERROR] due to error : [K8s_10152] The configured Kubernetes cluster version [Kubernet[truncated]. For more information about the failure, check the application log.If the problem persists, contact Informatica Global Customer Support.
```

**Quick workaround**: change the declared Kubernetes version in the `Advanced Clusters` -> `Advanced Configuration` ->
`Cluster Version` field.

This shouldn't really work if Informatica agent actually bothered to do a `kubectl version` check as the both the client
and API server would report the other version, so expect this to break at some random point in the future when
Informatica figures this out and the auto-updated agent gets new logic.

**Solution**: actually upgrade the Kubernetes cluster to be one of the supported versions

### Kubernetes - Capture Pod Logs & Stats

See [Kubernetes - Troubleshooting - Capture Pod Logs & Stats](kubernetes.md#capture-pod-logs--stats).

### Kubernetes - Capture Spark Driver JStack Thread Dump

Make sure your Kubernetes kubectl context is set up and authenticated.

<https://knowledge.informatica.com/s/article/How-to-Capturing-JStack-Thread-Dumps-from-Kubernetes-Pods-or-Containers?language=en_US>

For some reason Informatica created non-copyable screenshots of commands in the above KB article.

<!--

Copy the Informatica agent's JDK to your workstation - but this doesn't always match the pods:

```shell
rsync -av "$SECURE_AGENT":infaagent/jdk/ infaagent-jdk
```

-->

Set your namespace:

```shell
NAMESPACE=informatica
```

First find a Spark driver pod that's in `Running`, not `Error`, state:

```shell
SPARK_DRIVER_POD="$(
  kubectl get pods -n "$NAMESPACE \
  "                -l spark-role="$ROLE" \
                   --field-selector=status.phase=Running \
                   -o json | \
  jq -r '
    .items[] |
    select(.status.containerStatuses[0].state.running != null) |
    select(.spec.containers[].image |
      contains("artifacthub.informaticacloud.com")) |
    .metadata.name
  ' |
  head -n 1 |
  tee /dev/stderr
)"
```

First get the Java version:

```shell
kubectl exec -ti -n "$NAMESPACE" "$SPARK_POD" -- java -version
```

Find the JDK matching that Java version on the Secure Agent's `infaagent/apps/jdk/` directory.

On your local workstation set the JDK:

```shell
JDK="zulu8.70.0.52-sa-fx-jdk8.0.372"
```

Then retrieve the corresponding JDK from the Secure Agent:

```shell
rsync -av "$SECURE_AGENT":"infaagent/apps/jdk/$JDK" .
```

Collecting the JStack traces is then mostly automated using this script from [DevOps-Bash-tools](devops-bash-tools.md)
repo:

```shell
kubectl_pods_dump_jstacks.sh "$JDK" "$NAMESPACE" spark
```

#### Manually

```shell
ROLE=driver
```

or

```shell
ROLE=executor
```

```shell
SPARK_DRIVER_POD="$(
  kubectl get pods -n "$NAMESPACE \
  "                -l spark-role="$ROLE" \
                   --field-selector=status.phase=Running \
                   -o json | \
  jq -r '
    .items[] |
    select(.status.containerStatuses[0].state.running != null) |
    select(.spec.containers[].image |
      contains("artifacthub.informaticacloud.com")) |
    .metadata.name
  ' |
  head -n 1 |
  tee /dev/stderr
)"
```

The above command should print the pod name. If it doesn't, debug it before continuing.

Copy the JDK to the spark pod:

```shell
kubectl cp -n "$NAMESPACE" "$JDK/" "$SPARK_POD":/tmp/jdk
```

Exec into the pod:

```shell
kubectl exec -ti -n "$NAMESPACE" "$SPARK_POD" -- bash
```

Inside the pod:

```shell
PID="$(pgrep java | tee /dev/stderr | head -n 1)"
```

The above command should print ONE process ID of the java process. If it prints more than one, debug before continuing.

```shell
/tmp/jdk/bin/jstack "$PID" > /tmp/jstack-output.txt
```

Exit the pod.

```shell
exit
```

Back on your workstation copy the `jstack-output.txt` out:

```shell
kubectl cp "$SPARK_POD":/tmp/jstack-output.txt "jstack-output.$ROLE.$(date +%F_%H%M).txt"
```

If you get this error:

```none
root@spark-0c53569173cdfbf4-exec-7:/opt/spark/work-dir# /tmp/jdk/bin/jstack "$PID" > /tmp/jstack-output.txt
57: Unable to open socket file /proc/57/cwd/.attach_pid57: target process 57 doesn't respond within 10500ms or HotSpot VM not loaded
The -F option can be used when the target process is not responding

root@spark-0c53569173cdfbf4-exec-7:/opt/spark/work-dir# /tmp/jdk/bin/jstack -F "$PID" > /tmp/jstack-output.txt
Error attaching to process: sun.jvm.hotspot.runtime.VMVersionMismatchException: Supported versions are 25.362-b08. Target VM is 25.372-b07
sun.jvm.hotspot.debugger.DebuggerException: sun.jvm.hotspot.runtime.VMVersionMismatchException: Supported versions are 25.362-b08. Target VM is 25.372-b07
        at sun.jvm.hotspot.HotSpotAgent.setupVM(HotSpotAgent.java:435)
        at sun.jvm.hotspot.HotSpotAgent.go(HotSpotAgent.java:305)
        at sun.jvm.hotspot.HotSpotAgent.attach(HotSpotAgent.java:140)
        at sun.jvm.hotspot.tools.Tool.start(Tool.java:185)
        at sun.jvm.hotspot.tools.Tool.execute(Tool.java:118)
        at sun.jvm.hotspot.tools.JStack.main(JStack.java:92)
        at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
        at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.lang.reflect.Method.invoke(Method.java:498)
        at sun.tools.jstack.JStack.runJStackTool(JStack.java:140)
        at sun.tools.jstack.JStack.main(JStack.java:106)
Caused by: sun.jvm.hotspot.runtime.VMVersionMismatchException: Supported versions are 25.362-b08. Target VM is 25.372-b07
        at sun.jvm.hotspot.runtime.VM.checkVMVersion(VM.java:227)
        at sun.jvm.hotspot.runtime.VM.<init>(VM.java:294)
        at sun.jvm.hotspot.runtime.VM.initialize(VM.java:370)
        at sun.jvm.hotspot.HotSpotAgent.setupVM(HotSpotAgent.java:431)
```

then find that same java version to copy to the same:

```shell
kubectl exec -ti -n "$NAMESPACE" "$SPARK_POD" -- java -version
```

This may be necessary because the Spark driver and executor java versions appear to be different in the containers.

Download the matching Java version, in Informatica's case that's Azul OpenJDK from this URL:

<https://cdn.azul.com/zulu/bin/>

untar the download and then copy it to the pod's `/tmp`:

```shell
kubectl cp -n "$NAMESPACE" ./zulu*-jdk*-linux_x64/ "$SPARK_POD":/tmp/jdk
```

```shell
kubectl exec -ti -n "$NAMESPACE" "$SPARK_POD" -- \
        bash -c '/tmp/jdk/bin/jstack -F "$(pgrep java | tee /dev/stderr | head -n 1)" > /tmp/jstack-output.txt'
```

```shell
kubectl cp "$SPARK_POD":/tmp/jstack-output.txt "jstack-output.$ROLE.$(date +%F_%H%M).txt"
```

If the copied JDK version still doesn't work you can workaround it using the Spark master drive UI instead to get the
thread dumps from there by tunnelling through the bastion host and port-forwarding the pod's UI:

```shell
ssh bastion -L 4040:localhost:4040
```

On the bastion run this script from [DevOps-Bash-tools](devops-bash-tools.md) repo:

```shell
kubectl_port_forward_spark.sh
```

which will prompt you with an interactive menu to select the Spark driver pod from a list.

Alternatively, you can adjust this command manually:

```shell
kubectl port-forward --address 127.0.0.1 "$(kubectl get pods -l spark-role=driver -o name | head -n1)" 4040
```

Then browse to:

<http://localhost:4040/executors/>

and click on the Thread Dump links to the far right of each executor line.

Informatica Secure Agent documentation needs updating,
you can get the correct version of JDK from the secure agent at this location:

```none
infaagent/apps/jdk/
```

eg.

```shell
JDK="zulu8.70.0.52-sa-fx-jdk8.0.372"
```

```shell
rsync -av "$SECURE_AGENT":"infaagent/apps/jdk/$JDK" .
```

```shell
kubectl cp -n "$NAMESPACE" "./$JDK/" "$SPARK_POD":/tmp/jdk
```

Then repeat the JStack collection commands above.

## Meme

From my [LinkedIn](http://linkedin.com/in/HariSekhon):

![3 Rules - Informatica - 4 Rules](images/3_rules_informatica_4_rules.jpg)
