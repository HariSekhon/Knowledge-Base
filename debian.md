# Debian

https://www.debian.org/

The legendary, mature widely used stable Linux distribution with the best most reliable tenure.

Philosophical thoroughbred open-source has stood the test of time. It's the open source purist's choice.

Debian has won the Linux distro wars along with its derivative [Ubuntu](ubuntu.md)
due to [Redhat](redhat.md) killing its original open source Redhat and later community effort derivative CentOS in order
to try to force people to pay for Redhat Enterprise Linux. In reality, all this has done is cause Redhat to become a
legacy Linux distribution.

If you could save only one Linux distribution to remain in existence, or bet the future on, it would be Debian.

## Package Management

Debian packages are [deb](https://en.wikipedia.org/wiki/Deb_(file_format)) format files.

`dpkg` installs / uninstalls a single deb package.
It tracks the installed packages in the `/var/lib/dpkg/` directory and can query the list of installed packages
or specific details on a single installed package.

`apt*` programs search and download deb packages from online repositories (or local media) and get `dkg` to install them.

### `apt-get` vs `apt` vs `aptitude`

- `apt-get` - the original package management program
  - `apt-cache` searches the package lists downloaded by `apt-get`

- `apt` - newer wrapper command to `apt-get` with a subset of the functionality but different output format

- `aptitude` - newest with different output again but unlike `apt-get` and `apt` needs to be installed. Not sure why anybody cares to use this longer command, it's not like we get paid by the keystroke...

All three work in a similar way, so where you see `apt-get` you can substitute for `apt` or `aptitude` if you want to see a different output format.

If in doubt, just stick to `apt-get` and `apt-cache` for everything for simplicity.

### Get the latest package lists

Any one of these commands:

```shell
apt-get update
```

```shell
apt update
```

```shell
aptitude update
```

Quiet:

```shell
apt-get update -qq
```

### Package Search

Any one of these commands:

```shell
apt-cache search "$term"
```

`apt` gives a fancier colourised multi-line output for each package found but I prefer the simpler concise single line format of `apt-get` which is easier to `grep`:

```shell
apt search "$term"
```

`aptitude` uses a different but single line format:

```shell
aptitude search "$term"
```

### Install

```shell
apt-get install "$package"
```

```shell
apt install "$package"
```

```shell
aptitude install "$package"
```

Auto-accept installing without confirmation prompt:

```shell
apt-get install -y "$package"
```

Add `-q` or `-qq` for quiet modes:

```shell
apt-get install -q "$package"
```

Quiet and doesn't prompt:

```shell
apt-get install -qq "$package"
```

Show version that would be installed:

```shell
apt list "$package"
```

Show details on a package without it having to be installed first like with `dpkg`:

```shell
apt show "$package"
```

```shell
apt-cache showpkg "$package"
```

```shell
aptitude show "$package"
```

Show version, repo and debian pinning priority:

```shell
apt-cache policy "$package"
```

Show version and repo in one line concise format without repo pinning priority:

```shell
apt-cache madison "$package"
```

### Which package would provide a given file - `apt-file`

`apt-file` is an optional program, so you have to install it first:

```shell
apt-get install -y apt-file
```

Then download the package list information it needs to search package contents and not just name / version / description:

```shell
apt-file update
```

Now use it to search for which package would provide file `mysql_config`:

```shell
apt-file search mysql_config
```

List a package's contents without having to install it first:

```shell
apt-file list "$package"
```

### Local Package Information - `dpkg`


List installed packages:

```shell
dpkg -l
```

List contents of installed package:

```shell
dpkg -L "$package"
```

Which installed package owns `/usr/bin/mysql_config`:

```shell
dpkg -S /usr/bin/mysql_config
```

What depends on a package:

```shell
apt-cache rdepends --installed "$package"
```

Print package info:

```shell
dpkg -p "$package"
```

```shell
dpkg -s "$package"
```

Check for broken package(s)

```shell
dpkg -C ["$package"]
```

```shell
debconf-get-selections --installer
```

### Sync and manage local deb repositories

```shell
reprepro
```

## Docker

Debian is an excellent choice for a base docker image from which to derive and is used by many docker images in the world,
including several of my own at [HariSekhon/Dockerfiles](https://github.com/HariSekhon/Dockerfiles).

While not as lean as [Alpine](alpine.md), it is full featured and more compatible.

## Debian Preseeding - Automated Installs

Debian can be installed using Preseeding for fully automated hands-off installations:

https://wiki.debian.org/DebianInstaller/Preseed

Boot command to start installer with a `preseed.cfg` text config file which can be bundled into an installation medium
such as a DVD iso or served by a web server on the local network.

This is called by adding the following kernel arguments in the installation grub bootloader:

```shell
auto=true url=http://192.168.1.2:8080/preseed.cfg hostname=debian domain=local
```

If you just want to start a quick webserver from your local directory, you can do this which starts a local webserver
on port 8080:

**warning** this will share out your entire `$PWD` local directory contents without authentication so copy to an empty
/tmp directory and share that so nothing else is exposed:

```shell
mkdir -p -v /tmp/serve-preseed &&
cp -v preseed.cfg /tmp/serve-preseed/ &&
cd /tmp/serve-preseed &&

python -m SimpleHTTPServer
```

### Preseed Template

[HariSekhon/Templates - preseed.cfg](https://github.com/HariSekhon/Templates/blob/master/preseed.cfg)

### HashiCorp Packer + Preseed Config

Packer builds fully automated Virtual Machine golden templates from which to clone virtual machines by booting
the Debian installer medium with Debian Preseed template.

Real-world Preseed config used by Packer build:

[HariSehkon/Packer-templates - installers/preseed.cfg](https://github.com/HariSekhon/Packer-templates/blob/master/installers/preseed.cfg)

[HariSehkon/Packer-templates - debian-x86_64.vbox.pkr.hcl](https://github.com/HariSekhon/Packer-templates/blob/master/debian-x86_64.vbox.pkr.hcl)

## Debian Change Log tool

```shell
debchange
```

```shell
dch
```

`--increment` adds a new entry and drops you in to editor, with a username + timestamp footer eg:

```shell
dch -i -c hadoop.log
```

###### Ported from private Knowledge Base page 2010+ - not sure why so late given usage from 2002 - young guys don't know the value of documentation
