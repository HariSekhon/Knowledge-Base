# HAProxy

<https://docs.haproxy.org/>

Open source software Load Balancer.

- fast & optimized, written in C
- HA - combine with VRRP daemon `keepalived` for IP failover, faster than Heartbeat, more seamless

<!-- INDEX_START -->

- [Commercial Appliance](#commercial-appliance)
- [HAProxy Configs](#haproxy-configs)
- [Affinity vs Persistence](#affinity-vs-persistence)
- [Logging](#logging)
- [Comparisons vs Alternatives](#comparisons-vs-alternatives)
- [Load Balancing Algorithms](#load-balancing-algorithms)
- [Linux - allow HAProxy to bind to IP of VIP from Keepalived](#linux---allow-haproxy-to-bind-to-ip-of-vip-from-keepalived)
- [Monitoring](#monitoring)
- [Global Config](#global-config)
- [Stats](#stats)
- [haproxy.cfg](#haproxycfg)
- [Health Checks](#health-checks)
- [DNS](#dns)
- [UserLists](#userlists)
- [ACLs](#acls)
- [Stick Tables vs Source Balance + HA Peers](#stick-tables-vs-source-balance--ha-peers)
  - [Stick Tables](#stick-tables)
- [Alert Emails](#alert-emails)
- [Variables](#variables)

<!-- INDEX_END -->

## Commercial Appliance

- [ALOHA](https://www.haproxy.com/products/haproxy-aloha) - HAProxy appliance (hardware or virtual appliance) by HAProxy Inc

## HAProxy Configs

HAProxy configurations for many common open source technologies are readily available here:

[HariSekhon/HAProxy-configs](https://github.com/HariSekhon/HAProxy-configs)

## Affinity vs Persistence

- Affinity    - uses info below the L7 application layer to maintain a client request to a server eg. source IP
- Persistence - uses L7 info eg. HTTP cookies - more accurate, better for cache hits


- single threaded single process with multiple listening proxy instances (ssl offloader is only good use for multiple procs)
- does most of work in kernel


- stateless after start
- runs in chroot jail (empty)
  - no access to filesystem, cannot modify a single file
- starts as root, drops privileges
- reload starts new process to read cfg file and phases out old one

| State Change   | Signal    | Description                              |
|----------------|-----------|------------------------------------------|
| Stop / Restart | `SIGTERM` | Kills connections                        |
| Reload         | `SIGUSR1` | Gracefully allows connections to finish  |

- TCP + HTTP Proxy  (Layer 4 -7, not below - no IP / UDP / NAT / DSR - IPVS can do these)
- reverse proxy
- tcp + http normalizer
- content switch (http(s)/ssh over same port)
- traffic regulator
- DoS protection based on stats per IP
- http compression offload

## Logging

- only logs to Syslog, not local files or sockets
- network logging (detailed configurable logging with millisecond precision)


## Comparisons vs Alternatives

HAProxy is a better Load Balancer than:

| Rival   | Comparison                                                                                                                                                                                                                    |
|---------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Nginx   | - Uses prod traffic to detect failures<br/>- less LB algos<br/>- limited stickyness / persistence)<br/>- Nginx stats stub<br/>- too basic, only 7 overall metrics, not granular per service like HAProxy frontends / backends |
| Varnish | real health checks but no stickyness, designed for caching                                                                                                                                                                    |


- URI - location, name or both
- URN - address
- URL - scheme:// + address - an absolute URI
- path - /blah.html
- query string - ?param=1

Show build details and in-built limits:

```shell
haproxy -vv
```

Foreground debug mode:

```shell
haproxy -d
```

Start with a specific config file:

```shell
haproxy -f haproxy.cfg
```

Multiple config files are effectively cat'd together:

```shell
haproxy -f config1.cfg -f config2.cfg
```

loads dir/*.cfg in lexical order

```shell
haproxy -f dir/
```

health checks:
- expect for content
- agents to report load or admin states
- atomically fail entire host if 1 server process is broken

## Load Balancing Algorithms

| Algorithm  | Description                                                                                                                                         |
|------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| roundrobin | sends a request to each server in turn                                                                                                              |
| static-rr  | no dynamic weight adjustment, 1% less CPU                                                                                                           |
| leastconn  | use for long running connections eg. SQL, LDAP, RDP, IMAP, or if some backend servers are faster so reply and close their connection replies faster |
| source     | src IP hash-mod distribution, consistent hashing (XXX: will rebalance on server add/remove breaking sessions)                                       |
| uri        | best for HTTP Caches - avoid cache miss/duplication so global cache becomes sum of all caches!                                                      |
| hdr        | HTTP header                                                                                                                                         |
| first      | used with maxconn to load least number of first servers so rest can be powered down (eg. AWS dynamic scaling)                                       |

- server weighting
- dynamic weighting for CLI or agents
- slow start (gradually ramp up servers)
- stats
- stickyness / affinity / persistence based on:
- cookies - better to insert cookie and detect in next client request than to try to learn from server response
- HTTP headers
- URI

fast HTTP log parser showing stats for live debugging
halog

CLI via docket - show status, conns, dynamic weighting adjustment, change server address etc.
socat /var/run/haproxy.sock

## Linux - allow HAProxy to bind to IP of VIP from Keepalived

`/etc/sysctl.conf`:

```
net.ipv4.ip_nonlocal_bind = 1
```

```shell
sysctl -p
```

## Monitoring

Stats - Idle %
CLI   - Idle-pct
echo "show info" | socat /var/run/haproxy.sock | grep '^Idle'

## Global Config

<https://github.com/HariSekhon/HAProxy-configs/blob/master/10-global.cfg>

## Stats

<https://github.com/HariSekhon/HAProxy-configs/blob/master/20-stats.cfg>

## haproxy.cfg

haproxy.cfg:

```haproxy
global
# only logs to Syslog (runs in chroot jail, no file or socket access)
log     syslog1:514 local0 info
#mode tcp # default, use for SSL, SSH, SMTP, IMAP etc
# dissects HTTP contents
mode    http
tune.bufsize 16384 # requests  > 16384  =>  400 Bad Request
# responses > 16384  =>  502 Bad Gateway

listen section useful for tcp only servers

defaults
log global                          # frontends logs connections, backends log servers => up/down
#option          tcplog             # richer logging, use with 'mode tcp' - shows conn numbers, frontend + backend
mode            http                # default: 'mode tcp'
option          httplog             # richer logging, use with 'mode http' - shows status codes, URLs etc
#option          log-health-checks  # logs every health check than just changes, this way can see different failur types eg. fail vs conn refused vs timeouts
option          log-separate-errors # increase log level for failures/errors/timeouts to make them easier to find and separate in logs (do not filter out of main log to preserve timeline)
option          logasap             # log immediately, don't wait for session end to record size, combine with 'option httplog' and capture 'Content-length' header
#capture request  header Content-length 10  # capture Content-length to logs, limiting to 10 chars
#        response
option          http-keep-alive     # default, relies on Cotent-length header to break up responses (server must reply in same order)
# http pipelining uses keep alive - sends multiple reqs before waiting for response, eliminating response latency (eg. image loads)
option          forwardfor  except 127.0.0.1   # add X-Forwarded-For header for application server to be able to determine real client
option          spread-checks 5     # add random % delay to healthchecks - use when lots of backends point to the same servers
monitor-net     x.x.x.x/y           # return 200 OK or 503 to this IP/net - used to test just HAProxy status of service, eg. Nagios
monitor-uri     /haproxy_health
#option         allbackups          # use all backups not just first one
#option         checkcache
#option         clitcpka            # client tcp keepalives (stops Juniper firewalls from closing idle connections) - socket level only
#option         srvtcpka            # server tcp keepalives
#option         tcpka               # both client + server keepalives
#option         contstats           # continuous stats collection for smoother graphs with ong session counts (otherwise only updates stats on session close)
option          socket-stats        # provide stats for each socket
#no option tcp-smart-connect        # do not delay ACK to skip one ACK when network packet tracing as it's confusing
permit          rdp-cookie          # enable RDP cookie based persistence for Microsoft Terminal Servers (see docs for full example config)
rate-limit      sessions 10         # 10 new sessions per src ip
timeout         http-keep-alive     # default: http-request timeout else 'timeout client'
stats socket    /var/run/haproxy.sock uid hari group mygroup mode 0600 level admin # socat /var/run/haproxy.sock

non-interactive
echo "show info; show stat; show table" | socat /var/run/haproxy.sock stdio

interactive with readline support
socat /var/run/haproxy.sock readline
>

'level user' => stats sockets read-only, no counter resets
'maxqueue 0' => do not requeue elsewhere may break session (default)
inter 2s fastinter 2 downinter 2
```

## Health Checks

```haproxy
backend
option          mysql-check
option          pgsql-check
option          redis-check         # socket test PING -> +PONG
option          ldap-check          # check server speaks LDAPv3
option          smtpchk
option          ssl-hello-check     # shallow SSLv3 hello - works without SSL being compile in - prefer check-ssl if compiled with SSL support

    #################
    # XXX: Careful - can run this even on TCP ports (expecting output from inetd socket scripts) but very useful with port overrides to health check based on HTTP API status (see apache-drill.cfg in nagios-plugins repo)
    #
    option     httpchk GET /  # default: OPTIONS /
    http-check expect status 200
                      rstatus <regex>
                      string <string> # from HTTP body
                      rstring <regex>

    #################
    option          tcp-check           # wait for socket msg (POP, IMAP, SMTP, FTP, SSH, TELNET)
    tcp-check       comment     "sending ping"
    tcp-check       send        PING\r\n
    tcp-check       expect      string  +PONG
    tcp-check       comment     "checking role"
    tcp-check       send        "info replication\r\n"
    tcp-check       expect      string  "role:master"
                                rstring
    #################
    option          external-check
    external-check  myCommand <proxy_addr> <proxy_port> <server_add> <server_port> # arguments + bunch of ENV VARs including these and current conns, max conns
    external-check path "/bin:/usr/bin"

default http-instances
mode http

frontend blah
bind *:8080
# bind *:8443 ssl crt blah.pem
mode http
use backend blah

backend blah
mode http
option httplog
balance roundrobin # (default) - algorithms: roundrobin, static-rr, leastconn, first, source (client IP)
default-server <settings> # apply settings to all servers in backend
# s1 appears in logs
# if port not specified then uses port from frontend that client used to connect to backend server (don't omit backend ports - could change frontend port to avoid conflict eg. Ambari vs Presto 8080)
server s1 docker.localdomain:80 check     # enable healthcheck (otherwise always considered available)
check-ssl # check-ssl makes whatever check use SSL
backup    # only use this server if all non-backup servers are down
cookie <value>  # set response cookie to <value> - can be used for cookie based balancing or to share cookie between servers
fall 3  # DOWN server after N failed healthchecks
rise 2  # UP server after N successful healthchecks
init-addr last,libc,none  # defined resolver mechanism - resolve FQDNs using saved state
# else libc (system resolver - /etc/resolv.conf, /etc/hosts)
# else none (ignore server - do not fail startup) [default: last,libc]
inter 2s     # interval between health checks (default 2000 [ms]) when 100% UP
fastinter N  # interval between health checks when going UP/DOWN, defaults to inter
downinter N  # interval between health checks when 100% DOWN, defaults to inter
maxconn   # server limits
maxqueue  # redispatches to queue on another server if hits these limits - may break persistence
minconn
fullconn  # backend limit
non-stick # do not stick persistence (use on 'backup' servers)
observe <layer4|layer7>  # set health based on observec server/error responses to clients
resolvers mydnslist resolve-net 192.168.0.0/16,172.168.0.0/16,10.0.0.0/8 # prefer DNS resolves addresses in this order in case multiple IP resultes are returned by DNS servers - use to prefer internal networks or local datacenters
slowstart 10s # ramp up new servers slowly linearly 0-100% of minconn to maxconn over this time (does not apply to HAProxy [re]start)
ssl        # use SSL to servers (must use 'verify' to protect from MITM attacks)
verifyhost # use with verify to check ssl cert subject matches host
weight N   # 1-256 relative weight to other servers in backend - use in tens to allow more room for adjustments up/down (default: 1)

Affinity:
balance source  # by src ip
#hash-type map-type or consistent - see docs for different algos

Persistence:
balance roundrobin
# insert   - sets SERVERID cookie if client doesn't already supply one
# indirect - replaces cookie from server, removes cookie from client request so persistence mechanism is totally transparent to application
# nocache  - sets "Cache-Control: nocache" HTTP header to prevent caching SERVERID in proxies as should be individual to user
cookie SERVERID insert indirect nocache
server 192.168.99.100 192.168.99.100:80 check cookie s1
server docker docker:80 check cookie s2

    # prefixes JSESSIONID cookies from server with 's1' + delimiter '~' ('s1~JSESSIONID=...'), strips it off from client request to restore JSESSIONID
    # do not use 'prefix' with 'indirect' otherwise server cookie updates may not be passed back to client
    cookie JSESSIONID prefix nocache
    server docker docker:80 check cookie s1
```

Health Check Authentication:

```shell
echo -n "user:pass" | base64
```

```haproxy
option httpchk GET / HTTP/1.0\r\nAuthorization:\ Basic\ <hash_from_above_command>
```

## DNS

Backend server if given a DNS FQDN:

- resolved once at startup + cached for lifetime of process
- startup will fail if DNS resolution of any backend server fails, see `init-addr` to disable startup failure
- periodically re-resolved
- will also immediately re-resolve if:
  - healthcheck gets timeout (server may have moved - AWS IP may change on reboot or ELB rebalance)
- every DNS server from `/etc/resolv.conf` is queried
  - first valid DNS response is used
- fails only if every DNS server returns invalid response, eg. `NX` / `timeout` / `refused`
- caches IP responses to accumulate all IPs for situation where DNS server does not return all IPs in each response
  (round robin DNS), caches for `hold obsolete` time without seeing an IP in any response

#### Check the below nameservers are used instead of or in addition to libc functions using `/etc/resolv.conf`?

```haproxy
resolvers mynameservers
  nameserver 1 x.x.x.x:53
  nameserver 2 x.x.x.x:53
  parse-resolv-conf  # add nameservers from /etc/resolv.conf too
  hold valid   10s
  hold obsolete 0s  # caches IPs not seen in any subsequent DNS query responses for this long
  hold nx      5s
  hold timeout 30s
  hold refused 30s
  hold other   30s
  resolve_retries 3
  timeout resolve 1s
  timeout retry   1s

backend webservers
  server s1 hostname1.example.com:80   check  resolvers mynameservers init-addr last,libc,none
  server s2 hostname2.example.com:8080 check  resolvers mynameservers init-addr last,libc,none
  server s3 hostname3.example.com:8080 check  resolvers mynameservers init-addr last,libc,none
```

<https://www.haproxy.com/documentation/haproxy-configuration-tutorials/dns-resolution/>

<https://docs.haproxy.org/2.8/configuration.html#5.3>

## UserLists

```haproxy
userlist myUserList
user hari insecure-password test # groups group1,group2
user hari2 password <hash> # big performance hit
group group1 users hari,hari2
```

## ACLs

```haproxy
frontend/backend/listen
# see docs for full ACL usage
tcp-request   # layer 4 ACLS
tcp-response  # layer 4 ACLS
http-request  # layer 7 ACLS
http-response # layer 7 ACLS
```

    tcp-request connection ...
    tcp-request content ...
    tcp-request inspect-delay <timeout> # wait to inspect whole req for rules

        # case sensitive name    <condition>
    acl internal_networks src 192.168.0.0/16 172.16.0.0/16 10.0.0.0/8
    acl internal_networks hdp_ip(X-Forwarded-For) -f file_of_IP_prefixes.txt
    acl auth_ok http_auth(myUserList)

    http-request allow if internal_networks auth_ok
    http_request auth unless auth_ok

    # rules chain like in firewalls, allow first and then deny rest
    http-request allow if internal_networks
    http-request deny #deny_status 407   # but if there is no handler will use 403 regardless

    # this is equivalent and more concise to the above 2 rules
    #http-request deny if ! internal_networks
    http-request deny unless internal_networks
    # or in 'tcp' mode
    #tcp-request connection reject if ! internal_networks
    tcp-request connection reject unless internal_networks


## Stick Tables vs Source Balance + HA Peers

https://www.haproxy.com/blog/client-ip-persistence-or-source-ip-hash-load-balancing/

- Source Balance - consistent CPU generated, no RAM overhead, may change if recalculated or client IP changes (DHCP, NAT DIPs)
- Stick tables - uses RAM, better balancing
  - can use any algorithm (roundrobin / leastconn)
  - takes 50M per 1M sessions table (roughly 50 bytes per IPv4 address) + any strings stored
- Balance Source
- Hash-type consistent - defaults to map-based

### Stick Tables

Stick Tables send latest store to peers so two HAProxy instances are synchronized for failover

```haproxy
peers myPeers
peer haproxy2 x.x.x.x:1024
```

backend blah
stick on src
stick-table type ip size 20k peers myPeers

## Alert Emails

```haproxy
mailers myMailers
mailer smtp1 x.x.x.x:25
mailer smtp2 x.x.x.x:25
timeout mail 20s
```

```haproxy
backend blah
email-alert mailers myMailer
email-alert to      hari@domain.com
email-alert from    hari@domain.com
```

## Variables

Environment variables can be used in config - may have braces eg. `${VAR1}`

`site.env`:

```haproxy
export LISTEN=*
export SYSLOGHOST1=x.x.x.x:514
export SYSLOGHOST1=y.y.y.y:514
export STATS_CREDS=myuser:mypass
export SERVER1=192.168.99.100
export SERVER2=docker
...
```

Source Bash environment variables `.env` file in shell before starting HAProxy:

```shell
source site.env
```

then start HAProxy to use the environment variables from the shell:

```shell
haproxy -f file.cfg
```

`file.cfg`:

```haproxy
global
log "$SYSLOGHOST1"
log "$SYSLOGHOST2"
...
```

###### Ported from private Knowledge Base page 2017+
