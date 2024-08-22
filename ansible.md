# Ansible

[Official Documentation](https://docs.ansible.com/ansible/latest/getting_started/index.html)

<!-- INDEX_START -->

- [Inventory](#inventory)
- [Ansible Config](#ansible-config)
- [Syntax Check Playbook](#syntax-check-playbook)
- [Run Playbook](#run-playbook)
- [Parallelism](#parallelism)
- [GCP](#gcp)
  - [IAP Performance](#iap-performance)
- [Performance](#performance)

<!-- INDEX_END -->

## Inventory

List of hosts to run against, grouped

Example:

[Ansible Inventory Template](https://github.com/HariSekhon/Templates/blob/master/ansible-inventory)

## Ansible Config

Explicitly set in shell or in git repo's [.envrc](direnv.md) to ensure user's random environment variable
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

### IAP Performance

IAP performance is terrible. Much faster to use direct SSH which often requires populating your `/etc/hosts` with
the VM to IP mappings and preloading the SSH in `~/.ssh/known_hosts`.

See the `gce_host_ip.sh` and `gce_ssh_keyscan.sh` scripts in the
[DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools#gcp---google-cloud-platform) repo.

## Performance

`ansible.builtin.copy` results in small files copying performance problems.

Replace it with `ansible.posix.synchronize`. This can make a huge time difference of around 4-10x in a production code
base where I was doing this for SolrCloud clusters.

```shell
perl -pi -e 's/ansible.builtin.copy/ansible.posix.synchronize/' $(git grep -l ansible.builtin.copy)
```

`ansible.posix.synchronize` takes the same `src` / `dest` as `ansible.builtin.copy` but the `owner` /
`group` / `mode` parameters are different and need to be commented out to avoid these sorts of errors:

```shell
fatal: [myhost]: FAILED! => {"changed": false, "msg": "argument 'owner' is of type <class 'str'> and we were unable to convert to bool: The value 'solr' is not a valid boolean.  Valid booleans include: 'y', 1, 0, 'f', 'false', '0', '1', 'n', 'off', 'true', 'on', 't', 'no', 'yes'"}
```

**Partial port from private Knowledge Base page 2014+**
