# Atlantis

https://www.runatlantis.io/

Terraform pull request automation on [GitHub](github.md) using [GitHub Actions](github-actions.md).

- requires PR to be mergeable so your other PR checks must pass first before Atlantis will run

```shell
atlantis plan # -d path/to/terragrunt/module/directory
```

```shell
atlantis apply
```

## Do Not Merge Pull Requests Early

If you merge a pull request, Atlantis will refuse to operate apply it.

You will then need to revert the PR and raise it again.
