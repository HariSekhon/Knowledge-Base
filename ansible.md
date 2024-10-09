# Ansible

[Official Documentation](https://docs.ansible.com/ansible/latest/getting_started/index.html)

Ansible is a popular imperative configuration management framework written in Python.

<!-- INDEX_START -->

- [Inventory](#inventory)
- [Ansible Config](#ansible-config)
- [Syntax Check Playbook](#syntax-check-playbook)
- [Run Playbook](#run-playbook)
- [Parallelism](#parallelism)
- [GCP](#gcp)
  - [IAP Performance](#iap-performance)
- [Performance](#performance)
- [Troubleshooting](#troubleshooting)
  - [Broken Ansible installation](#broken-ansible-installation)

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

## Troubleshooting

### Broken Ansible installations

[Python](python.md) environment variability sucks - they're a waste of time everywhere you go.

This is why Google moved to [Golang](golang.md).

### Quick workaround, just install a user local version

```shell
pip3 install --user ansible
```

```shell
~/.local/bin/ansible --version
```

Set `~/.local/bin` to be earlier in your `$PATH` in your `$HOME/.bashrc`.

#### ModuleNotFoundError: No module named 'ansible'

This could be a lot of things.

```shell
$ ansible --help
Traceback (most recent call last):
  File "/usr/local/bin/ansible", line 34, in <module>
    from ansible import context
ModuleNotFoundError: No module named 'ansible'
```

#### [Errno 13] Permission denied: '/usr/lib/python2.7/site-packages/...'

```shell
$ /usr/bin/ansible --version
ERROR! Unexpected Exception, this is probably a bug: [Errno 13] Permission denied: '/usr/lib/python2.7/site-packages/urllib3-1.26.18.dist-info'
the full traceback was:

Traceback (most recent call last):
File "/usr/bin/ansible", line 92, in <module>
mycli = getattr(__import__("ansible.cli.%s" % sub, fromlist=[myclass]), myclass)
File "/usr/lib/python2.7/site-packages/ansible/cli/__init__.py", line 22, in <module>
from ansible.inventory.manager import InventoryManager
File "/usr/lib/python2.7/site-packages/ansible/inventory/manager.py", line 38, in <module>
from ansible.plugins.loader import inventory_loader
File "/usr/lib/python2.7/site-packages/ansible/plugins/loader.py", line 23, in <module>
from ansible.parsing.utils.yaml import from_yaml
File "/usr/lib/python2.7/site-packages/ansible/parsing/utils/yaml.py", line 17, in <module>
from ansible.parsing.yaml.loader import AnsibleLoader
File "/usr/lib/python2.7/site-packages/ansible/parsing/yaml/loader.py", line 30, in <module>
from ansible.parsing.yaml.constructor import AnsibleConstructor
File "/usr/lib/python2.7/site-packages/ansible/parsing/yaml/constructor.py", line 30, in <module>
from ansible.parsing.vault import VaultLib
File "/usr/lib/python2.7/site-packages/ansible/parsing/vault/__init__.py", line 45, in <module>
from cryptography.hazmat.backends import default_backend
File "/usr/lib64/python2.7/site-packages/cryptography/hazmat/backends/__init__.py", line 7, in <module>
import pkg_resources
File "/usr/lib/python2.7/site-packages/pkg_resources/__init__.py", line 3250, in <module>
@_call_aside
File "/usr/lib/python2.7/site-packages/pkg_resources/__init__.py", line 3234, in _call_aside
f(*args, **kwargs)
File "/usr/lib/python2.7/site-packages/pkg_resources/__init__.py", line 3263, in _initialize_master_working_set
working_set = WorkingSet._build_master()
File "/usr/lib/python2.7/site-packages/pkg_resources/__init__.py", line 574, in _build_master
ws = cls()
File "/usr/lib/python2.7/site-packages/pkg_resources/__init__.py", line 567, in __init__
self.add_entry(entry)
File "/usr/lib/python2.7/site-packages/pkg_resources/__init__.py", line 623, in add_entry
for dist in find_distributions(entry, True):
File "/usr/lib/python2.7/site-packages/pkg_resources/__init__.py", line 2065, in find_on_path
for dist in factory(fullpath):
File "/usr/lib/python2.7/site-packages/pkg_resources/__init__.py", line 2127, in distributions_from_metadata
if len(os.listdir(path)) == 0:
OSError: [Errno 13] Permission denied: '/usr/lib/python2.7/site-packages/urllib3-1.26.18.dist-info'
```

Fix for Python System packages permission breaking system Ansible:

```shell
sudo chmod -R o+rx /usr/lib/python2.7/site-packages
```

The version is still a bit behind so you might want to install a newer version via pip as per
[Workaround - Local User Install](#workaround---local-user-install).

```shell
/usr/bin/ansible --version
ansible 2.9.23
config file = /home/hari/.ansible.cfg
configured module search path = [u'/home/hari/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
ansible python module location = /usr/lib/python2.7/site-packages/ansible
executable location = /usr/bin/ansible
python version = 2.7.18 (default, Dec 18 2023, 22:08:43) [GCC 7.3.1 20180712 (Red Hat 7.3.1-17)]
```

**Partial port from private Knowledge Base page 2014+**
