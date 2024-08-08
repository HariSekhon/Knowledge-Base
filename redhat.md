# Redhat

## RHEL / CentOS / Fedora / Rocky Linux

Redhat is one of the original Linux distributions.

Unfortunately they discontinued their free Redhat distribution replacing it with a commercially licensed
Redhat Enterprise Linux (RHEL) and a less stable desktop-focused Fedora Linux in the mid 2000s.

Community volunteers reacted by creating CentOS from RHEL source rpms to maintain a clone of stable redhat enterprise linux
for servers. Redhat supported this for years but eventually killed it in the leading to another clone Rocky Linux.

Redhat then decided to even stop providing their source rpms to make it harder to maintain any open source redhat server
class distribution. Fedora is less stable and changes more frequently.

Nobody who runs serious servers wants to beta test Redhat for free.

This has led to the other major original distribution [Debian](debian.md) (and its derivative [Ubuntu](ubuntu.md))
becoming the standard Linux distributions and sadly relegating Redhat based distos to legacy status.

Do not use Redhat based distros for new work today unless you have no other choice.

## Redhat Package Management - Rpm to Yum to Dnf

`rpm` installs local rpm package files and maintains a local database of installed packages.

`yum` pulls rpms from internet repositories and installs them locally while resolving the dependencies and pulling the
other required packages. Redhat used to be a nightmare in the early 2000s before Redhat adopted this package manager from
Yellow Dog Linux (Yum stood for Yellow dog Update Manager). Yum is written in Python, which is a maintenance nightmare
since the 2000s. Trying to upgrade the system Python would break the world leading to awkward workarounds or virtualenvs.

`dnf` - a drop in yum replacement written in C/C++, often symlinked to `yum` with mostly the same arguments for the basics
but differing outputs and options have happened over time.

You can generally use `yum` and `dnf` commands interchangeably for the most part.

`yum` of course works on both older and newer systems so we'll keep using this for now.

### Yum & Rpm

Find which package would install the `htpasswd` command:

```shell
yum provides '*/bin/htpasswd'
```

```shell
yum provides \*/bin/java
```

output:

```
java-1.8.0-openjdk-headless
java-11-openjdk-headless
```

### Yum Proxy Configuration

Set yum proxy in `/etc/yum.conf`.

wget - set proxy in `/etc/wgetrc`.

Proxy configuration for all repos in `/etc/yum.conf`:

```
proxy=http://server:3128
proxy_username=hari
proxy_password=myPass
disable proxying for specific internal repos
proxy=_none_
or for a single user/session yum can pick up:
export http_proxy="http://user:pass@server:3128"
```

``shell
yum install -y yum-utils
``

```shell
repoquery -f */file
```

inspired by http://wiki.centos.org/TipsAndTricks/YumAndRPM

To see an rpm's files and header:

```shell
less "$file.rpm"
```

Look for rpm groups in `/usr/share/doc/rpm-4.4.2.3/GROUPS`

Repos files in `/etc/yum/repos.d/` have to end in `.repo`.

Determine when package was installed or when the os itself was installed by looking at first rpm installation date:

```shell
rpm -qa --last
```

keychecker # from epel, lists the originating repos of all installed rpms from their gpg signature, or packages specified on the cli

Show all repos + enabled/disabled status + no of packages in repo:

```shell
yum repolist all
```

Show just enabled or disabled:

```shell
yum repolist # [enabled|disabled]
```

Find all non CentOS packages:

```shell
rpm -qa --qf '%{NAME} %{VENDOR}\n' | grep -v CentOS
```

Reset file permissions on the files for a given package, in case you've messed things up:

```shell
rpm --setperms "$package"
```

```shell
rpm --setugids "$package"
```

Look at the changelog for a package to see if it's had patches applied:

```shell
rpm -q --changelog "$package" | less
```

See doc files for a package:

```shell
rpm -qd "$package"
```

See the doc files for the package that installed a file:

```shell
rpm -qfd /path/to/file
```

Find out what packages you have from a vendor by querying from the rpm fields works for most fields shown by `rpm -qi`:

```shell
rpm -qa release='*rf*'
```

```shell
rpm -qa vendor="Dag*"
```

```shell
rpm -qa packager="Dag*"
```

Extract just one file for from an rpm:

First list the files in the package to find out what you want:

```shell
rpm -qlp "$package"
```

This is the better way of seeing the filename that you must pass to cpio next for an exact match to extract just that one file:

```shell
rpm2cpio "$package" | cpio -t
```

Then extract just the file you want:

```shell
rpm2cpio "$package" | cpio -ivd filename
```

Here you can see it only extracted `cpan2rpm` when given `./usr` as this was seen by `cpio -t`

```shell
rpm2cpio cpan2rpm-2.026-12.0.el5.noarch.rpm | cpio -ivd ./usr/bin/cpan2rpm
```

results in `./usr/bin` being created with `cpan2rpm` in it, then just copy elsewhere

List RPM Install Dates:

```shell
rpm -qa --last
```

```shell
yum-config-manager --disable <repoid>
```

or

```shell
yum-config-manager --save --setopt=<repoid>.skip_if_unavailable=true
```

List all available rpms from a particular repo:

```shell
yum --disablerepo "*" --enablerepo "internal" list available
```

List package, both installed and available:

```shell
yum list "$package"
```

Download rpm and all the dependencies that aren't currently installed for putting in to your own stable repo

```shell
yumdownloader --resolve "$package"
```

Use yum to install a local package, automatically checking/satisfying dependencies:

```shell
yum --nogpgcheck localinstall packagename.arch.rpm
```

Select priority, name from repos order by priority desc:

```shell
cat /etc/yum.repos.d/*.repo |
sed -n -e '/^\[/h; /priority *=/{ G; s/\n/ /; s/ity=/ity = /; p }' |
sort -k3n
```

my slightly better but much more complicated version

```shell
cat /etc/yum.repos.d/*.repo |
sed -n -e '/^\[/h; /priority *=/{ H; g; s/ *\n/ / ; s/ity=/ity = /; p }' |
xargs -l1 printf "%-15s %s %s %s\n" |
sort -k4n
```

Anything not listed will default to priority 99.

This rather complicated line will output the complete thing, but it's turning in to a shell script by this point:

```shell
cat /etc/yum.repos.d/*.repo |
grep -e "^\[" \
     -e "priority *=" |
     tr '\n' ' ' |
     ed 's/ \[/\n[/g;' |
    while read -r line; do
       grep -q "priority" <<< "$line" || line+=" priority=99"
       echo "$line"
    done |
    sed 's/ity=/ity = /' |
    xargs -l1 printf "%-25s %s %s %s\n" |
    sort -k4n
```

```shell
yum search freeradius
```

```shell
yum list freeradius*
```

```shell
yum info freeradius*
```

```shell
yum whatprovides etc/httpd
```

```shell
yum grouplist hidden
```

```shell
yum groupinstall
```

```shell
yum update --exclude="$package"
```

#### Protect base repo packages

Use to protect base repo packages from being updated from other repos:

Packages:

- `yum-protectbase`        in RHEL5
- `yum-plugin-protectbase` in RHEL6

Config:

- `/etc/yum.repos.d/base.repo`: `protect=1` under stanza
- `/etc/yum/pluginconf.d/rhnplugin.conf`: `protect = yes` under stanza

Build rpms

```shell
rpmbuild --rebuild foo.src.rpm
```

```shell
rpmbuild -D "packager Hari Sekhon <hari.sekhon@gmail.com>" foo.spec
```

```shell
cd
mkdir -p redhat/{SRPMS,RPMS,SPECS,BUILD,SOURCES}
echo "%_topdir /home/hari/redhat" >> .rpmmacros
echo "%packager Hari Sekhon <hari.sekhon@gmail.com>" >> .rpmmacros
then rpmbuild
```

When packaging for custom version of perl, put this in `~/.rpmmacros`:

```shell
%packager   Hari Sekhon
%__perl     /usr/local/bin/perl
```

```shell
cpan2rpm --no-sign --packager "Hari Sekhon <hari.sekhon@gmail.com>" MIME::Lite
```

Download all RPMs from an external repo, install yum-utils for reposync, `createrepo` and have a web server serve out this directory:

```shell
yum install yum-utils createrepo
```

```shell
reposync -r <repo_name>
```

```shell
createrepo .
```

### RHEL 8 modules

Collections of packages for an application stream version.

```shell
yum module list
```

```shell
yum module list installed
```

Which module provides this rpm:

```shell
yum module provides $rpm
```

```shell
yum module info module
```

List rpms installed my module:

```shell
yum module info --profile module:stream
```

Display status of module:

```shell
yum module list "$module"
```

Enable without installing rpms:

```shell
yum module enable "$module:$stream"
```

Install specific stream version:

```shell
yum module install "$module:$stream/$profile"
```

Disable + remove all rpms from module stream:

```shell
yum module remove module &&
yum module disable module
```

### RHSCL - Redhat Software Collections

Gives developers newer Python/Perl/MySQL bundles.

https://developers.redhat.com/products/red-hat-software-collections/overview

### Pulp

https://pulpproject.org/

Repository management

## Kickstart - Automated Installations

All Redhat derived systems can be automatically installed using a Kickstart configuration file which can be bundled into
an installation medium such as a DVD iso or served by a web server on the local network.

This is called by adding the following kernel arguments in the installation grub bootloader:

```shell
inst.ks=http://192.168.1.2:8080/kickstart.cfg
```


(if booting hangs, try adding some of these kernel arguments: `nolapic`, `pci=routeirq`, `pci=noacpi`, `noapic`)


If you just want to start a quick webserver from your local directory, you can do this which starts a local webserver
on port 8080:

**warning** this will share out your entire `$PWD` local directory contents without authentication so copy to an empty
`/tmp` directory and share that so nothing else is exposed:

```shell
mkdir -p -v /tmp/serve-kickstart &&

cd /tmp/serve-kickstart &&

wget -nc https://raw.githubusercontent.com/HariSekhon/Templates/master/anaconda-ks.cfg &&

python -m SimpleHTTPServer ||

python -m http.server
```

### Kickstart Template

When installing a system by hand, the anaconda installer generates a template automatically with the settings you used
at `/root/anaconda-ks.cfg`. You can use this as a starting point,

Or you can use this template with some additional tips:

[HariSekhon/Templates - anaconda-ks.cfg](https://github.com/HariSekhon/Templates/blob/master/anaconda-ks.cfg)

or the real kickstart config used in the Packer repo below.

### HashiCorp Packer + Kickstart Config

[HariSekhon/Packer-templates](https://github.com/HariSekhon/Packer-templates)

Packer builds fully automated Virtual Machine golden templates from which to clone virtual machines by booting the
Redhat Anaconda installer medium with a Kickstart config.

Real-world Kickstart config used by Packer build:

[HariSekhon/Packer-templates - installers/anaconda-ks.cfg](https://github.com/HariSekhon/Packer-templates/blob/master/installers/anaconda-ks.cfg)

[HariSekhon/Packer-templates - fedora-x86_64.vbox.pkr.hcl](https://github.com/HariSekhon/Packer-templates/blob/master/fedora-x86_64.vbox.pkr.hcl)

[HariSekhon/Packer-templates - rocky-x86_64.vbox.pkr.hcl](https://github.com/HariSekhon/Packer-templates/blob/master/rocky-x86_64.vbox.pkr.hcl)

###### Ported from private Knowledge Base page 2010+ - should have been from early to mid 2000s but young guys don't document enough
