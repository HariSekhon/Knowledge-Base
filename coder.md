# Coder

https://coder.com/

Self-hosted enterprise Dev environments.

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

### Disabling SSH

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

#### Beware Upgrade Issues

If you upgrade Coder you need to check that this URL hasn't changed such that SSH is silently unblocked.

The other alternative would be to patch the code and do something like a return statement at the top of the function that handles the SSH to make it a no-op, but that is likely harder to maintain (could do a derived [Docker](docker.md) image and patch it in the [Dockerfile](dockerfile.md)).
