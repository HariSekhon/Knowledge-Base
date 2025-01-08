# tfenv

[:octocat: tfutils/tfenv](https://github.com/tfutils/tfenv)

Installs multiple versions of Terraform to `~/.tfenv` in order to maintain compatibility with different Terraform code
bases.

Otherwise using a newer globally installed version of Terraform will upgrade the `terraform.tfstate` file and break
other clients who will be forced to upgrade to the same version in order to run again.

<!-- INDEX_START -->

- [Install](#install)
- [Usage](#usage)
  - [Environment Variables](#environment-variables)
  - [`.terraform-version`](#terraform-version)

<!-- INDEX_END -->

## Install

On Mac, install tfenv:

```shell
brew install tfenv
```

Install on Linux (git clones / pulls updates to `~/.tfenv`), using script from [DevOps-Bash-tools](devops-bash-tools.md):

```shell
install_tfenv.sh
```

## Usage

List available versions:

```shell
tfenv list-remote
```

Install specific version to match the existing `terraform.tfstate` file.

```shell
tfenv install <version>
```

or if you don't care about a specific version and just quickly want the latest:

```shell
tfenv install latest
```

Ensure `~/.tfenv/bin/` is early in your shell `$PATH` (automatically sourced in [DevOps-Bash-tools]
(devops-bash-tools.md)
shell).

Then just use `terraform` like usual.

Once you have more than one version of Terraform installed, switch to another version:
another version:

```shell
tfenv use <version>
```

### Environment Variables

You can set the environment variables:

```shell
export TFENV_TERRAFORM_VERSION="1.3.3"
```

```shell
export TFENV_AUTO_INSTALL=true
```

to have `tfenv` automatically download and switch to that version.

Combine this with usage of [direnv](direnv.md) -
see [HariSekhon/Terraform - .envrc](https://github.com/HariSekhon/Terraform/blob/master/.envrc).

### `.terraform-version`

Instead of an environment variable you can create a file `.terraform-version` containing the version:

```shell
cat > .terraform-version <EOF
1.3.3
EOF
```
