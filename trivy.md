# Trivy

<https://github.com/aquasecurity/trivy>

Security scanning CLI tool for vulnerabilities, leaked secrets and misconfigurations.

Scans:

- Files for secrets and configuration errors
- Docker images for CVE package vulnerabilities

<!-- INDEX_START -->

- [Install](#install)
- [Run](#run)
  - [Filesystem Scan](#filesystem-scan)
  - [Docker Image Scan](#docker-image-scan)
  - [Virtual Machine / AMI Scan](#virtual-machine--ami-scan)
- [Ignoring False Positives](#ignoring-false-positives)
- [Jenkins CI/CD](#jenkins-cicd)

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

### Docker Image Scan

Scan container images:

```shell
trivy image "$docker_image"
```

Scan the docker image for a given running container:

```shell
trivy image "$(docker inspect --format='{{.Image}}' "$container_id_or_name">)"
```

### Virtual Machine / AMI Scan

<https://www.aquasec.com/blog/trivy-now-scans-amazon-machine-images-amis/>

```shell
trivy vm export-ami.vmdk
```

```shell
trivy vm ebs:${your_ebs_snapshot_id}
```

```shell
trivy vm snapshot_id.img
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

## Jenkins CI/CD

[HariSekhon/Jenkins](https://github.com/HariSekhon/Jenkins)

Jenkins CI/CD functions for running Trivy are available here:

[HariSekhon/Jenkins - vars/trivy.groovy](https://github.com/HariSekhon/Jenkins/blob/master/vars/trivy.groovy)

[HariSekhon/Jenkins - vars/trivyFS.groovy](https://github.com/HariSekhon/Jenkins/blob/master/vars/trivyFS.groovy)

[HariSekhon/Jenkins - vars/trivyImages.groovy](https://github.com/HariSekhon/Jenkins/blob/master/vars/trivyImages.groovy)

From
[HariSekhon/Diagrams-as-Code](https://github.com/HariSekhon/Diagrams-as-Code#jenkins-cicd-on-kubernetes)
repo:

![](https://raw.githubusercontent.com/HariSekhon/Diagrams-as-Code/master/images/jenkins_kubernetes_cicd.svg)
