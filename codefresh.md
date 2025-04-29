# Codefresh

<!-- INDEX_START -->

- [CLI](#cli)
  - [Install](#install)
  - [Usage](#usage)
  - [Validate Config](#validate-config)
  - [Kubernetes](#kubernetes)

<!-- INDEX_END -->

## CLI

### Install

Installs via HomeBrew or NPM + configures using `$CODEFRESH_KEY` from environment:

From [DevOps-Bash-tools](devops-bash-tools.md):

```shell
setup/setup_codefresh.sh
```

### Usage

```shell
codefresh get projects
```

```shell
codefresh get pipelines
```

```shell
codefresh get builds
```

```shell
codefresh get builds -s delayed -w --watch-interval 3
```

### Validate Config

```shell
codefresh validate codefresh.yml
```

### Kubernetes

Install agent in kubernetes - must specify namespace:

```shell
codefresh install agent --kube-namespace default
```

**Ported from private Knowledge Base page 2020+**
