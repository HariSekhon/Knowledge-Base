# Virtualization

<!-- INDEX_START -->

- [List of Software](#list-of-software)
- [MultiPass](#multipass)

<!-- INDEX_END -->

## List of Software

- [VirtualBox](virtualbox.md) - free desktop virtualization software, only really for x86 / x86_64 based
  systems, current beta doesn't work on Mac Arm Silicon processors
- [UTM](https://mac.getutm.app/) - easy frontend to use qemu virtualization on Mac Apple M Silicon processors
  - has a [Gallery](https://mac.getutm.app/gallery/) of pre-made VMs you can quickly download
- [Vagrant](vagrant.md) - automates VirtualBox VMs for easy reproduction of local labs with scripted provisioners or calling Puppet or similar (I used this a lot at [Cloudera](https://cloudera.com))
- MultiPass - see below

## MultiPass

Uses hyperkit virtualization on Mac for easy VM management.

<https://multipass.run/docs/mac-tutorial>

```shell
brew install --cask multipass
```

```shell
multipass find
```

```shell
multipass launch -n myvm 22.04
```

```shell
multipass list
```

```shell
multipass shell
```

```shell
#multipass stop myvm
multipass delete myvm
```

```shell
multipass purge
```
