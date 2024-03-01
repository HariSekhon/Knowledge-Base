# SSH Tunnelling

## GCP

On GCP, you may tunnel through a proxy host like this:

unsetting `HTTPS_PROXY` ensures `gcloud` commands can access the Google APIs (could also just move `NO_PROXY` higher up)

```shell
unset HTTPS_PROXY
export PROJECT_PROXY_PORT=8888

gcloud compute ssh bastion-vm -- -4 -N \
      -L "$PROJECT_PROXY_PORT:127.0.0.1:$PROJECT_PROXY_PORT" \
      -o "ExitOnForwardFailure yes" \
      -o "ServerAliveInterval 10"

export HTTPS_PROXY="http://localhost:$PROJECT_PROXY_PORT"
export NO_PROXY="googleapis.com"
```

`NO_PROXY` is necessary to not suffer the performance or blocking should the port become unavailable
