# Informatica

Informatica is a data integration UI tool.

Modern Informatica UI is cloud hosted SaaS.

## Organizations

In the Informatica UI at the top right you can see have different organizations.

Underneath the parent organization will be sub-organizations created for each team or department.

You can also verify which environment you are logged in to by going to Organizations section at the top of the
left-panel menu where you can see the Organization Overview details which has a section called `Environment Type`
which will contain a drop down of one of the following: Sandbox, Development, QA, Production.

Notice there is also an option on that page to store credentials on Informatica Cloud or Local Secure Agent.

Other interesting details include timezone, notification emails for success/failure/warnings, local password policies.

### Informatica Login & Environments

The Informatica Cloud URL is here:

[Informatica Cloud login portal](https://dm-us.informaticacloud.com/identity-service/home)

The user account you log in with determines which environment you get into.

You need a different user account name for each environment (you can set this to anything including your email address
or a custom username string).

Informatica supports SAML SSO and local authentication for users.

#### Local Authentication

Using built-in local authentication,
users must be added to the
[Users](https://na2.dm-us.informaticacloud.com/cloudUI/products/administer/main/users) section on the left-panel.

### Billing

Billing info can be found under
[Metering](https://usw3.dm-us.informaticacloud.com/cloudUI/products/administer/main/metering/ipu) in the left panel
of the UI.

Data integration billing is currently 0.025 / Hour(s) while Advanced Data Integration is 0.19 / Hour(s).

### Runtime Environments - Serverless vs Local

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

### Agents

Informatica agents can be installed on Linux eg. using straight EC2 agents running on RHEL 9 using AMIs which include
the RHEL licensing.

Use separate agents for each environment.

You can see agents at
[Runtime Environments](https://na2.dm-us.informaticacloud.com/cloudUI/products/administer/main/runtimeEnvironments)
in the left panel in Informatica Cloud web UI.

The Cloud VMs need to be opened to the Informatica UI source IP address for it to access the agent.

Cloud VM Agents are on open internet protected by security group rules (software firewall).

#### Agent Installation

Informatica Agent software can be downloaded from the Informatica UI and installed by running the Informatica agent
installer binary after the VM is provisioned.

Then just add the agent token from the Informatica UI.

##### Install Documentation:

[Installing the Secure Agent on Linux](https://docs.informatica.com/integration-cloud/cloud-data-integration-for-powercenter/current-version/installation-guide/installing_secure_agents/install_the_secure_agent_on_linux/downloading_and_installing_the_secure_agent_on_linux.html)

[Downloading and installing the Secure Agent](https://docs.informatica.com/cloud-common-services/administrator/h2l/1449-secure-agent-quick-start-for-linux/secure_agent_quick_start_for_linux/downloading-and-installing-the-secure-agent.html)
(includes token creation screenshots)

[VM minimum specs](https://docs.informatica.com/integration-cloud/data-ingestion-and-replication/current-version/database-ingestion-and-replication/database-ingestion-and-replication/database-ingestion-and-replication-system-requirements.html)

[Informatica Pod Availability & Networking](https://docs.informatica.com/cloud-common-services/pod-availability-and-networking/current-version.html) -
click on the heading regions to get the list of IP addresses that need to be allowed for Informatica Cloud to be able to
communicate with the secure agents.

#### Agent Details

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

#### Agent Startup / Shutdown

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

### Kubernetes Informatica Configuration

Informatica configuration for Kubernetes is found under
[Advanced Clusters](https://usw3.dm-us.informaticacloud.com/cloudUI/products/administer/main/advancedCluster)
in the left pane, where the Kubernetes context and kubeconfig is configured (eg. `/home/ec2-user/.kube/config` and
`arn:aws:eks:eu-west-1:123456789012:cluster/my-cluster`), kubernetes version, namespace, node-selector labels, min
and max number of worker nodes etc.

### Connections - Sources and Destinations Integrations

In the left panel under
[Connections](https://na2.dm-us.informaticacloud.com/cloudUI/products/administer/main/ConnectionListWS),
there are a bunch of credentials and URLs to connect to sources like S3, [JDBC](jdbc.md) and destinations like Azure
Synapse.

#### JDBC connector

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

Then proceed to configure the JDBC connection following this doc:

[HOW TO: Create a JDBC connection in Cloud Application Integration](https://knowledge.informatica.com/s/article/589377?language=en_US)

#### JDBC Connectivity Fixes

Use the same [JDBC](jdbc.md) jar version as the database, eg. check the RDS configuration tab `Engine version` field.

Informatica driver class in the doc above may be wrong. Inspect the jar as per the [JDBC](jdbc.md) docs to infer
what the correct class should be, in the case of MySQL 8.0 it was:

```
com.mysql.jdbc.Driver
```

not what the Informatica doc said:

```
jdbc.mysql.MySQLDriver
```
