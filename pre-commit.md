# Pre-Commit

Run simple sanity checks and linting before allowing to Git commit.

Also used in [CI/CD](cicd.md) workflows.

See also the [DevOps-Bash-tools](devops-bash-tools.md) repo's
[checks/](https://github.com/HariSekhon/DevOps-Bash-tools/tree/master/checks)
directory full of generic check scripts.

<!-- INDEX_START -->

- [Install](#install)
  - [Install Git Hooks](#install-git-hooks)
  - [Config](#config)
- [Run](#run)
- [Run on changed files in branch](#run-on-changed-files-in-branch)
- [Update Config Hooks](#update-config-hooks)

<!-- INDEX_END -->

## Install

On Mac:

```shell
brew install pre-commit
```

or using Python pip:

```shell
pip install pre-commit
```

### Install Git Hooks

Have `pre-commit` automatically run for all [Git](git.md) commits.

In your git repo checkout:

```shell
pre-commit install
```

which creates a script `.git/hooks/pre-commit`.

All my [direnv](direnv.md) `.envrc` files automatically install `pre-commit` and the pre-commit hooks to the local git
repo checkout as soon as you `cd` in to any git checkout directory.

### Config

Create a `.pre-commit-config.yaml` at the root of your Git repo.

Here is a template to start from:

[HariSekhon/Templates - .pre-commit-config.yaml](https://github.com/HariSekhon/Templates/blob/master/.pre-commit-config.yaml)

```shell
wget https://github.com/HariSekhon/Templates/blob/master/.pre-commit-config.yaml
```

## Run

Run against all files when adding checks to see the current state of your repo contents:

```shell
pre-commit run --all-files
```

## Run on changed files in branch

Reproduce what a pull request check is doing locally to debug and fix your PRs to pass,
using this script from the [DevOps-Bash-tools](devops-bash-tools.md) repo:

```shell
precommit_run_changed_files.sh
```

## Update Config Hooks

Update all config hooks to the latest release tag on the default branch:

```shell
pre-commit autoupdate
```

Note: this will update hashref fixed to normal versioned tags which are slightly vulnerable to those repos not
getting hacked and their tags replaced.
GitHub security practices recommend fixing to hashrefs
