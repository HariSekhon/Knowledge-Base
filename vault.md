# Hashicorp Vault

https://developer.hashicorp.com/vault

The leading open source secrets manager.

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


If the VAULT_* environment variables are set, the autocompletion will automatically query the Vault server and return helpful argument suggestions.

## Commands

https://developer.hashicorp.com/vault/docs/commands
