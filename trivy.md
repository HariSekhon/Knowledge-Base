# Trivy

<https://github.com/aquasecurity/trivy>

Security scanning tool for both filesystem code and secrets as well as docker container images.

<!-- INDEX_START -->

- [Install](#install)
- [Run](#run)
  - [Filesystem Scan](#filesystem-scan)
  - [Image Scan](#image-scan)
- [Ignoring False Positives](#ignoring-false-positives)

<!-- INDEX_END -->

## Install

On Mac, using [Homebrew](brew.md):

```shell
brew install trivy
```

On Debian / Ubuntu:

```shell
apt install trivy
```

Or download the latest binary from GitHub or any specific version using [DevOps-Bash-tools](devops-bash-tools.md) script:

```shell
install_trivy.sh  # "$version"
```

which installs to `/usr/local/bin/trivy`, or `$HOME/bin/trivy` if you don't have write permission to `/usr/local/bin`.

## Run

Add the `--no-progress` switch in CI/CD to minimize noise in the CI/CD logs.

### Filesystem Scan

Filesystem scan and exit with code 1 for any `HIGH` OR `CRITICAL` level issues:

```shell
trivy fs "$dir" --exit-code 1 --severity HIGH,CRITICAL
```

### Image Scan

Scan container images:

```shell
trivy image "$docker_image"
```

## Ignoring False Positives

Can only put the id in `.trivyignore` but this ignores all instances:

`.trivyignore`:

```shell
gcp-service-account
```

Inline ignores in source files don't work:

```shell
# false positive - trivy:ignore:gcp-service-account doesn't work
# trivy:ignore:gcp-service-account
```
