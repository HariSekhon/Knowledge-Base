# Trivy

<https://github.com/aquasecurity/trivy>

<!-- INDEX_START -->

- [Install](#install)
- [Run](#run)
  - [Filesystem Scan](#filesystem-scan)
  - [Image Scan](#image-scan)
- [Ignoring False Positives](#ignoring-false-positives)

<!-- INDEX_END -->

## Install

From [DevOps-Bash-tools](devops-bash-tools.md):

```shell
install_trivy.sh
```

Installs to `/usr/local/bin/trivy`.

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
