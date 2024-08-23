# Docker

<https://www.docker.com/>

Lightweight application containers containing app + all dependencies.

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Docker on Ubuntu](#docker-on-ubuntu)
- [Volumes](#volumes)
- [Docker Scan](#docker-scan)
- [Buildx](#buildx)
- [Sharing Cache between hosts](#sharing-cache-between-hosts)
- [Clean up Docker](#clean-up-docker)
- [Dockerfile](#dockerfile)
- [Docker Compose](#docker-compose)
- [Podman & Buildah](#podman--buildah)
- [Container Diff](#container-diff)
- [Java Licensing Problem in Docker](#java-licensing-problem-in-docker)
- [Details](#details)
  - [Ports](#ports)
  - [Components](#components)
  - [Filesystem](#filesystem)
- [Logging](#logging)
- [DevOps-Python-tools](#devops-python-tools)
- [DevOps-Bash-tools](#devops-bash-tools)
- [Captain](#captain)
- [Portainer](#portainer)
- [Play with Docker](#play-with-docker)
- [DCHQ](#dchq)
- [Useful Commands](#useful-commands)
  - [Inspect docker image filesystem](#inspect-docker-image-filesystem)
  - [Delete Stopped Containers](#delete-stopped-containers)
  - [Delete Dangling Docker Images](#delete-dangling-docker-images)
  - [Delete Old Docker Images](#delete-old-docker-images)
- [Monitoring / Prometheus Scrape Target](#monitoring--prometheus-scrape-target)
- [Troubleshooting](#troubleshooting)
  - [DNS Issues](#dns-issues)
  - [Elasticsearch 5.0 Docker error](#elasticsearch-50-docker-error)
  - [Slow `COPY` during build on Windows](#slow-copy-during-build-on-windows)

<!-- INDEX_END -->

## Key Points

- Docker Stable - quarterly releases
- Docker Edge - bleeding edge monthly releases
- Docker EE:
  - UCP - Universal Control Plane - UI cluster manager


- Isolation & Security:
  - namespaces - pid, net, ipc, mnt, uts (unix timesharing)
               - cannot see or affect processes in other containers or host system
  - cgroups - control groups optional resource limits
  - networks - own network stack
             - no privileged sockets / interfaces
             - bridges act like ports on ethernet switch
- UnionFS - layered filesystems - AUFS, btrfs, vfs, DeviceMapper
- Container Format - libcontainer
- Swarm - Docker 1.12+
- Labels - key=value pairs
         - apply to any object - containers, volumes, etc

Docker CLI connects to the Dockerd Rest API.

Download the `ubuntu:latest` image for spawning containers from:
```shell
docker pull ubuntu # :tag or @<digestvalue>
```

## Docker on Ubuntu

Install Docker:

```shell
sudo apt-get install -y docker-engine
```

```shell
sudo systemctl start docker
```

Older systems:

```shell
sudo service docker start # old
```

Need access to 660 socket `/var/run/docker.sock`

Add user `hari` to group `docker` and then get the group membership in the current shell without having to log out
and back in or start a new shell:

```shell
sudo gpasswd -a hari docker
newgrp docker
```

## Volumes

- name or anonymous
- can be mounted on multiple containers rw or ro
- managed by docker under `/var/lib/docker/volumes/<name>/data`
- CloudStor plugin stores volumes to AWS S3 or Azure
- mounting empty volume copies files / dirs from container to it to initialize

Standalone containers - creates local dir if not exists:
```shell
docker run -v ...
```

Swarm services - throws error if local dir doesn't exist:

```shell
docker run --mount
```

List volumes:

```shell
docker volume ls
```

Delete unattached volumes:

```shell
docker volume prune
```

Inspect volume details:

```shell
docker volume inspect <name>
```

Delete a volume:

```shell
docker volume rm <name>
```

Detach without stopping - `Ctrl-P`, `Ctrl-Q`

Ansible Docker == Docker Compose (same syntax, both based on on docker-py)

## Docker Scan

Docker Scan uses Snyk to detect vulnerabilities in docker images
- included in Docker Desktop
- requires a plugin in Docker on Linux

in [DevOps-Bash-tools](devops-bash-tools.md):

```shell
install/install_docker_scan.sh
```

docker scan elastic/logstash:7.13.3

## Buildx

Buildx includes layer caching information in the docker image

in [DevOps-Bash-tools](devops-bash-tools.md):

```shell
install/install_docker_buildx.sh
```

```shell
docker buildx ...
```

## Sharing Cache between hosts

<https://docs.docker.com/engine/reference/commandline/build/#specifying-external-cache-sources>

For builder pattern, build and push the 'builder' target separately, then pull it on other machines too.

Enable BuildKit (Docker 18.09+):
```shell
export DOCKER_BUILDKIT=1
```

Store caching data in the image, needs BuildKit enabled above:

```shell
docker build -t myname/myapp --build-arg BUILDKIT_INLINE_CACHE=1 .
docker push myname/myapp
```

On another machine - may need explicit pull before using --cache-from:

```shell
docker pull myname/myapp || :  # pull for cache if available
docker build --cache-from myname/myapp .
```

## Clean up Docker

`devmapper: Thin pool has 156208 free data blocks which is less than minimum required 163840 free data blocks. Create more free space in thin pool or use dm.min_free_space option to change behaviour`

Clean up exited containers:

```shell
docker container prune
```

```shell
docker rm $(docker ps -qf status=exited)
```

Delete old images:

```shell
docker image prune
```

```shell
docker rmi $(docker images -f "dangling=true" -q)
```

Delete all local docker images to clean out your local build system:

```shell
docker images -a -q | xargs docker rmi --force
```

Find unattached volumes:

```shell
docker volume ls -qf dangling=true
```

```shell
docker volume prune --filter "label != keep"
```

```shell
docker network prune
```

All of the above + build cache except --volumes (Docker > 17.05)

```shell
docker system prune
```

## Dockerfile

See [Dockerfile](dockerfile.md) doc.

## Docker Compose

See [Docker Compose](docker-compose.md) doc.

## Podman & Buildah

See [Podman & Buildah](podman.md) doc.

## Container Diff

<https://github.com/GoogleContainerTools/container-diff>

## Java Licensing Problem in Docker

- Oracle Java license does not allow binary redistribution
- OpenJDK is widely used in Docker instea
- Zulu provides free tested compliant OpenJDK

## Details

### Ports

| Port | TCP / UDP | Description                       |
| ---- |-----------|-----------------------------------|
| 2376 | TCP       | Dockerd                           |
| 2377 | TCP       | Swarm management                  |
| 7946 | TCP/UDP   | Swarm container network discovery |
| 4789 | UDP       | overlay network traffic           |

### Components

| Code | Description                            |
| ---- |----------------------------------------|
| commands.go  | CLI                                    |
| api.go       | REST API router                        |
| server.go    | implementation of much of the REST API |
| buildfile.go | dockerfile parser                      |


### Filesystem

| Directory                    |
|------------------------------|
| /var/lib/docker/containers   |
| /var/lib/docker/graph        |
| /var/lib/docker/repositories |
| /var/lib/docker/volumes      |


## Logging

- none
- json-file
- syslog
- journald
- gelf (Graylog, LogStash)
- fluentd - Forward (`--log-opt fluentd-address=host:24224`)
- awslogs - AWS Cloudwatch
- splunk - Splunk's HTTP Event Collector
- etwlogs - Windows Event Tracing
- gcplogs - GCP Logging

json-file / journald logs only:

```shell
docker logs
```

```shell
docker info | grep "Logging Driver"
```

```shell
docker inspect -f '{{.HostConfig.LogConfig.Type}}' <container>
```

`daemon.json`:

```json
"log-driver": "json-file"  # default
```

```shell
docker run --log-driver none
           --log-opt mode=non-blocking   # 2 modes: blocking / non-blocking - apps may fail if STDOUT/STDERR block
           --log-opt max-buffer-size=4m
           --label foo=bar -e os=ubuntu  # json-file logging driver puts label + env in log lines
```

more drivers:
```shell
docker plugin install <org>/<name>
```

show installed:

```shell
docker plugin ls
```

```shell
docker plugin inspect
```


## DevOps-Python-tools

[HariSekhon/DevOps-Python-tools](devops-python-tools.md)

[dockerhub_search.py](https://github.com/HariSekhon/DevOps-Python-tools/blob/master/dockerhub_search.py)

[dockerhub_show_tags.py](https://github.com/HariSekhon/DevOps-Python-tools/blob/master/dockerhub_show_tags.py)

```shell
dockerhub_search.py harisekhon -v
```

Number of repos for a given user or company DockerHub account:

```shell
dockerhub_search.py harisekhon | tail -n +2 | wc -l
```

Number of tags:

```shell
dockerhub_search.py harisekhon |
tail -n +2 |
awk '{print $1}' |
xargs dockerhub_show_tags.py -q -t 300 -vv |
tee /dev/stderr |
grep -v latest |
wc -l
```

## DevOps-Bash-tools

[HariSekhon/DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools#docker)

Some highlights:

`dockerhub_list_tags.sh`

`dockerhub_list_tags_by_last_updated.sh`

`clean_caches.sh` - cleans out OS package and programming language caches, call near end of `Dockerfile` to reduce Docker image size

`docker_registry_list_images.sh` - lists images in a given private Docker Registry

`docker_registry_list_tags.sh` - lists tags for a given image in a private Docker Registry

`dockerhub_api.sh`

`quay_api.sh`

## Captain

<https://github.com/harbur/captain>

Converts Git workflow to Docker containers, CLI `captain push` from CI to build docker containers from CI for each commit

## Portainer

<https://www.portainer.io/>

Container management.

## Play with Docker

<https://labs.play-with-docker.com/>

## DCHQ

<https://dchq.io/>

Automated provision & monitoring of Docker containers on any cloud, composition of complex apps, auditing etc.

## Useful Commands

### Inspect docker image filesystem

```shell
hash=$(docker run busybox)
cd /var/lib/docker/aufs/mnt/$hash
```

### Delete Stopped Containers

To avoid them preventing deletion of old / dangling docker images:

```shell
docker container prune -f
```

### Delete Dangling Docker Images

These are often intermediate image layers that are no longer needed by other images which have been deleted.

```shell
docker rmi $(docker images -f "dangling=true" -q)
```

### Delete Old Docker Images

Delete every image older than a week to clear up disk space.

```shell
docker image prune --all --force --filter "until=1w"
```

If you want to only delete select images older than a given time, see this
[Azure DevOps Pipeline](https://github.com/HariSekhon/Templates/blob/master/azure-pipeline-docker-image-cleanup.yml).

## Monitoring / Prometheus Scrape Target

In `daemon.json`:
```
{ "metrics_addr": "0.0.0.0:9323",
"experimental": true }
```

or
```shell
dockerd --experimental=true --metrics-addr=0.0.0.0:4999
```

See also [HariSekhon/Nagios Plugins](https://github.com/HariSekhon/Nagios-Plugins) `tests/docker/prometheus-docker-compose.yml`

```shell
docker service create --replicas=1 --name prometheus -p 9090:9090 -v prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus
```

## Troubleshooting

### DNS Issues

Failure to resolve happens when Docker host `/etc/resolv.conf` points to local IP

Fix:

```shell
docker-machine ssh default
```

```shell
vim /etc/resolv.conf  # to 4.2.2.1 works
```

### Elasticsearch 5.0 Docker error

```
ERROR: bootstap checks failed
max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
```

Fix:

```shell
sudo sysctl -w vm.max_map_count=262144
mkdir -v /etc/sysctl.d
grep vm.max_map_count /etc/sysctl.d/99-elasticsearch.conf || echo vm.max_map_count=262144 >> /etc/sysctl.d/99-elasticsearch.conf
```

### Slow `COPY` during build on Windows

Example in Dockerfile:

```shell
COPY --from-stage=builder node_modules .
```

This is a small files problem that can manifest in very high CPU usage showing anti-virus software high CPU % seen in Task Manager.

If the above is taking a disproportionate amount of time, try disabling the anti-virus from scanning the agent directory where the workdir is.

For example, adding this exclusion in Semantec anti-virus resulted in a build going from timing out after 2 hours to 2 minutes in Azure DevOps Pipelines on Windows - a shocking performance difference.

###### Partial port from private Knowledge Base page 2014+
