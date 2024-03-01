# HTTP Proxying

## Client Apps Using Proxies

Use Cases:

- egress traffic to the internet from corporate networks for security controls and auditing - typical in banking
(I've [worked](https://www.linkedin.com/in/HariSekhon) for several large well known banks)


- reverse proxies like [Squid](https://www.squid-cache.org/)


- used by package managers and build tools to download programming language libraries eg. `mvn` for Java to pull from
Maven Central, `pip` for Python to pull from PyPI etc.


- [SSH tunnels in GCP](ssh-tunnelling.md#gcp) used by `kubectl` to access protected GKE clusters master control plane API

### Environment Variables - `https_proxy` / `no_proxy`

- `https_proxy` - tells applications using libraries like `libwww` to send the packets to this addresses to be
  forwarded
  on.

- `no_proxy` - comma separated list of domains / FQDNs to not use the proxy

You can use `HTTPS_PROXY` and `NO_PROXY` too but the lowercase variables have higher precedence for most applications,
except for Golang. See [here](https://about.gitlab.com/blog/2021/01/27/we-need-to-talk-no-proxy/) for the rules
various apps and languages follow.

Set both uppercase and lowercase to be the same to avoid any nasty surprises.

```shell
export https_proxy=http://localhost:8080
export no_proxy="domain1.com,host.domain2.com"

export HTTPS_PROXY="$https_proxy"
export NO_PROXY="$no_proxy"
```
