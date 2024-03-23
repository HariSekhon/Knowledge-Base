# Mac

The best laptop money can buy:

https://www.apple.com/uk/macbook-pro/

If you don't have an M3 Pro / Max - you're missing out on an excellent (but overpriced) machine.

## Homebrew - Package Management

The best most widely used package manager for Mac in the world.

See [brew.md](brew.md) for how to use it and great package lists I've spent years discovering and building up.

## Commands

### Screenshots

#### Screenshot the Whole Screen

`Cmd` + `Shift` + `3`

#### Screenshot a Selection - Drag a Rectangle

Switches to a cross-hair to drag to what you want to screenshot.

`Cmd` + `Shift` + `4`

#### The Screencapture CLI

You may be prompted to allow Terminal to record the screen under `Privacy & Security` -> `Screen Recording` the first
time - it'll tell you that you have to restart the Terminal but it worked without a restart.

Switches to select window to capture:

```shell
screencapture -W /tmp/screenshot.png
```

Interactive mode with full toolbar, same as the `Screenshot.app`:

```shell
screencapture -i -U /tmp/screenshot.png
```

Video recording mode for 10 seconds (without `-V` it will record until you `Ctrl`-`c` it):

```shell
screencapture -v -V 10 /tmp/videocapture.mp4
```

So many great options from delayed screenshots, copy to clipboard, open in Preview, capture a coordinate rectangle
(great for automation!), see:

```shell
screencapture --help
```

#### The Screenshot.app

in the Utilities folder is easy to use:

```shell
open /System/Applications/Utilities/Screenshot.app
```

### Finding Files - Spotlight Search and Index Management

The equivalent of `locate` on Linux, uses the Spotlight index:

```shell
mdfind [-onlyin /path/to/directory] [-name "$filename"] "$term"
```

Erase and rebuild the Spotlight index:

```shell
mdutil -E
```

Enable / disable Spotlight indexing for a given volume or entirely:

```shell
mdutil -i
```

### Disk Management

Using graphical Disk Utility is easiest:

```shell
open /System/Applications/Utilities/Disk\ Utility.app
```

#### CLI Disk Management

Great tutorial:

[Part 1](http://www.theinstructional.com/guides/disk-management-from-the-command-line-part-1) -
List, Verify, Repair, Rename, Erase volumes

[Part 2](https://www.theinstructional.com/guides/disk-management-from-the-command-line-part-2) -
Partition, Format, Split / Merge Partitions

[Part 3]() - Create `.dmg` disk images from a Volume / Folder, Encrypted Disk Image, Resize Image, Restore Image


#### List disks

```shell
diskutil list
```

`diskutil mount` and `diskutil mountDisk` are the same

#### Mount a partition

```shell
diskutil mount /dev/disk4s2
```

```shell
diskutil unmount /dev/disk4s2
```

or by volume location:

```shell
diskutil unmount "/Volumes/$NAME"
```

Mount a partition read-only if having trouble and trying to recover data:

```shell
diskutil mount readOnly /dev/disk4s2
```

Mount at a different location to the default `/Volumes/<partition_metadata_name>`:

```shell
diskutil mount /dev/disk4s2 -mountPoint /path/to/dir
```

Mount / unmount partitions on a whole disk by reading its partition table:

```shell
diskutil mountDisk disk10
```

```shell
diskutil unmountDisk disk10
```

Verify a volume:

```shell
diskutil verifyVolume "/Volumes/$NAME"
```

Repair volume:

```shell
diskutil repairVolume "/Volumes/$NAME"
```

```shell
diskutil verifyPermissions "/Volumes/$NAME"
```

```shell
diskutil repairPermissions "/Volumes/$NAME"
```

Format a partition This is risky because there is no confirmation, better to do this from Disk Utility:

```
diskutil eraseDisk "$filesystem" "$name" "/dev/$diskN"
```

See which filesystems are available for formatting:

```shell
diskutil listFilesystems
```

Rename a disk:

```shell
diskutil rename "$volume_name" "$new_volume_name"
```

#### Partition and Format a disk

APFS requires GPT partition table

```shell
disk="disk4"
partition_table="GPT"
name="MyVolume"
filesystem="APFSX"  # AppleFS case-sensitive, found from 'diskutil listFilesystems' above
size="0b"           # integer + units suffix (b, m or g for bytes, megabytes or gigabytes) - '0b' uses all space
```

```
diskutil partitionDisk "/dev/$disk" "$partition_table" "$filesystem" "$name" "$size"
```

##### Multiple Partition and Format

```
diskutil partitionDisk /dev/"$disk" "$partition_table" "$filesystem" "First"  "$size" \
                                                       "$filesystem" "Second" "$size" \
                                                       "$filesystem" "Third"  "$size" \
                                                       "$filesystem" "Fourth" "$size" \
                                                       "$filesystem" "Fifth"   0b  # '0b' to use up all remaining space
```

Partition splitting doesn't seem to work with APFS, only macOS Extended, as APFS tells you to
`diskutil apfs deleteContainer disk10` instead which leaves you with free space to create a new partition.

#### Erase a disk before decommissioning it

Either use Disk Utility above, a command like `diskutil eraseDisk ...` or the more portable unix command `dd` with a
custom command like this to do a moderate 3 pass overwrite
(tune number of `passes` variable to suit your level of data recovery paranoia, eg. DoD standard 7 passes):

##### WARNING: disk numbers may shunt up in numbers as you insert more removal drives, especially for 'synthesized' virtual disks that display for volume containers

```
passes=3
time \
for number in $(seq $passes); do
    echo pass $number
    echo
    time sudo dd if=/dev/urandom of=/dev/disk4 bs=1M
    echo
done
```

Note: multiple passes are only for old inaccurate HDDs rotating mechanical metal platter disk.
For SSDs, you only need a single pass.

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
