# Ansible

[Official Documentation](https://docs.ansible.com/ansible/latest/getting_started/index.html)

## Inventory

List of hosts to run against, grouped

Example:

[Ansible Inventory Template](https://github.com/HariSekhon/Templates/blob/master/ansible-inventory)

## Ansible Config

Explicitly set in shell or in git repo's [.envrc](envrc.md) to ensure user's random environment variable
`ANSIBLE_CONFIG` doesn't get used:
```shell
export ANSIBLE_CONFIG="./ansible.cfg"
```

Searches for [ansible.cfg](https://docs.ansible.com/ansible/latest/reference_appendices/config.html) in this order:

```shell
$PWD/ansible.cfg

$HOME/.ansible.cfg  # notice this is a dotfile

/etc/ansible/ansible.cfg
```

## Syntax Check Playbook

```shell
ansible-playbook -i inventory_of_hosts.txt playbook.yml --private-key ~/.ssh/id_rsa
```

## Run Playbook

```shell
ansible-playbook -i inventory_of_hosts.txt playbook.yml --private-key ~/.ssh/id_rsa --syntax-check
```

## Parallelism

Ensure `forks` is set in ansible.cfg

Check there is no `serial` set in a playbook that is capping the parallelism of your run.

## GCP

Populate inventory list of hosts from GCP VM list using:

[GCP Compute Inventory Plugin](https://docs.ansible.com/ansible/latest/collections/google/cloud/gcp_compute_inventory.html)

Set up your [GCloud SDK CLI](gcp.md) and authentication first, then export a token for ansible to use:

```shell
export GCP_ACCESS_TOKEN=$(gcloud auth print-access-token)
```
(unfortunately you can't specify `--lifetime 43200` unless using a service account, so you only get 3600 secs = 1 hour)

Better if you can get a service account and download the JSON credentials file and set that instead.

```shell
git clone https://github.com/HariSekhon/DevOps-Bash-tools bash-tools
```
creates service account, credential, downloads the JSON service account credential file, and prints the command to
use it:
```shell
bash-tools/gcp/gcp_ansible_create_credential.sh
```

## Performance

`ansible.builtin.copy` results in small files copying performance problems.

Replace it with `ansible.posix.synchronize`. This can make a huge time difference of around 4-10x in a production code
base where I was doing this for SolrCloud clusters.

It takes the same `src` / `dest` / `owner` / `group` / `mode` parameters, so you should be able to just change this line
across your code base like so:

```shell
perl -pi -e 's/ansible.builtin.copy/ansible.posix.synchronize/' $(git grep -l ansible.builtin.copy)
```
