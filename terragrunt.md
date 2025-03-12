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
    - [No Auto-Approve](#no-auto-approve)
  - [Auto Format](#auto-format)
    - [Useful Options](#useful-options)
  - [CI/CD](#cicd)
- [Terraform Lock Files](#terraform-lock-files)
- [Terragrunt Console](#terragrunt-console)
- [Dependencies](#dependencies)
  - [Cross Referencing](#cross-referencing)
  - [Check Module Outputs](#check-module-outputs)
  - [Dependency Graph](#dependency-graph)
  - [Graph Run](#graph-run)
- [Terragrunt Scaffold](#terragrunt-scaffold)
- [Linting and Security Scanning](#linting-and-security-scanning)
- [tgswitch](#tgswitch)
- [Best Practices](#best-practices)
  - [Caching](#caching)
  - [Inherit Variables for AWS Account ID, Region](#inherit-variables-for-aws-account-id-region)
  - [Find Dependency Paths](#find-dependency-paths)
- [Vendor Code](#vendor-code)
- [Terragrunt Debugging](#terragrunt-debugging)
  - [Terragrunt Dump JSON](#terragrunt-dump-json)
- [Terragrunt Troubleshooting](#terragrunt-troubleshooting)
  - [Clear Terragrunt Caches](#clear-terragrunt-caches)
  - [ERRO[0000] fork/exec /Users/hari/.tfenv/bin: no such file or directory](#erro0000-forkexec-usersharitfenvbin-no-such-file-or-directory)
  - [Error: Get "http://localhost/api/v1/namespaces/kube-system/configmaps/aws-auth": dial tcp [::1]:80: connect: connection refused](#error-get-httplocalhostapiv1namespaceskube-systemconfigmapsaws-auth-dial-tcp-180-connect-connection-refused)
  - [Checksum Mismatch in `.terraform.lock.hcl`](#checksum-mismatch-in-terraformlockhcl)

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

Use this in [CI/CD](cicd.md) to force people to properly maintain their code changes.

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

## Terragrunt Console

Useful for testing.

```shell
terragrunt console
```

Terragrunt functions like `get_parent_terragrunt_dir()` don't work in the REPL unfortunately.

Rest is same as [Terraform Console](terraform.md#terraform-console).

## Dependencies

### Cross Referencing

Since Terragrunt splits things into lots of modules, you often want to cross reference each other dynamically like this:

```hcl
dependency "s3" {
  config_path = "${find_in_parent_folders("s3")}/my-config"
}

...

s3_bucket_name = dependency.s3.outputs.s3_bucket_id
s3_bucket_arn = dependency.s3.outputs.s3_bucket_arn
```

Don't forget the `.outputs.` part of the dependency reference to get its output variables.

### Check Module Outputs

To check the outputs of the dependency module:

```shell
cd s3/some-bucket-module
```

```shell
terragrunt outputs
```

output will look something like this:

```text
s3_bucket_arn = "arn:aws:s3:::my-config"
s3_bucket_bucket_domain_name = "my-config.s3.amazonaws.com"
s3_bucket_bucket_regional_domain_name = "my-config.s3.eu-west-1.amazonaws.com"
s3_bucket_hosted_zone_id = "A1BCDEFA23BCDE"
s3_bucket_id = "my-config"
s3_bucket_region = "eu-west-1"
```

### Dependency Graph

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

## Linting and Security Scanning

You can then run checkov on the resulting json file:

```shell
checkov -f terragrunt_rendered.json --skip-check $(cat /home/atlantis/.checkov-skip.conf|tr '\\n' ',') --compact --quiet
```

## tgswitch

Easily switch between Terragrunt versions.

See [tgswitch](tgswitch.md)

More recently updated than [tgenv](https://github.com/cunymatthieu/tgenv).

## Best Practices

<https://www.terraform-best-practices.com/>

### Caching

<https://terragrunt.gruntwork.io/docs/features/provider-cache-server/>

<https://github.com/gruntwork-io/terragrunt/issues/2920>

Because [Terraform Plugin Caching](terraform.md#caching) is not thread-safe.

To use it, just:

```shell
export TG_PROVIDER_CACHE=1
```

Stores plugins in:

```text
$HOME/.cache/terragrunt/providers
```

or on Mac:

```text
$HOME/Library/Caches/terragrunt/providers
```

You can set `TG_PROVIDER_CACHE_DIR` to override it (eg. on [Atlantis](atlantis.md) to the larger
`/atlantis-data` partition):

```shell
export TG_PROVIDER_CACHE_DIR="/atlantis-data/plugin-cache"
```

Don't forget to create that dir:

```shell
mkdir -p -v /atlantis-data/plugin-cache
chown atlantis:atlantis /atlantis-data/plugin-cache
```

To cache from registries other than `registry.terraform.io` and `registry.opentofu.org`
eg. if you have your own private registry:

```shell
export TG_PROVIDER_CACHE_REGISTRY_NAMES="example1.com,example2.com"
```

To see how much space you are wasting on duplicate provider downloads for Terragrunt modules,
you can run this script from [DevOps-Bash-tools](devops-bash-tools.md):

```shell
terraform_provider_count_sizes.sh
```

Output on my Mac:

```text
30  597M  hashicorp/aws/5.80.0/darwin_arm64/terraform-provider-aws_v5.80.0_x5
7   637M  hashicorp/aws/5.90.1/darwin_arm64/terraform-provider-aws_v5.90.1_x5
4   637M  hashicorp/aws/5.90.0/darwin_arm64/terraform-provider-aws_v5.90.0_x5
3   599M  hashicorp/aws/5.81.0/darwin_arm64/terraform-provider-aws_v5.81.0_x5
2   593M  hashicorp/aws/5.79.0/darwin_arm64/terraform-provider-aws_v5.79.0_x5
    ...
```

Output on an Atlantis server pod after deleting all data cache to fix out of space errors and
then a single PR run:

```text
14  654M  hashicorp/aws/5.90.1/linux_amd64/terraform-provider-aws_v5.90.1_x5
13  14M   hashicorp/external/2.3.4/linux_amd64/terraform-provider-external_v2.3.4_x5
13  14M   hashicorp/local/2.5.2/linux_amd64/terraform-provider-local_v2.5.2_x5
13  14M   hashicorp/null/3.2.3/linux_amd64/terraform-provider-null_v3.2.3_x5
3   346M  hashicorp/aws/4.67.0/linux_amd64/terraform-provider-aws_v4.67.0_x5
3   621M  hashicorp/aws/5.80.0/linux_amd64/terraform-provider-aws_v5.80.0_x5
3   653M  hashicorp/aws/5.90.0/linux_amd64/terraform-provider-aws_v5.90.0_x5
3   14M   hashicorp/random/3.6.3/linux_amd64/terraform-provider-random_v3.6.3_x5
1   627M  hashicorp/aws/5.82.2/linux_amd64/terraform-provider-aws_v5.82.2_x5
1   630M  hashicorp/aws/5.84.0/linux_amd64/terraform-provider-aws_v5.84.0_x5
```

### Inherit Variables for AWS Account ID, Region

Example code to portably follow the AWS Account ID and region of the codebase section:

```hcl
locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  aws_account_id   = local.environment_vars.locals.aws_account_id
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region       = local.region_vars.locals.aws_region
}
```

and used further down like this:

```hcl
"arn:aws:iam::${local.aws_account_id}:..."
```

```hcl
"${local.aws_region}.elasticache-snapshot.amazonaws.com"
```

### Find Dependency Paths

Instead of this:

```hcl
dependency "s3" {
  config_path = "../../s3/mybucket"
}
```

Do this to maintain directory path depth structure portability:

```hcl
dependency "s3" {
  config_path = "${find_in_parent_folder("s3")}/mybucket"
}
```

For example if you have a module that is 3 `../../../` levels deep
due to putting some external vendor specific modules under a subdirectory, the code will still work either way.

## Vendor Code

Read [Terraform - Vendor Code](terraform.md#vendor-code) section.

## Terragrunt Debugging

Use `--terragrunt-log-level=debug`.

Use `--terragrunt-debug` or `export TERRAGRUNT_DEBUG=1` to create a `$PWD/terragrunt-debug.tfvars.json` file to be able to run `terraform` with the
same inputs without terragrunt.

```shell
terragrunt apply --terragrunt-log-level=debug --terragrunt-debug
```

In newer versions of Terragrunt use `--inputs-debug` instead of `--terragrunt-debug`
(it still creates `terragrunt-debug.tfvars.json`):

```shell
terragrunt apply --inputs-debug
```

`terragrunt-debug.tfvars.json` allows you to inspect the variables that Terragrunt is generating and passing to the Terraform code.

See [this doc page](https://terragrunt.gruntwork.io/docs/features/debugging/) for more details and OpenTelemetry
integration.

### Terragrunt Dump JSON

```shell
terragrunt plan -out=plan.tfplan
```

```shell
terraform show -json plan.tfplan > plan.json
```

OR

```shell
terragrunt run-all render-json
```

Find the JSON output in:

```text
terragrunt_rendered.json
```

## Terragrunt Troubleshooting

### Clear Terragrunt Caches

To recover space or just clear cache

```shell
find . -name '.terragrunt-cache' -exec rm -rf {} \;
```

### ERRO[0000] fork/exec /Users/hari/.tfenv/bin: no such file or directory

If you get an error like this when running Terragrunt:

```text
ERRO[0000] fork/exec /Users/hari/.tfenv/bin: no such file or directory
ERRO[0000] Unable to determine underlying exit code, so Terragrunt will exit with error code 1
```

then make sure to unset `TERRAGRUNT_TFPATH` or direct it to your correct terraform binary (rather than directory as
in the case above).

### Error: Get "http://localhost/api/v1/namespaces/kube-system/configmaps/aws-auth": dial tcp [::1]:80: connect: connection refused

```text
╷
│ Error: Get "http://localhost/api/v1/namespaces/kube-system/configmaps/aws-auth": dial tcp [::1]:80: connect: connection refused
│
│   with kubernetes_config_map.aws_auth[0],
│   on aws_auth.tf line 63, in resource "kubernetes_config_map" "aws_auth":
│   63: resource "kubernetes_config_map" "aws_auth" {
│
╵
```

Workaround:

```shell
terragrunt state rm 'kubernetes_config_map.aws_auth[0]'
```

Then run:

```shell
terragrunt apply
```

It'll apply the rest and fail on the aws_auth map, but you can re-import it:

```shell
terragrunt import 'kubernetes_config_map.aws_auth[0]' kube-system/aws-auth
```

### Checksum Mismatch in `.terraform.lock.hcl`

If you get an error like this when running [Terraform](terraform.md) or Terragrunt:

<!--

```text
Error: registry.terraform.io/hashicorp/aws: the cached package for registry.terraform.io/hashicorp/aws 4.67.0 (in .terraform/providers) does not match any of the checksums recorded in the dependency lock file
```

or

-->

```text
Error: Required plugins are not installed

The installed provider plugins are not consistent with the packages selected
in the dependency lock file:
  - registry.terraform.io/hashicorp/aws: the cached package for registry.terraform.io/hashicorp/aws 5.80.0 (in .terraform/providers) does not match any of the checksums recorded in the dependency lock file
```

This is caused
by the `.terraform.lock.hcl` being generated and committed from a machine of a different architecture since
default Terraform only includes the checksums for the local architecture.

This surfaces in [Atlantis](atlantis.md) or other [CI/CD](cicd.md) systems
because developers are often using [Mac](mac.md) (or heavy forbid [Windows](windows.md)) but the CI/CD systems like
Atlantis are invariably running on [Linux](linux.md).

Run this command to update the `.terraform.lock.hcl` file with the checksum for all 3 architectures:

```shell
terragrunt providers lock -platform=windows_amd64 -platform=darwin_amd64 -platform=linux_amd64
```

and then commit the updated `.terraform.lock.hcl` file:

```shell
git add .terraform.lock.hcl
git commit -m "updated .terraform.lock.hcl file with checksums for all 3 platform architectures" .terraform.lock.hcl
```
