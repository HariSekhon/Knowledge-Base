# Terragrunt

https://terragrunt.gruntwork.io/

A thin wrapper around [Terraform](terraform.md) which adds lots of sourcing and templating capabilities.

Uses the same arguments as Terraform and passes them to the `terraform` command.

This was designed to reduce duplication when using Terraform code
and support things like variables, expressions, functions and relative roots in `provider` and `backend` blocks.

Especially useful or running Terraform modules individually to save run time.

In CI/CD pipelines you often only want to deploy the modules which have changed individually instead of the entire
terraform code base, because Terraform is slow (usually because it has to make lots of calls to cloud APIs to determine
what changes need to be made).

In that case each module then needs its own backend configuration which is almost the same apart from key file path and
is otherwise all duplication, which Terragrunt can source to deduplicate.

Advocates DRY configuration every 10 seconds, which ironically stands for Don't Repeat Yourself.

Someone needs to create a doc tool to DRY out all the Terragrunt documentation references to DRY ;)

## Install

[Install doc](https://terragrunt.gruntwork.io/docs/getting-started/install/)

Quicker if you've got [DevOps-Bash-tools](devops-bash-tools.md) - finds and installs the latest version:

```shell
install_terragrunt.sh
```

Install shell autocomplete:

```shell
terragrunt --install-autocomplete
```

## Terragrunt Template

Heavily commented with advanced knowledge.

Edit to suit your needs:

[HariSekhon/Terraform - terragrunt.hcl](https://github.com/HariSekhon/Terraform/blob/master/terragrunt.hcl)

Then run...

## Terragrunt Plan & Apply

Almost the same commands as regular terraform, just replace `terraform` with `terragrunt`:

[Auto-init](https://terragrunt.gruntwork.io/docs/features/auto-init/) means you don't need to run `terragrunt init`,
it is automatically called during `terragrunt plan` if it detects it's not been initialized.

```shell
terragrunt plan
```

```shell
terragrunt apply
```

Recursively looks for `terragrunt.hcl` in all subdirectories and concurrently runs them to run all modules from a
root directory:

```shell
terragrunt run-all apply
```

## Terragrunt Scaffold

Terragrunt contains built-in templating.

This command will find the latest release tag of the given module and generate the
[boilerplate](https://github.com/gruntwork-io/boilerplate) `terragrunt.hcl` for you including the tagged `source` url
and the `input` variables for the given module (WARNING: the scaffold command overwrites any `terragrunt.hcl` file
in the local directory without prompting):

```shell
terragrunt scaffold github.com/gruntwork-io/terragrunt-infrastructure-modules-example//modules/mysql
```

Can set ref version and SSH git source via variables, see
[the doc](https://terragrunt.gruntwork.io/docs/features/scaffold/).
