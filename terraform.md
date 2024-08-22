# Terraform

Infrastructure-as-Code using HCL manifests to define cloud resources.

Idempotent, queries cloud APIs,
detects what is missing or has changed and then applies the necessary changes to reconcile.

<!-- INDEX_START -->

- [Install Terraform](#install-terraform)
- [Terraform Code](#terraform-code)
- [Running Terraform](#running-terraform)
- [Terraform State](#terraform-state)
- [tfenv](#tfenv)
- [Terragrunt](#terragrunt)
- [tgswtich](#tgswtich)
- [Linting & Security](#linting--security)

<!-- INDEX_END -->

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

Install [tfenv](tfenv.md) to manage multiple versions of Terraform.

When combined with [direnv](direnv.md) this will auto-switch to the saved version of Terraform
recorded in `.envrc` to avoid updating the tfstate file and forcing all colleagues to upgrade their terraform
versions or breaking CI/CD.

[tfswitch](https://github.com/warrensbox/terraform-switcher) is another option by the same author as tgswitch below.

[asdf](https://asdf-vm.com/) is another option - one tool for all runtime versions.

## Terragrunt

Important for modularity and performance of Terraform code bases.

See [Terragrunt](terragrunt.md) for more details.

## tgswtich

Install [tgswitch](tgswitch.md) to manage multiple versions of Terragrunt.

When combined with [direnv](direnv.md) this will auto-switch to the saved version of Terragrunt
recorded in `.envrc`.

This is more recently updated than [tgenv](https://github.com/cunymatthieu/tgenv).

[asdf](https://asdf-vm.com/) is another option - one tool for all runtime versions.

## Linting & Security

- [tfsec](https://github.com/aquasecurity/tfsec)
- [tflint](https://github.com/terraform-linters/tflint)
