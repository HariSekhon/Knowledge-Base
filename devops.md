# DevOps Misc

- LiquiBase
- Bamboo
- Chaos Monkey
- CloudTest
- LoadStorm
- KeyNote
- [Hygieia](https://github.com/hygieia/hygieia)
  - DevOps dashboard showing entire pipeline of Git/Svn, CI (Jenkins), Build Quality (SonarQube), Deploy etc
  - built on MongoDB
  - collectors from various tools

- [JFrog Artifactory](artifactory.md) - repository mirror -  Maven, PyPI, NPM, Docker etc...

- Jira
- Confluence
- Rundeck - open core scheduler

## Microservices

- more services, more stacks, need to scale easier + faster, maintenance overhead
- answer: Docker containers
- small footprint
- easy to create + move around
- limitation - only simplifies running services, misses:
  - no conf mgmt
  - no persistent data
  - no traditional logging
  - no orchestration

### Microservices stacks

- [Docker](docker.md)
- [Kubernetes](kubernetes.md)
- Consul (Key-Value store)
- [ELK](elasticsearch.md) stack (logging)
- [AWS](aws.md)
- [Ansible](ansible.md) (orchestration)

- immutable so no maintenance
- even Mesos masters running as Docker containers
- Mesos knows how to speak docker, using Marathon

- Consul - secure key-value store
- used to store both config and templates, single source of truth
- Consul Template watches it and creates configuration files, used by containers

- ELK stack for logging - all services should log to json => LogStash => Elasticsearch => Kibana, this solves immutable Docker containers

- AWS - single AMI since all services run in containers, low maintenance

- Ansible - integrates with AWS natively
- more of an orchestration tool that also does config mgmt
- pushes configuration of services to Consul
- jobs triggered via Jenkins

- Traffic routing via NginX + PowerDNS, backed by Consul

- Registrator service, hooks in to Dockerdaemon and tells Consul when other services come alive or die

- Docker mounts a directory with the config from Consul

- 11 months from idea to production, bleeding edge but getting better
- Developers can self-provision QA, key part of the process, DevOps only maintain the infrastructure

###### Ported from private Knowledge Base pages 2015+
