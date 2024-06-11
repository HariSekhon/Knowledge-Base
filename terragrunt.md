# Terragrunt

https://terragrunt.gruntwork.io/

Thin wrapper around [Terraform](terraform.md), uses the same arguments as Terraform and passes them to the `terraform` command.

This was designed to reduce duplication when using Terraform code
and support things like variables and relative roots in `provider` and `backend` blocks.

Advocates DRY configuration, which stands for Don't Repeat Yourself.

## Install

[Install doc](https://terragrunt.gruntwork.io/docs/getting-started/install/)

Quickly, if you've got [DevOps-Bash-tools](devops-bash-tools.md), find and install the latest version:

```shell
install_terragrunt.sh
```

Install autocomplete:

```shell
terragrunt --install-autocomplete
```

## Terragrunt Template

Edit to suit your needs:

[HariSekhon/Templates - terragrunt.hcl](https://github.com/HariSekhon/Templates/blob/master/terragrunt.hcl)

Then run...

## Plan & Apply

Almost the same commands just swap `terraform` for `terragrunt`:

```shell
terragrunt plan
```

```shell
terragrunt apply
```
