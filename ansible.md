# Ansible

https://docs.ansible.com/ansible/latest/getting_started/index.html

## Inventory

List of hosts to run against, grouped

Example:

https://github.com/HariSekhon/Templates/blob/master/ansible-inventory

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

In your local work repo, override the ansible.cfg to use the local config (put this in [.envrc](envrc.md))
```shell
export ANSIBLE_CONFIG="ansible.cfg"
```

## GCP

Populate inventory list of hosts from GCP VM list using:

https://docs.ansible.com/ansible/latest/collections/google/cloud/gcp_compute_inventory.html

```shell
export GCP_ACCESS_TOKEN=$(gcloud auth print-access-token)
```
(unfortunately you can't specify `--lifetime 43200` unless using a service account, so you only get 3600 secs = 1 hour)

## Performance

`ansible.builtin.copy` results in small files copying performance problems.

Replace it with `ansible.posix.synchronize`. This can make a huge time difference of around 4-10x in a production code
base where I was doing this for SolrCloud clusters.

It takes the same `src` / `dest` / `owner` / `group` / `mode` parameters, so you should be able to just change this line
across your code base like so:

```shell
perl -pi -e 's/ansible.builtin.copy/ansible.posix.synchronize/' $(git grep -l ansible.builtin.copy)
```
