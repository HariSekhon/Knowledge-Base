# `.envrc` / DirEnv

[DirEnv](https://direnv.net/) reads `.envrc` files and auto-loads useful environment variables upon switching directories
that allow you to quickly switch between AWS profiles, EKS clusters, Terraform & Terragrunt versions or any number of
other software versions or profiles.

## Install DirEnv

On Mac just:

```shell
brew install direnv
```

This is automatically installed as part of core software by `make` in [DevOps-Bash-tools](devops-bash-tools.md) repo.

For other platforms and more install details read:

<https://direnv.net/docs/installation.html>

## Commands

### Enable DirEnv in your shell

Add the direnv hook to your shell `$HOME/.bashrc` or similar:

```shell
eval "$(direnv hook bash)"
```

### Approve `.envrc` files

When you switch to a directory containing an `.envrc` file for the first time it will print a warning
that you need to approve the `.envrc` file.

`cd` to a dir with a `.envrc` and then run this allow it to automatically load this `.envrc` each time in future:

```shell
direnv allow
```

To edit, will auto-approve when you save and exit:
```shell
direnv edit
```

## Advanced Examples

### General - Ansible, Cloudflare, Docker, GitHub, Terraform

[.envrc](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/.envrc)

### AWS

[.envrc-aws](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/.envrc-aws)

### GCP

[.envrc-gcp](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/.envrc-gcp)

### Kubernetes

[.envrc-kubernetes](https://github.com/HariSekhon/Kubernetes-configs/blob/master/.envrc) -
[Kubernetes-configs](https://github.com/HariSekhon/Kubernetes-configs) repo

or

[.envrc-kubernetes](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/.envrc-kubernetes) -
[DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools) repo

### Terraform

[.envrc-terraform](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/.envrc-terraform)
