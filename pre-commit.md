# Pre-Commit

Run simple sanity checks and linting before allowing to Git commit.

Also used in [CI/CD](ci-cd.md) workflows.

See also the [DevOps-Bash-tools](devops-bash-tools.md) repo's
[checks/](https://github.com/HariSekhon/DevOps-Bash-tools/tree/master/checks)
directory full of generic check scripts.

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

All my [direnv](direnv.md) `.envrc` files detect if `pre-commit` is installed and automatically
install the [Git](git.md) hooks as soon as you `cd` in to a git repo.

### Config

Create a `.pre-commit-config.yaml` at the root of your Git repo.

Here is a template to start from:

[HariSekhon/Templates - .pre-commit-config.yaml](https://github.com/HariSekhon/Templates/blob/master/.pre-commit-config.yaml)

```shell
wget https://github.com/HariSekhon/Templates/blob/master/.pre-commit-config.yaml
```

### Run

Run against all files when adding checks to see the current state of your repo contents:

```shell
pre-commit run --all-files
```

### Update Config Hooks

Update all config hooks to the latest release tag on the default branch:

```shell
pre-commit autoupdate
```

Note: this will update hashref fixed to normal versioned tags which are slightly vulnerable to those repos not
getting hacked and their tags replaced.
GitHub security practices recommend fixing to hashrefs
