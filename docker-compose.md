# Docker Compose

Uses a `docker-compose.yml` config file to launch docker containers and settings.

<!-- INDEX_START -->

- [Install](#install)
- [Bash Completion](#bash-completion)
- [Docker Compose File Override](#docker-compose-file-override)

<!-- INDEX_END -->

## Install

<https://docs.docker.com/compose/install/>

or use install script from [DevOps-Bash-tools](devops-bash-tools.md):

```shell
install/install_docker_compose.sh
```

## Bash Completion

```shell
version="$(docker-compose version --short)"

curl -L "https://raw.githubusercontent.com/docker/compose/$version/contrib/completion/bash/docker-compose" \
     -o /etc/bash_completion.d/docker-compose
```

## Docker Compose File Override

Start / restart containers from `docker-compose.yml` and `docker-compose.override.yml`

```shell
export COMPOSE_FILE=jenkins-docker-compose.yml

docker-compose up
```

Notable Switches:

| Switch | Description                    |
|--------|--------------------------------|
| -d     | detached                       |
| -p     | <project_name>                 |
| -f     | alternative-docker-compose.yml |

```shell
docker-compose -d -f docker-compose.yml -f docker-compose.prod.yml up
```

Only starts previously created containers

```shell
docker-compose start
```

Equivalent of `docker run -ti`:

```shell
docker-compose run -e DEBUG=1 $service $command
```

If `DEBUG` doesn't have a value argument it'll take DEBUG from the environment variable `DEBUG`

```shell
docker-compose exec $service $command
```

```shell
docker-compose down
```
