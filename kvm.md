# KVM Virtualization

<!-- INDEX_START -->

- [GUI](#gui)
- [CLI](#cli)
- [Console](#console)

<!-- INDEX_END -->

## GUI

SSH to server with X Forwarding:

```shell
ssh -X kvmhost01
```

Send GUI program back to your local desktop:

```shell
sudo su
cp -a .Xauthority /root/
unset XAUTHORITY
virt-manager
```

## CLI

KVM Virsh can manage virtual machines on the command line

```shell
virsh
```

```shell
man virsh
```

```shell
virsh connect qemu:///system    # connects to daemon supervising Qemu or KVM domains
```

```shell
virsh list
```

to view details about a machine:

```shell
virsh dumpxml machinename
```

```shell
virsh dumpxml machinename > /tmp/machine.xml
```

```shell
virsh dominfo <num|name>
```

```shell
virsh dominfo ipa01
```

copy/edit `/tmp/machine.xml` to create a new machine:

```shell
virsh create /tmp/machine.xml
```

or to define the machine but not run it:

```shell
virsh define /tmp/machine_new.xml
```

```shell
virsh start foo
```

```shell
virsh reboot foo
```

```shell
virsh shutdown foo
```

```shell
virsh suspend foo
```

```shell
virsh resume foo
```

```shell
virsh destroy machinename
```

```shell
virsh undefine machinename
```

```shell
yum install @virtualization
##yum install kvm kmod-kvm qemu
#yum install virsh
#apt-get install virsh
```

```shell
kvm --help
```

```shell
kvm -m 512 -hda disk.img -cdrom ubuntu.iso -boot d -smp 2
```

```shell
qemu-kvm --help
```

```shell
modprobe -l | grep kvm
```

convert VMware disk image (not tested this):

```shell
kvm-img convert -O qcow2 zimbra-000001.vmdk zimbra.qcow2
```

File Sharing with KVM Host

in KVM host:

```shell
/usr/bin/qemu-kvm -m 1024 -name f15 -drive file=/images/f15.img,if=virtio -fsdev local,security_model=passthrough,id=fsdev0,path=/tmp/share -device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare
```

in VM:

```shell
mount -t 9p -o trans=virtio,version=9p2000.L /hostshare /tmp/host_files
```

## Console

```shell
virsh ttyconsole 12
```

add one if not existing:

```shell
virsh edit 12
```

```shell
virsh console 12 # opens serial console of server
```

no output problem guest hasn't been configured to support console

in guest:

```shell
cp /etc/init/tty1.conf /etc/init/ttyS0.conf
```

edit:

```shell
exec /sbin/getty -8 115200 ttyS0 xterm
```

```shell
vi /etc/default/grub
```

```properties
GRUB_CMDLINE_LINUX_DEFAULT="console=ttyS0"
```

```shell
update-grub2
```

then restart guest.

**Ported from private Knowledge Base pages 2010+**
