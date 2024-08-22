# Digital Ocean

<https://www.digitalocean.com/>

Smaller simpler cloud provider used by developers for personal projects.

<!-- INDEX_START -->

- [CLI - `doctl`](#cli---doctl)
  - [Create your API token](#create-your-api-token)
  - [Install](#install)
  - [Usage](#usage)

<!-- INDEX_END -->

## CLI - `doctl`

### Create your API token

You will need this to authenticate the CLI.

Create it here:

[Left panel -> API](https://cloud.digitalocean.com/account/api/tokens)

### Install

[Install doc](https://docs.digitalocean.com/reference/doctl/how-to/install/)

in [HariSekhon/DevOps-Bash-tools](devops-bash-tools.md):

```shell
install_doctl.sh
```

This automates installation and on Mac if `$DIGITAL_OCEAN_TOKEN` is set automates config initialization via Expect if no `config.yml` is found.

### Usage

```shell
doctl account get
```

Install serverless extensions

```shell
doctl serverless install
```

or

```shell
doctl sls install
```

(`sls` is short form for `serverless`)

Connect to development namespace:

```shell
doctl sls connect
```

```shell
doctl sls status
```

```shell
doctl sls deploy .
```

```shell
doctl sls fn get sample/hello --url
```

```shell
doctl sls uninstall
```

**Ported from private Knowledge Base page 2020+**
