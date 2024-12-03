# Terragrunt

<https://terragrunt.gruntwork.io/>

Thin CLI wrapper around [Terraform](terraform.md) which adds lots of sourcing and templating capabilities.

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Install](#install)
- [Terragrunt Template](#terragrunt-template)
- [Terragrunt Usage](#terragrunt-usage)
  - [Plan & Apply](#plan--apply)
  - [Validate Inputs](#validate-inputs)
  - [Run-All](#run-all)
  - [Auto Format](#auto-format)
  - [CI/CD](#cicd)
- [Terraform Lock Files](#terraform-lock-files)
- [Dependency Graph](#dependency-graph)
  - [Graph Run](#graph-run)
- [Terragrunt Scaffold](#terragrunt-scaffold)
- [Terragrunt Debugging](#terragrunt-debugging)
- [tgswitch](#tgswitch)
- [Terragrunt Troubleshooting](#terragrunt-troubleshooting)

<!-- INDEX_END -->

## Key Points

Uses same arguments which are passed to the `terraform` command.

Designed to reduce duplication when using Terraform code by adding support for variables, expressions, functions and
relative roots in `provider` and `backend` blocks.

Enables running Terraform modules individually to save run time.

Essentially turns shared modules (eg. from a registry) into root modules like you'd normally `terraform init` to
deploy the infrastructure.

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

## Terragrunt Usage

Passes all args straight to the `terraform` command except for `--version` and `--terragrunt-*`.

- [CLI Reference](https://terragrunt.gruntwork.io/docs/reference/cli-options/)
- [Functions Reference](https://terragrunt.gruntwork.io/docs/reference/built-in-functions/)

### Plan & Apply

Almost the same commands as regular terraform, just replace `terraform` with `terragrunt`:

[Auto-init](https://terragrunt.gruntwork.io/docs/features/auto-init/) means you don't need to run `terragrunt init`,
it is automatically called during `terragrunt plan` if it detects it's not been initialized.

```shell
terragrunt plan
```

```shell
terragrunt apply
```

### Validate Inputs

<https://terragrunt.gruntwork.io/docs/reference/cli-options/#validate-inputs>

Finds:

1. required inputs for a module that are missing
1. unused inputs being passed to a terraform module for which it is not expecting.

Strict mode exits with error instead of just printing a warning:

```shell
terragrunt validate-inputs --terragrunt-strict-validate
```

Use this in [CI/CD](ci-cd.md) to force people to
properly maintain their code changes.

### Run-All

Recursively looks for `terragrunt.hcl` in all subdirectories and concurrently runs them (run these from the root
directory of your terragrunt'd terraform repo).

**WARNING: adds implicit `-auto-approve` and doesn't prompt (don't use it with `destroy` argument!)**

```shell
terragrunt run-all validate
```

```shell
terragrunt run-all plan  # --terragrunt-out-dir /tmp/tfplan
```

```shell
terragrunt run-all apply  # --terragrunt-out-dir /tmp/tfplan
```

See also the [Graph Run](#graph-run) command further down.

#### No Auto-Approve

You can add `--terragrunt-no-auto-approve` / `TERRAGRUNT_NO_AUTO_APPROVE=true` to prevent this, but due to
interactive prompts will implicitly also add `--terragrunt-parallelism 1`.

### Auto Format

Recursively finds `.hcl` files and formats them:

```shell
terragrunt hclfmt
```

#### Useful Options

- `--terragrunt-parallelism 4` - avoid hitting rate limiting with Cloud providers APIs
- `--terragrunt-out-dir /tmp/tfplan` - save the plan and apply it exactly. For `run-all` the `tfplan.tfplan` files
  are saved in subdirectories of the same naming structure
- `--terragrunt-json-out-dir` - save the plan in JSON format. Can be used together with the above switch to save
  both formats, one for text investigation and the other for applying

### CI/CD

For CI/CD, set environment variable:

```shell
TERRAGRUNT_NON_INTERACTIVE=true
```

## Terraform Lock Files

The `.terraform.lock.hcl` is generated in the same directory as your `terragrunt.hcl` file.

When Terragrunt downloads remote configurations into a sub-directory like `.terragrunt-cache/<url>/<remote_code>`
it copies the top level `.terraform.lock.hcl` file into the sub-directory before running Terraform and back to `$PWD`
after the run to capture the changes.

Commit your lock file as per Terraform standard to ensure your colleagues get the same provider versions.

## Dependency Graph

Recurse sub-directories and generate a dependency graph based on the `dependency` and `dependencies` blocks:

```shell
terragrunt graph-dependencies | dot -Tsvg > graph.svg
```

On [Mac](mac.md) you can open the graph from the command line too:

```shell
open graph.svg
```

![](https://terragrunt.gruntwork.io/assets/img/collections/documentation/graph.png)

This is the order of "depends on" - Terragrunt will run the modules from the bottom up.

### Graph Run

You can execute a command against all module dependencies of the current module directory.

**Beware although not documented, this like assumes `-auto-approve` so make sure to plan and check first:**

```shell
terragrunt graph plan
```

```shell
terragrunt graph apply
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
[this doc page](https://terragrunt.gruntwork.io/docs/features/scaffold/).

## Terragrunt Debugging

Use `--terragrunt-log-level=debug`.

Use `--terragrunt-debug` or `export TERRAGRUNT_DEBUG=1` to create a `$PWD/terragrunt-debug.tfvars.json` file to be able to run `terraform` with the
same inputs without terragrunt.

```shell
terragrunt apply --terragrunt-log-level=debug --terragrunt-debug
```

See [this doc page](https://terragrunt.gruntwork.io/docs/features/debugging/) for more details and OpenTelemetry
integration.

## tgswitch

Easily switch between Terragrunt versions.

See [tgswitch](tgswitch.md)

More recently updated than [tgenv](https://github.com/cunymatthieu/tgenv).

## Terragrunt Troubleshooting

If you get an error like this when running Terragrunt:

```text
ERRO[0000] fork/exec /Users/hari/.tfenv/bin: no such file or directory
ERRO[0000] Unable to determine underlying exit code, so Terragrunt will exit with error code 1
```

then make sure to unset `TERRAGRUNT_TFPATH` or direct it to your correct terraform binary (rather than directory as
in the case above).
