# SSH Tunnelling

## Generic SSH Port Forwarding

SSH login to `host1` and bind local port number to forward through the ssh tunnel to `host2` on the specified port.

```shell
ssh -L <local_port>:<host2>:<host2_port> <user>@<host1>
```

Then just connect to the localhost `127.0.0.1:<port>` so network packets sent to that local port will tunnel through
SSH and be forwarded on the other side from the ssh server on that same port.

WARNING: you probably don't want to use `-R` because that would bind the port on the remote `host1` in a way that
anybody could connect to it - it wouldn't be protected inside an SSH tunnel on your local machine, and nor would
your network packets between your machine and `host1`.

##### Use Case Example

I used to use this `-L` tunnel to my home Subversion server in the 2000s to commit my home directory configs and
personal scripts for my l33t Gentoo workstation & laptop. Thankfully the superior [Git](git.md) and remote working both
kill the need for such tunnelling just to commit.

## HTTP Proxying

See [HTTP Proxying](http-proxying.md) for how to standard web application clients to use proxies including
programming build tools and CLIs which are really Rest API clients like `kubectl`.

## GCP

On GCP, you may tunnel through a bastion host like this:

(exclude `googleapis.com` otherwise `gcloud` CLI won't be able to connect to Google since it is the tunnel which is
not up yet)

```shell
export no_proxy="googleapis.com"
export NO_PROXY="$no_proxy"
export PROJECT_PROXY_PORT=8888

gcloud compute ssh bastion-vm -- -4 -N \
      -L "$PROJECT_PROXY_PORT:127.0.0.1:$PROJECT_PROXY_PORT" \
      -o "ExitOnForwardFailure yes" \
      -o "ServerAliveInterval 10"

export https_proxy="http://localhost:$PROJECT_PROXY_PORT"
export HTTPS_PROXY="$https_proxy"
```
