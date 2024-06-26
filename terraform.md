# Terraform

Infrastructure-as-Code using HCL manifests to define cloud resources.

Idempotent, queries cloud APIs,
detects what is missing or has changed and then applies the necessary changes to reconcile.

## Install Terraform

Quick install script is found in the [DevOps-Bash-tools](devops-bash-tools) repo:

```shell
install_terraform.sh
```

Optionally specify a version argument, otherwise defaults to finding out and installing the latest version.

## Terraform Code

See the [HariSekhon/Terraform](https://github.com/HariSekhon/Terraform) repo for some Terraform code and templates
for common files and settings to get you started, such as `backend.tf`, `provider.tf`, `main.tf` etc.

## Running Terraform

Download the providers and create or connect to the `terraform.tfstate` file:

```shell
terraform init
```

Format you code:

```shell
terraform fmt
```

Validate your code:

```shell
terraform validate

```
See the plan of additions/deletions/modifications that Terraform would do:

```shell
terraform plan
```

Apply the changes:

```shell
terraform apply
```

## Terraform State

Stored in a `terraform.tfstate` either locally or more usually in a cloud bucket to be shared among users or from a
[CI/CD](ci-cd.md) system.

This is just a JSON file so you can read its contents to find out what version of Terraform it is using.

[terraform_gcs_backend_version.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/terraform/terraform_gcs_backend_version.sh)
is a convenience script to determine this straight from a GCS bucket.

## tfenv

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

## Terragrunt

Important for modularity and performance of Terraform code bases.

See [Terragrunt](terragrunt.md) for more details.

## Linting & Security

- [tfsec](https://github.com/aquasecurity/tfsec)
- [tflint](https://github.com/terraform-linters/tflint)
