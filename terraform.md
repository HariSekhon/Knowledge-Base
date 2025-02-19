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
  - [Generate Plan JSON](#generate-plan-json)
- [Useful Modules](#useful-modules)
- [Document Your Terraform Modules](#document-your-terraform-modules)
- [Best Practices](#best-practices)
- [Vendor Code](#vendor-code)
- [Terraform Console](#terraform-console)
  - [Convert Terraform `jsonencode()` to literal JSON](#convert-terraform-jsonencode-to-literal-json)
    - [Handling Multi-line `jsonencode()`](#handling-multi-line-jsonencode)
  - [Handling Multi-line `jsonencode()` with multi-line terraform block that depends on newlines](#handling-multi-line-jsonencode-with-multi-line-terraform-block-that-depends-on-newlines)
- [hcl2json](#hcl2json)
- [Troubleshooting](#troubleshooting)
  - [Checksum Mismatch in `.terraform.lock.hcl`](#checksum-mismatch-in-terraformlockhcl)

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

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Terraform&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Terraform)

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
[CI/CD](cicd.md) system.

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

- [tflint](https://github.com/terraform-linters/tflint)
- [tfsec](https://github.com/aquasecurity/tfsec)
- [checkov](https://www.checkov.io/)

### Generate Plan JSON

```shell
terraform init
```

```shell
terraform plan -out tf.plan
```

```shell
terraform show -json tf.plan  > tf.json
```

You can then run linting and security scanning on the resulting JSON file:

```shell
checkov -f tf.json
```

## Useful Modules

- [AWS Modules](https://registry.terraform.io/namespaces/terraform-aws-modules)
  - [hashicorp/aws](https://registry.terraform.io/providers/hashicorp/aws)

## Document Your Terraform Modules

[:octocat: terraform-docs/terraform-docs](https://github.com/terraform-docs/terraform-docs)

```shell
brew install terraform-docs
```

```shell
terraform-docs markdown table --output-file README.md --output-mode inject /path/to/module
```

## Best Practices

<https://www.terraform-best-practices.com/>

## Vendor Code

Lessons learnt the hard way from the real life project.

**Do not accept** vendor code unless it passes **ALL** of the following points:

- it's in the same format as your internal code base eg. Terraform vs Terragrunt
- using standard modules from the [Hashicorp registry](https://registry.terraform.io/)
  eg. [hashicorp/aws](https://registry.terraform.io/providers/hashicorp/aws)
- has passed all Checkov checks and / or any other linting / security tools your use

If you don't enforce good practices on the vendor code base before accepting it,
you'll inherit more problems than you can see and accurately estimate just by reading their code base.

You'll lose tonnes of time:

- migrating from Terraform to Terragunt modules
- migrating from custom modules to official portable modules to match the rest of your code base
- migrating from Terraform embedded Helm to standard ArgoCD deployment using Kustomize or Helm normally
- inheriting problems in the migrations above
- debugging and fixing their code

Even simple things like an S3 bucket will then fail your Checkov PR checks for things like:

- not having KMS encryption, you'll have to go create that, add the dependency and reference it yourself
- public ACLs tripping Checkov, even if the bucket really is supposed to be public
  - this may also blocked at the AWS Control Tower guardrail policy level, such that you cannot use public buckets
  - the workaround I did in one project was to use CloudFront in front of the bucket
- you'll miss minor details while trying to manually migrate the whole code base, eg.
  missing a small `aws_elasticache_cache` vs `aws_elasticache_serverless_cache` resource will leave you
  migrating to the standard AWS elasticache module defaulting to the wrong type and end up with errors like:

```shell
Error: "node_type" is required unless "global_replication_group_id" is set.
```

Leaving you wondering what the `node_type` should be, instead of realizing you're using the wrong module.

If they had used the module in the first place your brain wouldn't be fried from migrating all their modules and then
missing a detail like this.

## Terraform Console

Useful for testing.

```shell
terraform console
```

Unfortunately it's a line-based REPL so you can't paste multi-line inputs, see next examples for how to work around
this.

### Convert Terraform `jsonencode()` to literal JSON

This is sometimes needed when porting a plain terraform AWS `jsonencode()` document into an embedded JSON policy.

```shell
echo 'jsonencode({ name = "example", values = [1, 2, 3] })' | terraform console
```

```text
"{\"name\":\"example\",\"values\":[1,2,3]}"
```

However, the above is not literal, so pipe it through `jq -r` to remove the quoting:

```shell
echo 'jsonencode({ name = "example", values = [1, 2, 3] })' | terraform console | jq -r
```

```json
{"name":"example","values":[1,2,3]}
```

#### Handling Multi-line `jsonencode()`

Unfortunately since `terraform console` is a line-based REPL you cannot do this:

```shell
terraform console <<EOF | jq -r
jsonencode(
  {
    name = "example",
    values = [1, 2, 3]
  }
)
EOF
```

```text
│ Error: Missing expression
│
│   on <console-input> line 1:
│   (source code not available)
│
│ Expected the start of an expression, but found the end of the file.
```

So first flatten it by removing newlines using `tr` or similar command:

```shell
tr -d '\n' <<EOF | terraform console | jq -r
jsonencode(
  {
    name = "example",
    values = [1, 2, 3]
  }
)
EOF
```

```json
{"name":"example","values":[1,2,3]}
```

Pipe it through `jq` once more if you want a multi-line pretty-printed JSON result:

```shell
tr -d '\n' | terraform console | jq -r | jq
```

eg.

```shell
tr -d '\n' <<EOF | terraform console | jq -r | jq
jsonencode(
  {
    name = "example",
    values = [1, 2, 3]
  }
)
EOF
```

```json
{
  "name": "example",
  "values": [
    1,
    2,
    3
  ]
}
```

### Handling Multi-line `jsonencode()` with multi-line terraform block that depends on newlines

```text
locals {

  result = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:BatchGetItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchWriteItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ]
        Effect = "Allow"
        Resource = [
          local.dynamodb_project_sources_table_arn,
          local.dynamodb_project_destinations_table_arn,
          local.dynamodb_project_subdomain_mapping_table_arn
        ]
      }
    ]
  })

}
```

```text
│ Error: Missing attribute separator
│
│   on <console-input> line 1:
│   (source code not available)
│
│ Expected a newline or comma to mark the beginning of the next attribute.
```

Tried dumping it to a `/tmp` file and then have the Terraform Console read the file using a single line function:

```shell
cat > /tmp/terraform.jsonencode.txt
```

```shell
echo 'file("/tmp/terraform.jsonencode.txt")' | terraform console | jq -r | jq
```

but this outputs a literal instead of interpreting it as code, output looks like this:

```text
<<EOT
locals {

  result = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:BatchGetItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchWriteItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ]
        Effect = "Allow"
        Resource = [
          local.dynamodb_project_sources_table_arn,
          local.dynamodb_project_destinations_table_arn,
          local.dynamodb_project_subdomain_mapping_table_arn
        ]
      }
    ]
  })

}

EOT
```

So you can get the code into Terraform Console but not eval it. Might have to use actual Terraform apply with `output`
instead, which is problematic when trying to port some vendor's code bundle that doesn't actually execute in local
environment.

Not solved yet.

## hcl2json

[:octocat: tmccombs/hcl2json](https://github.com/tmccombs/hcl2json)

Convert HCL to JSON to make it easier to work with in other languages.

```shell
brew install hcl2json
```

```shell
hcl2json "$file"
```

outputs the JSON equivalent.

## Troubleshooting

### Checksum Mismatch in `.terraform.lock.hcl`

If you get an error like this when running Terraform or [Terragrunt](terragrunt.md):

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
terraform providers lock -platform=windows_amd64 -platform=darwin_amd64 -platform=linux_amd64
```

and then commit the updated `.terraform.lock.hcl` file:

```shell
git add .terraform.lock.hcl
git commit -m "updated .terraform.lock.hcl file with checksums for all 3 platform architectures" .terraform.lock.hcl
```
