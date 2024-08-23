# Drone.io

<https://www.drone.io/>

<!-- INDEX_START -->

- [PAT](#pat)
- [CLI](#cli)
- [API](#api)

<!-- INDEX_END -->

## PAT

Get personal access token:

<https://cloud.drone.io/account>

## CLI

[CLI Quickstart](https://docs.drone.io/quickstart/cli/)

[CLI Install](https://docs.drone.io/cli/install/)

Mac:

```shell
brew install drone-cli
```

Enter repo directory where `.drone.yml` is and build locally:

```shell
cd ~/github/bash-tools
```

```shell
drone exec # [--pipeline default] [--include=thisstep] [--exclude=thatstep]
```

<https://docs.drone.io/cli/repo/drone-repo-ls/>

```shell
export DRONE_SERVER=https://cloud.drone.io
export DRONE_TOKEN=... # get from https://cloud.drone.io/account
```

User and email:

```shell
drone info
```

```shell
drone repo ls
```

Last build status for given repo:

```shell
drone build last HariSekhon/DevOps-Bash-tools
```

## API

```shell
curl -i -H "Authorization: Bearer $DRONE_TOKEN" https://cloud.drone.io/api/user
```

For easier shorter CLI use see [drone_api.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/drone/drone_api.sh) in [DevOps-Bash-tools](devops-bash-tools.md) repo:

```shell
drone_api.sh --help
```
