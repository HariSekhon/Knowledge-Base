# Microservices

**TODO finish and refine this page**

Run small services that do one thing well.

It is the services equivalent of the 50 year battle-test unix core utils philosophy.

These services communicate with each other via [APIs](api.md), typically simple
[HTTPS Rest APIs](https://www.redhat.com/en/topics/api/what-is-a-rest-api).

However, while these smaller distributed services reduce monolithic code complexity by decoupling as much as
possible, they introduce infrastructure complexity compared to monoliths.

The code of each service may be much simpler, but they simply shift the complexity to the infrastructure, high
availability and especially monitoring and tracing what happens to requests as they traverse the many components
through the stack.

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Challenges](#challenges)
- [Microservices Stacks](#microservices-stacks)
- [Best Practices](#best-practices)
- [Logging](#logging)
- [Misc Notes](#misc-notes)

<!-- INDEX_END -->

## Key Points

- run smaller services
- smaller footprint per service
- results in more services, more stacks
- easy to create + move independently by relying on standard TCP/IP [networking](networking.md)
- scales more easily as individual components
- lower code complexity by splitting functionality
- higher infrastructure complexity
  - especially monitoring & tracing

## Challenges

- Orchestration
- Configuration Management
- Data Persistence
- Monitoring
  - Logging
  - Tracing

## Microservices Stacks

Commonly used technologies in microservices stacks:

- [Docker](docker.md)
- [Kubernetes](kubernetes.md)
- [Consul](consul.md)
  - Coordination & Discovery system used to find other service dependencies
  - Key-Value store used to store both config and templates, as single source of truth
- [ELK](elasticsearch.md) stack (logging)
- [Cloud](README.md#cloud) services
- [Ansible](ansible.md) (orchestration) - old - usually only used for VMs and not for modern containerized technologies

## Best Practices

- immutable services where possible
- abstract out storage to specialist data services like [RBDMS](README.md#databases--rdbms) or [NoSQL](README.md#NoSQL)
  avoid state maintenance on apps
- even [Kubernetes](kubernetes.md) components and [Mesos](mesos.md) masters run as Docker containers
- service discovery (eg. Consul of Kubernetes internal DNS)
- standardize containers or AWS AMIs for lower maintenance
- [CI/CD](cicd.md) to manage deployments
- logging - all services should log to json

## Logging

- Cloud logging services:
  - AWS [CloudWatch Logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html)
  - GCP [Cloud Logging](https://cloud.google.com/logging)
  - Azure [Monitor Logs](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs)
- ELK stack:
  - LogStash => Elasticsearch => Kibana
  - all services should log to json
  - this avoids other services writing logs locally and allows for read-only filesystem immutable Docker containers

## Misc Notes

- Traffic routing via NginX + PowerDNS, backed by Consul
- Registrator service, hooks in to Dockerdaemon and tells Consul when other services come alive or die
- Docker mounts a directory with the config from Consul
- 11 months from idea to production, bleeding edge but getting better
- Developers can self-provision QA, key part of the process, DevOps only maintain the infrastructure
