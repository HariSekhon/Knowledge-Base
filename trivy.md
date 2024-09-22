# Trivy

<https://github.com/aquasecurity/trivy>

## Install

From [DevOps-Bash-tools](devops-bash-tools.md):

```shell
install_trivy.sh
```

Installs to `/usr/local/bin/trivy`.

## Run

Filesystem scan and exit with code 1 for any `HIGH` OR `CRITICAL` level issues:

```shell
trivy fs . --exit-code 1 --severity HIGH,CRITICAL
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
