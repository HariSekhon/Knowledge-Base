# Informatica

Informatica is a data integration UI tool.

Modern Informatica UI is cloud hosted SaaS solution called IICS - Informatica Intelligent Cloud Services.

- [Organizations](#organizations)
- [Informatica Login & Environments](#informatica-login--environments)
  - [Local Authentication](#local-authentication)
- [Billing](#billing)
- [Runtime Environments - Serverless vs Local](#runtime-environments---serverless-vs-local)
- [Agents](#agents)
  - [Agent Installation](#agent-installation)
  - [Agent Details](#agent-details)
  - [Agent Startup / Shutdown](#agent-startup--shutdown)
- [Kubernetes Informatica Configuration](#kubernetes-informatica-configuration)
- [Connections - Sources and Destinations Integrations](#connections---sources-and-destinations-integrations)
  - [JDBC Connector Install](#jdbc-connector-install)
  - [Enable the JDBC Connector on the Secure Agent Group](#enable-the-jdbc-connector-on-the-secure-agent-group)
  - [JDBC Connector Configuration](#jdbc-connector-configuration)
  - [JDBC Configuration Fixes](#jdbc-configuration-fixes)
  - [JDBC Increase Java Heap Size](#jdbc-increase-java-heap-size)
- [Troubleshooting](#troubleshooting)
  - [Restarting the Secure Agent](#restarting-the-secure-agent)
  - [VM Restarts require Graceful Restart of the Secure Agent](#vm-restarts-require-graceful-restart-of-the-secure-agent)
  - [Vertica ODBC Connector Error](#vertica-odbc-connector-error)
  - [Disk Space](#disk-space)

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
2. You retain more control of data not leaving your infrastructure for governance purposes
3. Kubernetes has the additional advantage of being able to burst up and down to avoid incurring constant charges of
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

#### Install Documentation:

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

```
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

## Kubernetes Informatica Configuration

Informatica configuration for Kubernetes is found under
[Advanced Clusters](https://usw3.dm-us.informaticacloud.com/cloudUI/products/administer/main/advancedCluster)
in the left pane, where the Kubernetes context and kubeconfig is configured (eg. `/home/ec2-user/.kube/config` and
`arn:aws:eks:eu-west-1:123456789012:cluster/my-cluster`), kubernetes version, namespace, node-selector labels, min
and max number of worker nodes etc.

## Connections - Sources and Destinations Integrations

In the left panel under
[Connections](https://na2.dm-us.informaticacloud.com/cloudUI/products/administer/main/ConnectionListWS),
there are a bunch of credentials and URLs to connect to sources like S3, [JDBC](jdbc.md) and destinations like Azure
Synapse.

### JDBC Connector Install

[JDBC connector install doc](https://docs.informatica.com/integration-cloud/data-integration-connectors/current-version/jdbc-v2-connector/connections-for-jdbc-v2/prerequisites/install-the-type-4-jdbc-driver.html)

Download the MySQL or PostgreSQL jdbc jar version matching your DB (eg. AWS RDS configuration tab `Engine version`
field) and then copy it to the following locations:

```
/home/ec2-user/infaagent/ext/connectors/thirdparty/informatica.jdbc_v2/common/
```

```
/home/ec2-user/infaagent/ext/connectors/thirdparty/informatica.jdbc_v2/spark/
```

eg.

```shell
for x in common spark; do
  cp -iv "$(ls mysql-connector-j-*.jar | tail -n 1)" \
         "/home/ec2-user/infaagent/ext/connectors/thirdparty/informatica.jdbc_v2/$x/"
done
```

and restart the agent:

```shell
cd /home/ec2-user/infaagent/apps/agentcore &&
./infaagent shutdown &&
./infaagent startup
```

### Enable the JDBC Connector on the Secure Agent Group

You will need to enable the connector on the agent group under `Runtime Environments` for the agent to be visible in
the drop-down list when creating the connector configuration below.

See this
[KB article](https://knowledge.informatica.com/s/article/FAQ-Unable-to-see-all-connectors-and-services-on-agent-installed-after-MAY-21-monthly-release-in-IICS?language=en_US).

### JDBC Connector Configuration

Follow this doc:

[HOW TO: Create a JDBC connection in Cloud Application Integration](https://knowledge.informatica.com/s/article/589377?language=en_US)

### JDBC Configuration Fixes

The connection string will need the following appended to it in most cases where SSL is not used, such as a vanilla
RDS instance:

```
?useSSL=false
```

eg.

```
jdbc:mysql://x.x.x.x:3306/my-db?useSSL=false
```

The `useSSL=false` setting is often needed for the connection to succeed as most databases don't have SSL
configured on their ports. Informatica documentation was missing this.

Use the same [JDBC](jdbc.md) jar version as the database, eg. check the RDS configuration tab `Engine version` field.

Informatica documentation was also wrong about the driver class.
Inspecting the `mysql-connector-j-8.0.33.jar` as per the [JDBC](jdbc.md) doc showed the correct class should be:

```
com.mysql.jdbc.Driver
```

NOT what the Informatica doc said:

```
jdbc.mysql.MySQLDriver
```

### JDBC Increase Java Heap Size

Large data transfers may result in this error:

```
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

## Support

Informatica Support URL:

<https://support.informatica.com/s/?language=en_US>

## Troubleshooting

A lot of issues are caused by transient secure agent process issues or running out of disk space.

In a lot of cases restarting the secure agent is enough to solve the problem (after freeing up disk space).

### Restarting the Secure Agent

```shell
cd /home/ec2-user/infaagent/apps/agentcore &&
./infaagent shutdown &&
./infaagent startup
```

### VM Restarts require Graceful Restart of the Secure Agent

Sometimes the AWS EC2 agent becomes unresponsive and requires a hard restart via AWS.

After the VM comes back up, a simple startup sometimes brings the processes up to green but the jobs do not succeed.

In this case do a full graceful restart as per above to solve it.

### Vertica ODBC Connector Error

You may be forgiven for thinking the `Connection refused` part of the below error is caused by your Vertica DB being
down.

However, another clue is in ` Can't find resource for bundle java.util.PropertyResourceBundle`.

Check the disk space isn't full (see further down).

A simple secure agent restart fixes this issue.

```
The connection test failed because of the following error: Can't find resource for bundle java.util.PropertyResourceBundle, key Error establishing socket to host and port, Reason: Connection refused.; nested exception is:

com.informatica.saas.common.exception.SaasException: Can't find resource for bundle java.util.PropertyResourceBundle, key Error establishing socket to host and port, Reason: Connection refused.
```

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
find /tmp -type f -name 'insert*' -ctime +1 -o \
          -type f -name 'upsert*' -ctime +1 -o \
          -type f -path '/tmp/InfaS3Staging*' -ctime +1 2>/dev/null |
xargs --no-run-if-empty du -cam | sort -k1n
```

Verify they are really old by looking at their last timestamps:

```shell
find /tmp -type f -name 'insert*' -ctime +1 -o \
          -type f -name 'upsert*' -ctime +1 -o \
          -type f -path '/tmp/InfaS3Staging*' -ctime +1 2>/dev/null |
xargs --no-run-if-empty ls -lhtr
```

If you're happy to delete them as old stale files:

```shell
find /tmp -type f -name 'insert*' -ctime +1 -o \
          -type f -name 'upsert*' -ctime +1 -o \
          -type f -path '/tmp/InfaS3Staging*' -ctime +1 2>/dev/null |
xargs --no-run-if-empty rm -fv
```

Then remove any empty directories under `/tmp` such as `/tmp/InfaS3Staging*` to clean up your view:

```shell
rmdir /tmp/* 2>/dev/null
```

(add these two commands above to crontab without the `-v` switch to `rm` to avoid local mailbox notifications):

```
0 * * * * bash -c "find /tmp -type f -name 'insert*' -ctime +1 -o -type f -name 'upsert*' -ctime +1 -o -type f -path '/tmp/InfaS3Staging*' -ctime +1 2>/dev/null | xargs --no-run-if-empty rm -f; rmdir /tmp/* 2>/dev/null"
```
