# Vagrant

<https://www.vagrantup.com/>

Written in Ruby with a declarative `Vagrantfile` to declare the VMs, their settings, networking and provisioning scripts for automation of the VM contents.

Useful to creating and maintaining local clusters of VMs for reproducing client's problems on specific versions of
software. Used this at [Cloudera](https://cloudera.com) a lot.

<!-- INDEX_START -->

- [Install](#install)
- [Vagrantfile Templates](#vagrantfile-templates)
- [Official Boxes](#official-boxes)
- [Vagrant CLI](#vagrant-cli)
- [Environment Variables](#environment-variables)
- [Shared Folders](#shared-folders)
  - [Packaging](#packaging)

<!-- INDEX_END -->

## Install

[Install Doc](https://developer.hashicorp.com/vagrant/docs/installation)

[Downloads](https://developer.hashicorp.com/vagrant/downloads)

## Vagrantfile Templates

[HariSekhon/Vagrant-templates](https://github.com/HariSekhon/Vagrant-templates)

[HariSekhon/Templates - Vagrantfile](https://github.com/HariSekhon/Templates/blob/master/Vagrantfile)

```shell
wget -nc https://raw.githubusercontent.com/HariSekhon/Templates/master/Vagrantfile
```

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Vagrant-templates&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Vagrant-templates)

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Templates&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Templates)

## Official Boxes

<https://app.vagrantup.com/boxes/search>

## Vagrant CLI

```shell
vagrant box list
```

Create your `Vagrantfile` from the templates above with the VMs, settings and provisioner scripts you want.

```shell
cd somedir/  # which contains a Vagrantfile
```

Boots the VM(s) specified in the `Vagrantfile` from the base box image(s), configures it with the settings and runs the
provisioning
scripts / Puppet /
Ansible etc:

```shell
vagrant up
```

SSH into the VM - auto-determines the IP address from VirtualBox:

```shell
vagrant ssh # <vm_name>
```

Inside VM see mounted shared folder of content shared with your host desktop / laptop:

```shell
cd /vagrant
ls -l
```

```shell
vagrant down
```

Delete the VM:

```shell
vagrant destroy
```

## Environment Variables

Override the default `Vagrantfile`:

```shell
VAGRANT_VAGRANTFILE=Vagrantfile-centos vagrant up
VAGRANT_VAGRANTFILE=Vagrantfile-centos vagrant ssh
```

More logging:

```shell
VAGRANT_LOG=INFO vagrant ....
```

## Shared Folders

VBoxAdditions are required for shared folders

Uses VirtualBox commands to set up machine.

It prefixes `VBoxManage` commands with `sudo` - fails if `require_tty` is set in `/etc/sudoers`.

Networking is done via SSH commands, just make sure to not `require_tty` in `/etc/sudoers`.

Problem nanifests as:

```text
The following SSH command responded with a non-zero exit status.
Vagrant assumes that this means the command failed!

touch /etc/sysconfig/network-scripts/ifcfg-eth1
```

Fix:

```shell
sudo perl -pi -e 's/^(\s*Defaults\s+requiretty)/#$1/' /etc/sudoers
```

### Packaging

- install vbox additions (see [virtualbox](virtualbox.md))
- remove extra network interfaces for internal network since vagrant will recreate them
- remove extra USB, Audio ports

On a Linux VM to have it self-resolve its own FQDN properly:

```shell
cat >> /etc/rc.local:
ip=$(ifconfig | grep -A1 eth1 | grep "inet addr" | sed 's/^.*addr://;s/[[:space:]].*$//')
if [ -n "$ip" ] && ! grep -q "^$ip " /etc/hosts;then
    echo "$ip $HOSTNAME.local $HOSTNAME" >> /etc/hosts
fi
sed -i "s/^127.0.0.1.*/127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localhost/" /etc/hosts
```

Build a base box from the normal VM, `vagrant/repkg.sh` for convenience:

```shell
vagrant package --base centos6-base --output centos6.box &&
vagrant box remove centos6 &&
vagrant box add centos6 centos6.box &&
mv centos6.box ../boxes/
```

Mount `/vagrant` manually if it doesn't auto-mount:

```shell
sudo mount -t vboxsf v-root /vagrant/
```

**Ported from private Knowledge Base page 2013+**
