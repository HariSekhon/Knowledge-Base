# Clair

<https://github.com/coreos/clair>

<https://quay.github.io/clair/whatis.html>

Clair Security Scanner by Quay.io / Redhat

Open source static analysis image vulnerability scanner by CoreOS

Not as good quality, easy to use or reliable as Trivy / Grype in my experience,
see [this issue](https://github.com/quay/clair/issues/1756).

<!-- INDEX_START -->

- [Components](#components)
- [Container Image](#container-image)
- [Config](#config)
- [CLI - ClairCtl](#cli---clairctl)
  - [Install CLI](#install-cli)

<!-- INDEX_END -->

## Components

- Indexer service
  - records layers of container images
- Matcher service
  - matches IndexReports from Indexer service against vulnerabilities
  - runs Updaters in the background to periodically download vulnerabilities info into DB

## Container Image

https://quay.io/repository/projectquay/clair

## Config

See [HariSekhon/Templates clair.yaml](https://github.com/HariSekhon/Templates/blob/master/clair.yaml) for config

```
CLAIR_MODE=combo
CLAIR_CONF=/path/to/mounted/config.yaml
```

or CLI:

```shell
clair -conf "path/to/config.yaml" -mode "combo"  # indexer / matcher / notifier
```


## CLI - ClairCtl

https://quay.github.io/clair/reference/clairctl.html

Submit manifest to clair using `clairctl`

#### HomeBrew

Installs the clair daemon not `clairctl` - there is no brew package for `clairctl`:

```shell
brew install clair
```

### Install CLI

Make sure to run this outside any Go directory with a `go.mod` file:

```shell
GO111MODULE=on go install github.com/quay/clair/v4/cmd/clairctl@latest
```

Prints a manifest for a given docker image

```shell
clairctl manifest "$DOCKER_IMAGE:$DOCKER_TAG"
```

`--host` defaults to `localhost:6060`:

```shell
clairctl --host "$CLAIR_HOST" report "$DOCKER_IMAGE:$DOCKER_TAG"
```


###### Ported from private Knowledge Base page 2023+
