# Hashicorp Vault

https://developer.hashicorp.com/vault

The leading open source secrets manager.

- stores credentials / secrets / keys / passwords / certificates / API keys
- detailed audit log
- key rolling
- encrypts before writing to disk / consul
- dynamic secrets - AWS backend generates IAM access keys on demand for accessing S3 bucket + revoke them after script finishes
                  - Database backend generates on-demand, time-limited credentials
- data encryption - standard call for apps to encrypt without worrying about the mechanism, eg. before storing to SQL
- revocation - revoke single or whole tree of secrets, or all keys accessible by a user or all keys of a type (useful for leavers, rolling, intrusion lock downs)
- HA - takes lock on storage - Consul (recommended)
                             - ZooKeeper
                             - Etcd
- Auth - AWS, GCP, K8S, Github, Okta, Radius, Tokens, TLS Certs, Username + Pw
- Authz policies
- Audit - file, socket, syslog
        - at least one configured audit device must succeed to complete request
- single static binary (put in $PATH eg. /usr/local/bin)

### Enterprise

- cross DC replication
- UI
- Hashicorp Sentinel policies integration
- AWS / GCP KMS auto unseal
- HSM support

## Install on Mac

```shell
brew tap hashicorp/tap
brew install hashicorp/tap/vault
```

### Install Autocomplete

Adds the entry `complete -C /opt/homebrew/bin/vault vault` to your `~/.bash_profile`:

```shell
complete -C /opt/homebrew/bin/vault vault
```

Restart your shell as a full login shell:

```shell
exec bash -l
```

If the [`VAULT_*` environment variables](https://developer.hashicorp.com/vault/docs/commands#environment-variables)
are set, the autocompletion will automatically query the Vault server and return helpful argument suggestions.

## CLI Settings

Set the following environment variables

```shell
export VAULT_ADDR="https://vault.$MYDOMAIN"
```

```
export VAULT_TOKEN=...
```


## Local Test Server

Run in RAM without TLS (still encrypts data):

```shell
vault server -dev
```

Prints out root token + unseal key + `VAULT_ADDR` environment variable.


## Commands

https://developer.hashicorp.com/vault/docs/commands

```shell
vault status
```

- `secret/` prefix handler tells Vault which secret engine to route to (`secret/` => `kv` engine)

For prod use files or STDIN to avoid storing secret values in shell history:

```shell
vault write secret/blah value=test value2=test2
```

```shell
vault list secrets
```

```shell
vault read secret/blah
```

```shell
vault read -format=json | jq -r .data.value2
```

```shell
vault read -field=value2 secret/blah
```

```shell
vault delete secret/blah
```

Default `<handler>/` path is same as secrets engine name:

```shell
vault secrets enable [-path=kv] kv
```

```shell
vault secrets list
```

Show's vault's contents:

```shell
vault list kv
```

Disable by `<handler>/` path:

```shell
vault disable /kv
```

```shell
vault login "$VAULT_TOKEN"
```

```shell
vault auth enable [-path=github] github
```

Auth backends are always prefix with `auth/<name>`

Configure backend to auth to hashicorp GitHub organisation:

```shell
vault write auth/github/config organisation=hashicorp
```

```shell
vault auth list
```

Show config options:

```shell
vault auth help github
```

```shell
vault auth help aws
```

```shell
vault auth help userpass
```

```shell
vault auth help token
```

```shell
vault login -method=github
```

Revoke logins from GitHub:

```shell
vault token revoke -mode path auth/github
```

Remove GitHub authentication completely

```shell
vault auth disable github
```

###### Ported from private Knowledge Base page 2018+
