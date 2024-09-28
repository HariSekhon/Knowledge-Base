# Artifactory

<https://jfrog.com/artifactory/>

Repository Manager by JFrog

Scan Artifactory repo mirrors:

- MaxDefender ICAP
- JFrog X-Ray

<!-- INDEX_START -->

- [Artifactory on Kubernetes](#artifactory-on-kubernetes)
- [JFrog CLI](#jfrog-cli)
- [Old Install](#old-install)

<!-- INDEX_END -->

## Artifactory on Kubernetes

[HariSekhon/Kubernetes - artifactory](https://github.com/HariSekhon/Kubernetes-configs/tree/master/artifactory)

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Kubernetes-configs&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Kubernetes-configs)

## JFrog CLI

<https://jfrog.com/getcli/>

from [HariSekhon/DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools) `install/` directory:

Installs and runs setup if `$JFROG_TOKEN` is in the environment:

```shell
install_jfrog_cli.sh
```

Configure if installing manually:

```shell
jf setup "$JFROG_TOKEN"
```

## Old Install

Download, unzip

in `bin/`:

```shell
artifactoryctl start
```

<http://localhost:8081/artifactory>

admin / password

```shell
artifactoryctl check
```

```shell
artifactoryctl stop
```

**Ported from private Knowledge Base page 2016+**
