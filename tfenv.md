# tfenv

Installs multiple versions of Terraform to `~/.tfenv` in order to maintain compatability with different Terraform code
bases.

Otherwise using a newer globally installed version of Terraform will upgrade the `terraform.tfstate` file and break
other clients who will be forced to upgrade to the same version in order to run again.

On Mac, install tfenv:

```shell
brew instal tfenv
```

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
