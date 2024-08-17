# Microservices

Run small services that do one thing well.

It is the services equivalent of the 50 year battle-test unix core utils philosophy.

These services communicate with each other via APIs, typically simple [HTTPS Rest APIs](https://www.redhat.com/en/topics/api/what-is-a-rest-api).

However, these distributed services introduce complexity over monoliths. The code of each service may be much
simpler, but they simply shift the complexity to the infrastructure and monitoring.

- run small services that do more services, more stacks, need to scale easier + faster, maintenance overhead
- answer: Docker containers
- small footprint
- easy to create + move around
- limitation - only simplifies running services, misses:
  - no conf mgmt
  - no persistent data
  - no traditional logging
  - no orchestration

## Microservices Stacks

- [Docker](docker.md)
- [Kubernetes](kubernetes.md)
- [Consul](consul.md) - Coordination & Discovery system and Key-Value store
- [ELK](elasticsearch.md) stack (logging)
- [AWS](aws.md)
- [Ansible](ansible.md) (orchestration)


- use immutable services where possible and abstract out storage to avoid state maintenance on some apps
- even [Kubernetes](kubernetes.md) components and Mesos masters run as Docker containers
- [Mesos](mesos.md) knows how to speak docker, using Marathon


- [Consul](consul.md) - secure key-value store
  - used to store both config and templates, single source of truth
  - Consul Template watches it and creates configuration files, used by containers

- AWS - single AMI since all services run in containers, low maintenance
- Ansible - integrates with AWS natively
- more of an orchestration tool that also does config mgmt
- pushes configuration of services to Consul
- jobs triggered via Jenkins

### Logging

- Cloud logging services:
  - AWS [CloudWatch Logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html)
  - GCP [Cloud Logging](https://cloud.google.com/logging)
  - Azure [Monitor Logs](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs)
- ELK stack:
  - LogStash => Elasticsearch => Kibana
  - all services should log to json
  - this avoids other services writing logs locally and allows for read-only filesystem immutable Docker containers



- Traffic routing via NginX + PowerDNS, backed by Consul


- Registrator service, hooks in to Dockerdaemon and tells Consul when other services come alive or die


- Docker mounts a directory with the config from Consul


- 11 months from idea to production, bleeding edge but getting better
- Developers can self-provision QA, key part of the process, DevOps only maintain the infrastructure
