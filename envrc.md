# `.envrc`

Use this to quickly jump between different environments using script commands and environment variables.

Install [DirEnv](https://direnv.net/) which will prompt you to approve the `.envrc` to auto-execute when you `cd` into a directory.

## Commands

Add the direnv hook to your shell `$HOME/.bashrc` or similar:

```shell
eval "$(direnv hook bash)"
```

`cd` to a dir with a `.envrc` and then run this allow it to execute each time:

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
