# Coder

<https://coder.com/>

Self-hosted enterprise Dev environments.

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Coder CLI](#coder-cli)
  - [Install CLI](#install-cli)
  - [Local Server](#local-server)
  - [CLI Usage](#cli-usage)
  - [Configure SSH](#configure-ssh)
- [Disabling SSH](#disabling-ssh)
  - [Beware Upgrade Issues](#beware-upgrade-issues)

<!-- INDEX_END -->

## Key Points

- Open-core model
- Enterprise is expensive to license - the price isn't on the website, you have to contact Sales which should give you a hint!

## Coder CLI

The same binary is used for server and CLI.

### Install CLI

To install it on Mac:

```shell
brew install coder/coder/coder
```

or more generically:

```shell
curl -L https://coder.com/install.sh | sh
```

(which on Mac just runs the above brew install)

To install specific binary versions from GitHub releases, use [DevOps-Bash-tools](devops-bash-tools.md):

```shell
install_coder_cli.sh
```

You can specify a version number arg, otherwise it auto-determines the latest version from GitHub releases.

### Local Server

To start your own local coder server for testing:

```shell
coder server
```

then browse to <http://localhost:3000>

### CLI Usage

```shell
coder login https://coder.$MYDOMAIN
```

opens your browser to `https://coder.$MYDOMAIN/cli-auth` which gives you a session token
to paste into your terminal to authenticate.

### Configure SSH

Once authenticated:

```shell
coder config-ssh
```

## Disabling SSH

Enterprise edition is needed to disable SSH for data safety in an enterprise that does not want people copying data in or out of the environment.

Unfortunately since it's expensive to license, this is the workaround to block it if using the open source:

Block the `/api/v2/deployment/ssh` endpoint in the Kubernetes
[ingress.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/ingress.yaml)
via an annotation like this:

```yaml
  annotations:
    nginx.ingress.kubernetes.io/configuration-snippet: |
      location ~* /api/v2/deployment/ssh {
        deny all
        return 403
      }
```

This results in:

```shell
coder config-ssh
```

getting this error:

```html
version mismatch: client v2.13.0+56bf386, server v2.9.0+3215464
download the server version with: 'curl -L https://coder.com/install.sh | sh -s -- --version 2.9.0'
Encountered an error running "coder config-ssh", see "coder config-ssh --help" for more information
error: Trace=[fetch coderd config failed: ]
unexpected non-JSON response "text/html"
<html>
<head><title>403 Forbidden</title></head>
<body>
<center><h1>403 Forbidden</h1></center>
<hr><center>nginx</center>
</body>
</html>
```

### Beware Upgrade Issues

If you upgrade Coder you need to check that this URL hasn't changed such that SSH is silently unblocked.

The other alternative would be to patch the code and do something like a return statement at the top of the function that handles the SSH to make it a no-op, but that is likely harder to maintain (could do a derived [Docker](docker.md) image and patch it in the [Dockerfile](dockerfile.md)).
