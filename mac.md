# Mac

The best laptop money can buy:

https://www.apple.com/uk/macbook-pro/

If you don't have an M3 Pro / Max - you're missing out on an excellent (but overpriced) machine.

## Homebrew - Package Management

The best most widely used package manager for Mac in the world.

See [brew.md](brew.md) for how to use it and great package lists I've spent years discovering and building up.

## Commands

### Disk Management

#### List disks

```shell
diskutil list
```

`diskutil mount` and `diskutil mountDisk` are the same

#### Mount a partition

```shell
diskutil mount /dev/disk4s2
```

Mount a partition read-only if having trouble and trying to recover data:

```shell
diskutil mount readOnly /dev/disk4s2
```

Mount at a different location to the default `/Volumes/<partition_metadata_name>`:

```shell
diskutil mount /dev/disk4s2 -mountPoint /path/to/dir
```

#### Format a disk

Use Disk Utility, it's easiest to use:

```shell
open /System/Applications/Utilities/Disk\ Utility.app
```

You may need to change the partition table type to be able to format with the more advanced APFS+.

#### Erase a disk

Either use Disk Utility above or use `dd` in custom with a command like this to do a moderate 3 pass overwrite
(tune number of passes to suit your level of data recovery paranoia, eg. DoD standard 7 passes):

```
time for x in {1..3}; do echo pass $x; echo; time sudo dd if=/dev/urandom of=/dev/disk4 bs=1M ; echo; done
```

### Service Management

Load and start a service from a `plist` file:

```shell
sudo launchctl load -F "/System/Library/LaunchDaemons/$name.plist"
sudo launchctl start "com.apple.$name"
```

Stop and unload a service:

```shell
sudo launchctl stop "com.apple.$name"
sudo launchctl unload "/System/Library/LaunchDaemons/$name.plist"
```

See [dhcp.md](dhcp.md) for a practical example of using this for the built-in tftp server for PXE boot installing Debian off your Mac.

## Creating Bootable USBs

Macs and many computers don't come with CD/DVD anymore to save space, so you can either buy an external USB dvd-writer or create bootable USBs.

To create a bootable USBs from ISO image files intended for CD/DVDs in order to use them to install Linux
or use a disk wiping distro like DBAN or ShredOS,
you can download [Etcher](https://etcher.balena.io/) or use
[mac_iso_to_usb.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/bin/mac_iso_to_usb.sh)
from [DevOps-Bash-tools](devops-bash-tools.md):

```shell
mac_iso_to_usb.sh "$iso"  # /dev/disk4
```

## Tips

`Cmd-Space` - opens Spotlight search to auto-complete and open anything quickly.

###### Ported from various private Knowledge Base pages 2010+
