# Ubuntu

<https://ubuntu.com/>

The most widely used Linux distribution for cloud installations, derived from the battle tested stable long term
[Debian](debian.md) distribution which is now the standard for Linux and the eventual winner of the long Linux distro
wars, as the result of [Redhat](redhat.md) abandoning the open source mission in favour of profits and relegating
themselves to becoming legacy.

For servers always use LTS releases for stability (LTS = Long Term Support).

For the [Desktop release](https://ubuntu.com/download/desktop) you can just do with the newer version.

The [Releases](https://wiki.ubuntu.com/Releases) page lists the release dates and end of life date for each of version.

<!-- INDEX_START -->

- [Debian Core](#debian-core)
  - [Upgrade LTS to newer non-LTS release](#upgrade-lts-to-newer-non-lts-release)
- [AutoInstall - Automated Installations](#autoinstall---automated-installations)
  - [Autoinstall Template](#autoinstall-template)
  - [HashiCorp Packer + Autoinstall Config](#hashicorp-packer--autoinstall-config)

<!-- INDEX_END -->

## Debian Core

Read the [Debian.md](debian.md) page for Deb / Apt package management and other core commands derived from Debian.

### Upgrade LTS to newer non-LTS release

Don't do this on servers unless you have no other choice.

Servers should remain on LTS release, normal releases are better for desktops.

```shell
sudo apt-get install -y update-manager-core
sed -i 's/^Prompt=lts/Prompt=normal/' /etc/update-manager/release-upgrades
```

This step must be done locally, otherwise it tries to spawn another sshd which crashes out as a bug in 12.04 LTS:

```shell
do-release-upgrade
```

Change keyboard layout (requires reboot):

```shell
sudo dpkg-reconfigure keyboard-configuration
```

## AutoInstall - Automated Installations

Ubuntu can be automatically installed via a config text file bundled into an installation medium such as a DVD iso or
served by a web server on the local network.

Newer versions of Ubuntu use [Autoinstall](https://ubuntu.com/server/docs/install/autoinstall)
([autoinstall-user-data](https://github.com/HariSekhon/Packer-templates/blob/master/installers/anaconda-ks.cfg) config).

This is called by adding the following kernel arguments in the installation grub bootloader:

```shell
linux /casper/vmlinuz autoinstall 'ds=nocloud-net;s=http://192.168.1.2:8080/'
```

The above command will search the web server base address for `user-data` and `meta-data` files.
The `user-data` contents should be the config above with all the installation settings
but the latter `meta-data` can be empty.

Older versions of Ubuntu used [Redhat](redhat.md)'s Kickstart format
([anaconda-ks.cfg](https://github.com/HariSekhon/Packer-templates/blob/master/installers/anaconda-ks.cfg) config).

If you just want to start a quick webserver from your local directory, you can do this which starts a local webserver
on port 8080:

**warning** this will share out your entire `$PWD` local directory contents without authentication so copy to an empty
/tmp directory and share that so nothing else is exposed:

```shell
mkdir -p -v /tmp/serve-autoinstall &&

cd /tmp/serve-autoinstall &&

wget -nc -O user-data https://raw.githubusercontent.com/HariSekhon/Templates/master/autoinstall-user-data &&

touch meta-data &&

python -m SimpleHTTPServer ||

python3 -m http.server
```

### Autoinstall Template

[HariSekhon/Templates - autoinstall-user-data](https://github.com/HariSekhon/Templates/blob/master/autoinstall-user-data)

```shell
wget -nc -O user-data https://raw.githubusercontent.com/HariSekhon/Templates/master/autoinstall-user-data
```

### HashiCorp Packer + Autoinstall Config

[HariSekhon/Packer-templates](https://github.com/HariSekhon/Packer-templates)

Packer builds fully automated Virtual Machine golden templates from which to clone virtual machines by booting
the Ubuntu installer medium with an Autoinstall config.

Real-world Autoinstall config used by Packer build:

[HariSekhon/Packer-templates - installers/autoinstall-user-data](https://github.com/HariSekhon/Packer-templates/blob/master/installers/autoinstall-user-data)

For building Ubuntu VMs with this config, here are relevant real configs:

[HariSekhon/Packer-templates - installers/autoinstall-user-data](https://github.com/HariSekhon/Packer-templates/blob/master/installers/autoinstall-user-data)

[HariSekhon/Packer-templates - ubuntu-x86_64.vbox.pkr.hcl](https://github.com/HariSekhon/Packer-templates/blob/master/ubuntu-x86_64.vbox.pkr.hcl)

###### Ported from private Knowledge Base page 2010+ - should have been from mid 2000s but young guys don't document enough
