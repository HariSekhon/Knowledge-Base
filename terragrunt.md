# Terragrunt

https://terragrunt.gruntwork.io/

Thin wrapper around [Terraform](terraform.md), uses the same arguments as Terraform and passes them to the `terraform` command.

This was designed to reduce duplication when using Terraform code
and support things like variables, expressions, functions and relative roots in `provider` and `backend` blocks.

This is mainly applicable where people are deploying modules individually instead of from one larger code base run,
because Terraform is slow
(usually because it has to make lots of calls to cloud APIs to determine what changes need to be made).

In that case each module then needs its own backend configuration which is almost the same apart from key file path and is otherwise all duplication, which Terragrunt can source to deduplicate.

Advocates DRY configuration every 10 seconds, which ironically stands for Don't Repeat Yourself.

Someone needs to create a doc tool to DRY out all the Terragrunt documentation references to DRY ;)

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

[HariSekhon/Terraform - terragrunt.hcl](https://github.com/HariSekhon/Terraform/blob/master/terragrunt.hcl)

Then run...

## Plan & Apply

Almost the same commands just swap `terraform` for `terragrunt`:

```shell
terragrunt plan
```

```shell
terragrunt apply
```
