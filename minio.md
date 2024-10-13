# MinIO

S3 open source server software.

Useful for testing S3 code.

<!-- INDEX_START -->

- [Command Line](#command-line)

<!-- INDEX_END -->

## Command Line

```shell
kubectl exec -ti -n my-namespace minio-cli --container minio-cli -- /bin/bash
```

This will confirm:

```shell
mc alias set my-alias http://minio.my-namespace.svc.cluster.local my-user my-password
```

output:

```text
Added `my-alias` successfully.
```

If there is a problem, it will refuse to create the alias:

```text
mc: <ERROR> Unable to initialize new alias from the provided credentials. Get "http://minio.my-namespace.svc.cluster.local:9000/probe-bsign-..../?location=": dial tcp x.x.x.x:9000: i/o timeout.
```

Above it is using the wrong port (the pod uses 9000 but the address is pointing to a service using port 80)

```shell
mc ls my-alias/my-bucket/
```
