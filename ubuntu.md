# Ubuntu

https://ubuntu.com/

The most widely used Linux distribution for cloud installations, derived from the battle tested stable long term
[Debian](debian.md) distribution which is now the standard for Linux and the eventual winner of the long Linux distro
wars, as the result of [Redhat](redhat.md) abandoning the open source mission in favour of profits and relegating
themselves to becoming legacy.

For servers always use LTS releases for stability (LTS = Long Term Support).

For the [Desktop release](https://ubuntu.com/download/desktop) you can just do with the newer version.

The [Releases](https://wiki.ubuntu.com/Releases) page lists the release dates and end of life date for each of version.

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

###### Ported from private Knowledge Base page 2010+ - should have been from mid 2000s but young guys don't document enough
