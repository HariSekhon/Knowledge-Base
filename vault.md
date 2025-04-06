# Hashicorp Vault

<https://developer.hashicorp.com/vault>

The leading open source secrets manager.

<!-- INDEX_START -->

- [Key Points](#key-points)
  - [Enterprise](#enterprise)
- [Install on Mac](#install-on-mac)
  - [Install Autocomplete](#install-autocomplete)
- [CLI Settings](#cli-settings)
- [Local Test Server](#local-test-server)
- [Commands](#commands)
- [Secret Integrations](#secret-integrations)
  - [GitHub Actions CI/CD](#github-actions-cicd)
  - [Kubernetes](#kubernetes)

<!-- INDEX_END -->

## Key Points

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

```shell
export VAULT_TOKEN=...
```

## Local Test Server

Run in RAM without TLS (still encrypts data):

```shell
vault server -dev
```

Prints out root token + unseal key + `VAULT_ADDR` environment variable.

## Commands

<https://developer.hashicorp.com/vault/docs/commands>

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

## Secret Integrations

### GitHub Actions CI/CD

[:octocat: hashicorp/vault-action](https://github.com/hashicorp/vault-action)

### Kubernetes

<https://bank-vaults.dev>

<https://developer.hashicorp.com/vault/tutorials/auto-unseal/autounseal-aws-kms>

Create an ACL policy in Vault at `$VAULT_URL/ui/vault/policies/acl` with the following contents (HCL format):

```hcl
path "<engine_name>/data/<folders>/<secret>" {
  capabilities = ["read", "list"]
}
```

(the `/data/` part of the path is important and part of the API call, you cannot omit it otherwise you will get API
errors like forbidden or not found)

Then reference it in the Kubernetes [deployment.yaml]() with the following annotations:

```yaml
spec:
  template:
    metadata:
      annotations:
        vault.security.banzaicloud.io/vault-addr: <VAULT_HTTPS_URL>
        vault.security.banzaicloud.io/vault-path: </path/to/secret>
        vault.security.banzaicloud.io/vault-role: <role_you_created>
        #vault.security.banzaicloud.io/vault-skip-verify: "true"  # try not to do this
```

or rather [Helm](helm.md) templated out via `values-<env>.yaml`because this is likely to be different per environment.

**Ported from private Knowledge Base page 2018+**
