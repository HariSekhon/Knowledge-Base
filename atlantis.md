# Atlantis

https://www.runatlantis.io/

Terraform pull request automation on [GitHub](github.md) using [GitHub Actions](github-actions.md).

- interaction is through pull request comments
- Atlantis comments on the PR with command prompts of what to type in comments
  (and even corrects you if you comment `terraform` instead of `atlantis` command)
- runs the [Terraform](terraform.md) / [Terragrunt](terragrunt.md) plan automatically upon creation / commit changes to
  the PR including GitHub update from trunk
- prints the plan output in PR comment
- comment `atlantis apply` to respond for Atlantis to apply the changes
- requires PR to be mergeable before it will honor `atlantis apply` comments
  - so your other PR checks must pass first
- [Terragrunt](terragrunt.md) becomes more useful in this context to modularize code base to reduce blast radius of
  changes and have Atlantis do shorter plan and apply runs

<!-- INDEX_START -->
<!-- INDEX_END -->

## Usage

```shell
atlantis plan # -d path/to/terragrunt/module/directory
```

```shell
atlantis apply
```

## Do Not Merge Pull Requests Early

If you merge a pull request, Atlantis will refuse to operate apply it.

You will then need to revert the PR and raise it again.
