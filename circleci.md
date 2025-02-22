# CircleCI

<https://circleci.com/>

One of the original hosted CI/CD systems.

<!-- INDEX_START -->

- [Key Points](#key-points)
- [UI App](#ui-app)
- [CircleCI CLI](#circleci-cli)
- [Master Config Template](#master-config-template)
- [Validate Config](#validate-config)
- [Configs in Public Repos](#configs-in-public-repos)
- [Self-Hosted Runner on Kubernetes](#self-hosted-runner-on-kubernetes)
- [CLI Usage](#cli-usage)
  - [Create Namespace for use by Orbs or Executor Runners](#create-namespace-for-use-by-orbs-or-executor-runners)
- [SSH Debugging](#ssh-debugging)
- [Advanced gotchas](#advanced-gotchas)

<!-- INDEX_END -->

## Key Points

Good UI but expensive, and undercut by GitHub Actions.

Not good for multi-jobs per repo compared to [GitHub Actions](github-actions.md) which has overtaken it.

Docker Layer Caching costs 200 credits per job - 20 minutes of build time charges to save 3-5 minutes of actual
Docker building in-job. WTF.

Charged via legacy up-front purchase order capacity, not PAYG like more modern cloud-hosted tech like AWS, GitHub etc.

## UI App

<https://app.circleci.com/pipelines>

## CircleCI CLI

Follow the [installation doc](https://circleci.com/docs/local-cli/) or paste this to run an automated installation script
which auto-detects and handles Mac or Linux:

```shell
git clone https://github.com/HariSekhon/DevOps-Bash-tools
```

```shell
bash-tools/install/install_circleci.sh
```

Then configure it:

```shell
circleci setup
```

## Master Config Template

Copy to `.circleci/config.yml` in the root of a Git repo and edit:

[HariSekhon/Templates - circleci-config.yml](https://github.com/HariSekhon/Templates/blob/master/circleci-config.yml)

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Templates&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Templates)

## Validate Config

```shell
circleci config validate ./.circleci/config.yml
```

This script from [DevOps-Bash-tools](devops-bash-tools.md) validates all `.circleci/config.yml` files it finds in the tree:

```shell
check_circleci_config.sh
```

## Configs in Public Repos

Most of my public GitHub repos have a `.circleci/config.yml` file, eg:

[HariSekhon/DevOps-Bash-tools - .circleci/config.yml](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/.circleci/config.yml)

## Self-Hosted Runner on Kubernetes

<https://circleci.com/docs/runner-overview/>

[HariSekhon/Kubernetes-configs - circleci](https://github.com/HariSekhon/Kubernetes-configs/tree/master/circleci)

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Kubernetes-configs&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Kubernetes-configs)

## CLI Usage

### Create Namespace for use by Orbs or Executor Runners

Must be VCS org admin to create a namespace and each org can only have a single namespace (contact support to change it)

```shell
circleci namespace create <namespace> <vcs> <org>
```

eg.

```shell
circleci namespace create harisekhon github HariSekhon
```

Create runner token and save, it is only displayed once:

- Note: command doesn't work without description argument

```shell
circleci runner resource-class create harisekhon/docker-runner "Docker Runner" --generate-token
```

```shell
circleci runner resource-class create harisekhon/k8s-runner "Kubernetes Runner" --generate-token
```

See the runner (can't see in UI)

```shell
circleci runner instance list harisekhon
```

Delete a resource class

```shell
circleci runner resource-class delete harisekhon/docker
```

if you output like this:

```shell
Error: resource class harisekhon/docker still has tokens in use
```

then:

```shell
circleci runner token list harisekhon
```

output:

```shell
+--------------------------------------+----------+----------------------+
|                  ID                  | NICKNAME |      CREATED AT      |
+--------------------------------------+----------+----------------------+
| f3970f18-cdbb-4acf-ab11-6988e7d556e7 | default  | 2021-12-13T19:02:48Z |
+--------------------------------------+----------+----------------------+
```

```shell
circleci runner token delete f3970f18-cdbb-4acf-ab11-6988e7d556e7
```

```shell
circleci runner resource-class delete harisekhon/docker
```

Silently succeeds

## SSH Debugging

Can debug failing jobs with SSH, see [this doc](https://circleci.com/docs/ssh-access-jobs/).

## Advanced gotchas

- No way to list runners and namespaces in the CircleCI UI
- No way to list namespaces in the CLI
- Conditionals - looks like it's all or nothing for a workflow or a step, whereas I want a job to be conditional - I could wrap all job's steps in a when step, but can't exclude all steps otherwise get this validation error

```text
      [#/jobs/docker_build/steps] expected minimum item count: 1, found: 0
      |   |   SCHEMA:
      |   |     minItems: 1
      |   |   INPUT:
      |   |     null#
```

**Ported from private Knowledge Base page 2019+**
