# Coder

https://coder.com/

Self-hosted enterprise Dev environments.

- open-core freemium model
- expensive to license

### Disabling SSH

Enterprise edition is needed to disable SSH for data safety in an enterprise that does not want people copying data in or out of the environment.

Unfortunately since it's expensive to license, this is the workaround to block it if using the open source:

Block the `/api/v2/deployment/ssh` endpoint in the Kubernetes ingress via an annotation like this:

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
