# Grype

[:octocat: anchore/grype](https://github.com/anchore/grype)

Security scanning CLI tool for vulnerabilities, leaked secrets and misconfigurations.

Scans:

- Files for secrets and configuration errors
- Docker images for CVE package vulnerabilities

<!-- INDEX_START -->

- [Install](#install)
- [Run](#run)
  - [Filesystem Scan](#filesystem-scan)
  - [Docker Image Scan](#docker-image-scan)
- [Jenkins CI/CD](#jenkins-cicd)

<!-- INDEX_END -->

## Install

On Mac, using [Homebrew](brew.md):

```shell
brew install grype
```

Or download the latest binary from GitHub or any specific version using [DevOps-Bash-tools](devops-bash-tools.md) script:

```shell
install_grype.sh  # "$version"
```

which installs to `/usr/local/bin/grype`, or `$HOME/bin/grype` if you don't have write permission to `/usr/local/bin`.

## Run

### Filesystem Scan

Filesystem scan and exit with code 1 for any `HIGH` OR `CRITICAL` level issues:

```shell
grype dir:"$dir" --verbose --fail-on 'high'
```

### Docker Image Scan

Scan container images:

```shell
grype '$docker_image' --verbose --scope all-layers --fail-on 'high'
```

Scan the docker image for a given running container:

```shell
grype image "$(docker inspect --format='{{.Image}}' "$container_id_or_name">)" --verbose --scope all-layers --fail-on 'high'
```

## Jenkins CI/CD

[HariSekhon/Jenkins](https://github.com/HariSekhon/Jenkins)

Jenkins CI/CD functions for running Grype are available here:

[HariSekhon/Jenkins - vars/grype.groovy](https://github.com/HariSekhon/Jenkins/blob/master/vars/grype.groovy)

[HariSekhon/Jenkins - vars/grypeFS.groovy](https://github.com/HariSekhon/Jenkins/blob/master/vars/grypeFS.groovy)

From
[HariSekhon/Diagrams-as-Code](https://github.com/HariSekhon/Diagrams-as-Code#jenkins-cicd-on-kubernetes)
repo:

![](https://raw.githubusercontent.com/HariSekhon/Diagrams-as-Code/master/images/jenkins_kubernetes_cicd.svg)
