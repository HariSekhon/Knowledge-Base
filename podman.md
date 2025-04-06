# Podman & Buildah by Redhat

<!-- INDEX_START -->

- [Podman](#podman)
- [Buildah](#buildah)

<!-- INDEX_END -->

## Podman

- manages containers without a daemon
- non-root daemonless drop-in replacement for Docker
- drop in replacement for Docker CLI command

```shell
yum install -y podman
```

```shell
podman <docker_command_args>
```

```shell
podman pull registry.access.redhat.com/ubi8/ubi
podman pull registry.access.redhat.com/ubi8/ubi-minimal
podman pull registry.access.redhat.com/ubi8/ubi-init
```

```shell
podman pull registry.access.redhat.com/ubi7/ubi
podman pull registry.access.redhat.com/ubi7/ubi-minimal
podman pull registry.access.redhat.com/ubi7/ubi-init
```

Use podman daemon as a Docker replacement:

```shell
sudo systemctl enable --now podman.socket
mkdir -p /etc/containers/containers.conf.d
echo 'service_timeout=0' > /etc/containers/containers.conf.d/timeout.conf
sudo ln -s /run/podman/podman.sock /var/run/docker.sock
```

or rootless:

```shell
systemctl --user enable --now podman.socket
XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock
export DOCKER_SOCK=$XDG_RUNTIME_DIR/podman/podman.sock
```

## Buildah

[:octocat: containers/buildah](https://github.com/containers/buildah)

Buildah builds OCI images from files without Docker daemon:

- without needing package manager in the image
- can use Dockerfiles
