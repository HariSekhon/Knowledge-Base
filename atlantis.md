# Atlantis

<https://www.runatlantis.io/>

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

- [Usage](#usage)
- [Do Not Merge Pull Requests Early](#do-not-merge-pull-requests-early)
- [Back up Atlantis.db from StatefulSet pod](#back-up-atlantisdb-from-statefulset-pod)
- [Troubleshooting](#troubleshooting)
  - [Stale Error not picking up Terraform Module fix](#stale-error-not-picking-up-terraform-module-fix)

<!-- INDEX_END -->

## Usage

```shell
atlantis plan # -d path/to/terragrunt/module/directory
```

```shell
atlantis apply
```

## Do Not Merge Pull Requests Early

If you merge a pull request, Atlantis will refuse to operate and apply it.

You will then need to revert the PR and raise it again.

## Back up Atlantis.db from StatefulSet pod

Take a copy to your local machine:

```shell
kubectl cp atlantis/atlantis-0:/atlantis-data/atlantis.db atlantis.db -c atlantis
```

## Troubleshooting

### Stale Error not picking up Terraform Module fix

You'll need to clear the state from the Atlantis kubernetes pod.

Exec into the pod:

```shell
kubectl exec -ti -n atlantis atlantis-0 -c atlantis -- /bin/bash
```

Go to the data directory:

```shell
cd /atlantis-data/
```

`cd` into the `<owner>/<repo>` GitHub subdirectory.

Delete the numbered subdirectory matching the GitHub pull request number.
