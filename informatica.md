# Informatica

Informatica is a data integration UI tool.

Modern Informatica UI is cloud hosted SaaS.

## Organizations

In the Informatica UI at the top right you can see have different organizations.

Underneath the parent organization will be sub-organizations created for each team or department.

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

[Informatica Pod Availability & Networking](https://docs.informatica.com/cloud-common-services/pod-availability-and-networking/current-version.html)

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

### Connections - Sources and Destinations Integrations

In the left panel under
[Connections](https://na2.dm-us.informaticacloud.com/cloudUI/products/administer/main/ConnectionListWS),
there are a bunch of credentials and URLs to connect to sources like S3, [JDBC](jdbc.md) and destinations like Azure
Synapse.
