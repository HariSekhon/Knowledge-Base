# Concourse

https://concourse-ci.org/

Nice simple lean open source CI/CD tool.

<!-- INDEX_START -->
- [QuickStart in Docker in one command](#quickstart-in-docker-in-one-command)
- [CLI](#cli)
  - [Install](#install)
  - [fly.sh](#flysh)
  - [fly](#fly)
  - [Fly shell auto-completion](#fly-shell-auto-completion)
- [Concourse YAML](#concourse-yaml)
<!-- INDEX_END -->

## QuickStart in Docker in one command

In [HariSekhon/DevOps-Bash-tools](devops-bash-tools.md):

```shell
cicd/concourse.sh
```

uses adjacent config [cicd/.concourse.yml](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/cicd/.concourse.yml)

Boots Concourse CI in Docker, and builds the current repo

- boots Concourse container in Docker
- creates job pipeline from `$PWD/.concourse.yml`
- unpauses pipeline and job
- triggers pipeline job
- follows job build log in CLI
- prints recent build statuses

## CLI

### Install

In [HariSekhon/DevOps-Bash-tools](devops-bash-tools.md)

Downloads latest release from GitHub:

```shell
install/install_fly.sh
```

Unfortunately no binaries available for new Apple Silicon `arm64` Macs yet, see
[this issue](https://github.com/concourse/concourse/issues/1379) which has been open for years.

### fly.sh

Wraps `fly` command to:

- auto-download the CLI from the Concourse server if not present
- uses `$FLY_TARGET` environment if present to inject `-t "$target"` to save repetition of switches

```shell
cicd/fly.sh
```

### fly

#### Auth

Generates Authorization bearer token in `~/.flyrc` - curl needs to use this, cannot curl basic auth directly

```shell
fly login ...
```

To get whole curl command printed out including token header:

```shell
fly -t ci curl /api/v1/teams/main/cc.xml --print-and-exit
```

#### Usage

```shell
fly format-pipeline --config .concourse.yml --write
```

```shell
fly -t example get-pipeline --pipeline my-pipeline
```


List targets, URLs + auth status

```shell
fly targets
```

Show auth status to target

```shell
fly -t "$target" status
```

Who you are logged in as

```shell
fly -t "$target" userinfo
```

Replaces your fly CLI with the latest version from server:

```shell
fly -t "$target" sync
```

### Fly shell auto-completion

```shell
source <(fly completion --shell bash)
```

or

```shell
fly completion --shell bash > /etc/bash_completion.d/fly
```

## Concourse YAML

Environment variable:

```
((my_env_var))
```

###### Ported from private Knowledge Base page 2020+
