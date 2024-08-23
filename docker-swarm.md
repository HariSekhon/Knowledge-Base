# Docker Swarm

TL;DR just use [Kubernetes](kubernetes.md) instead - it's the winning open source standard.

<https://docs.docker.com/engine/swarm/>

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Swarm Manager](#swarm-manager)
- [Services](#services)
- [Stacks](#stacks)
- [Swarm Recovery](#swarm-recovery)
  - [Swarm Backup](#swarm-backup)
  - [Swarm Restore](#swarm-restore)
  - [Quorum loss](#quorum-loss)

<!-- INDEX_END -->

## Key Points

- Docker 1.12+
- Simpler than [Kubernetes](kubernetes.md)
- declarative:
  - adds / removes containers to match replica count
  - swarm manager detects worker failures + restarts containers on other workers
- task === container
- overlay multi-host networking
- Service Discovery - auto DNS to containers
  - `<stack>_<service>.N.<random_chars>`
  - XXX: how do we address these hosts in DNS??
- [LB](load-balancing.md) / [DNS](dns.md) Round Robin
- [TLS](ssl.md) mutual by default self-signed or external trusted CA
- rolling updates
- secrets
- ingress routing mesh:
  - `-p <port>:<port>` is deployed to all swarm nodes, can be accessed through any of them
  - LB RR (round robin) distributes to all container instances
- Swarm Managers:
  - elects single leader to conduct orchestration tasks
  - RAFT majority quorum (3 / 5 / 7)
  - service HTTP swarm API
  - init:
    - autogenerates internal root CA (can also use external CA)
    - worker & manager tokens are CA digest + random secret
  - managers are also workers by default
    - set availability to `drain` in production to protect RAFT latency / sensitivity to resource starvation
      eg. heartbeats and leader election
- Swarm Workers:
  - run containers (tasks)
  - report state to managers via gossip protocol
- only swarm managers can start services (but standalone containers can still be run independently on any `dockerd`)
- node == dockerd worker
- services - list of tasks (containers + their commands)
  - replicated services - number of replica tasks
  - global services - run on every node
- tasks cannot be moved to another node, only restarted on another node if worker fails
- rollback (Docker 17.04+ can auto-rollback)

- Rebalance:
  - eventual
  - only new / restarted tasks (containers) are balanced by default to avoid disruptions to existing tasks
  - to force task restarts to balance (will rolling update if they are configured to):

```shell
docker service update --force
```

## Swarm Manager

Creates swarm called `default` + `ingress` overlay network + internal distributed data store for consistent view of
swarm

```shell
docker swarm init --advertise-addr 192.168.99.100  # must specify IP if multiple interfaces
```

Outputs token (use to add workers).

Separate cluster mgmt + data networks:

```shell
docker swarm init # [--advertise-addr 192.168.99.100 --datapath-addr <ip>]
```

```shell
docker swarm join-token manager [-q]
```

```shell
docker swarm join-token worker
```

Add managers for quorum (odd number 3 / 5 / 7), `<Manager_IP>:<Port>`:

```shell
docker warm join --token <manager_token> \
                 --advertise-addr '192.168.99.100' \
                 --availability 'drain' \
                 192.168.99.100:2377  # initialize as manager only
```

Add worker, `<Manager_IP>:<Port>`:

```shell
docker swarm join --token <worker_token> 192.168.99.100:2377
```

```shell
docker node update --availability 'drain' <manager_node>
```

```shell
docker swarm leave # [--force]
```

Make workers into managers:

```shell
docker node promote <node1> <node2>
```

Make managers into workers:

```shell
docker node demote
```

Remove node:

```shell
docker node rm
```

Re-join manager to swarm:

```shell
docker node demote <manager>
```

```shell
docker node rm -f  <manager>
```

```shell
docker swarm join ...
```

See Swarm nodes on Manager:

```shell
docker node ls
```

Swarm active, num managers + nodes:

```shell
docker info
```

## Services

Docker 1.13+ resolves tag hash at service creation time, pinned hash for lifetime of service for consistency
(do not use latest hash will disappear).

```shell
docker service create ... <image>:<tag>
```

```shell
docker service create --replicas 3 \
                      --name redis \
                      --update-delay 10s \
                      redis:3.0.6 \
                      #              10m30s
                      # default: vip (dnsrr bypasses routing mesh so connection hits local dockerd's container - use
                      #               with LB health checks to skip 1 hop or for cookied state routing)
                      #--endpoint-mode dnsrr
                      #--mode=global \
                      #--constraint 'region=east' \
                      #--constraint 'type!=dev' \
                      #--reserve-memory X \
                      #--reserve-cpu X \
                      #--net=myOverlay
                      # default
                      #--update-parallelism 1 \
```

```shell
docker service ls
```

Show nodes running service across swarm ('docker ps' only shows containers on local dockerd)

```shell
docker service ps <name>
```

Show containers running on given node:

```shell
docker node ps <name>
```

```shell
docker container ls
```

Set replicas to 5:

```shell
docker service scale <name>=5
```

So swarm services can talk to each other across nodes:

```shell
docker network create --driver overlay myOverlay
```

Add `-p` mappings eg. `-p 53:53 -p 53:53/udp` (add both) - `published=<outside_port>, target=<container_port>`:

```shell
docker service update --publish-add published=53,target=53 <name>
                                    #protocol=udp  # default: tcp
                                    #mode=host     # default: ingress ('host' bypasses routing mesh - hits local dockerd's container)
                                    #--network-add myOverlay <service_name>
                                    #--network-rm
```

Pretty outputs human indented (default: pprinted json):

```shell
docker service inspect --pretty <name>
```

Redeploy all tasks with new tag (rolling update if configured at service creation time):

```shell
docker service update --image redis:3.0.7 redis
```

To continue update if any problem:

```shell
docker service update redis
```

Rollback to last deployment (Docker 17.04+ can auto-rollback):

```shell
docker service update --rollback redis
```

```shell
docker service remove <name>
```

```shell
docker service rm redis
```

Decommission worker - does not stop `docker run` / `docker-compose` / API created containers.

Set on managers to avoid resource contention against RAFT quorum:

```shell
docker node update --availability 'drain' <name>
```

```shell
docker node inspect --pretty <name>
```

## Stacks

Idempotently re-runnable (won't take down running containers):

```shell
docker stack deploy -c docker-compose.yml
```

```shell
docker stack ls
```

```shell
docker stack rm <name>
```

[docker-compose.yml](https://github.com/HariSekhon/Templates/blob/master/docker-compose.yml):

```shell
<name>:
  image: redis
  deploy:
    replicas: 5
    resources: ...
    restart_policy:
    placement:
    constraints: [node.role == manager]
```

Deploy from private registry:

```shell
docker login myregistry.local
```

```shell
docker stack deploy --with-registry-auth -c docker-compose.yml <name>
```

```shell
docker stack ps
```

```shell
docker stack services <stack_name>
```

```shell
docker secret create mySecret - <<< "test"
```

Secrets are blobs available at `/run/secrets/my_secret`:

```shell
docker service create --name 'myService' --secret 'mySecret' nginx:1.9.1
```

## Swarm Recovery

### Swarm Backup

Shut down 1 manager + back up `/var/lib/docker/swarm`:

```shell
cp -av /var/lib/docker/swarm /mnt/backup/swarm
```

### Swarm Restore

Replace `/var/lib/docker/swarm` from backup.

```shell
docker swarm init --force-new-cluster
```

### Quorum loss

Bring managers back online otherwise on 1 surviving manager:

```shell
docker swarm init --force-new-cluster
```

retains swarm info, re-promote workers to managers.

**Ported from private Knowledge Base page 2014+**
