# VirtualBox

<https://www.virtualbox.org/>

Open source VM desktop software.

<!-- INDEX_START -->

- [Key Points](#key-points)
- [VirtualBox CLI](#virtualbox-cli)
- [DHCP](#dhcp)
- [DNS Proxy](#dns-proxy)
- [VirtualBox Guest Additions](#virtualbox-guest-additions)
- [Root Keys, Networking etc](#root-keys-networking-etc)
- [Troubleshooting](#troubleshooting)
  - [To use `/root` home directory](#to-use-root-home-directory)
- [Upgrades](#upgrades)

<!-- INDEX_END -->

## Key Points

Brilliant for its day on x86_64 machines.

Doesn't support new Apple Silicon ARM architecture chips properly yet, very buggy.

Use [UTM](https://mac.getutm.app/) for qemu VMs on new Macs instead (unfortunately this rules out [Vagrant](vagrant.md)).

Consider switching to [Docker](docker.md) and local [Kubernetes](kubernetes.md) instead of using VMs.

## VirtualBox CLI

```shell
VBoxManage --help
```

```shell
VBoxManage metrics list
```

## DHCP

```shell
VBoxManage list natnets
```

```shell
VBoxManage natnetwork modify --netname NatNetwork1 --dhcp on
```

## DNS Proxy

Enable DNS Proxy.

```shell
VBoxManage list vms
```

Software polite shutdown via ACPI:

```shell
VBoxManage controlvm acpipowerbutton "default"
```

```shell
VBoxManage modifyvm "default" --natdnsproxy1 on
```

```shell
VBoxManage startvm "default"
```

```shell
cat /etc/resolv.conf
```

output shows the VBox NAT DNS address:

```none
nameserver 10.0.2.3
```

## VirtualBox Guest Additions

This allows for:

1. Mouse pointer integration with GUI VMs
1. Shared Folders for sharing a directory between your host desktop / laptop which appears as a mount point in the VM
   for easy file transfers
1. Software shutdowns (ACPI)

To install, either:

1. mount the in-built guest additions ISO in the VM via the VirtualBox GUI
1. or dump guest additions iso file from a system with a desktop manager, then `mount /dev/sr0` inside the VM

Then run the installer file inside the VM where the guest additions virtual CD is mounted (`/mnt/VBoxLinuxAdditions.run`).

Broken on newer Ubuntu 14, may need to upgrade VirtualBox but this will break Vagrant:

```shell
if which yum; then
  yum install -y make gcc kernel-headers-`uname -r` kernel-devel-`uname -r`
elif grep -i ubuntu /etc/*release;then
  apt-get install -y virtualbox-guest-utils virtualbox-guest-x11
  elif which apt-get; then
  apt-get install -y gcc kernel-devel
  apt-get install -y build-essential module-assistant
fi
```

Needed to open with GUI in VBox and click install guest additions

```shell
{
  mount /dev/sr0   /mnt ||    # CentOS6
  mount /dev/cdrom /mnt       # CentOS5
} &&
/mnt/VBoxLinuxAdditions.run
```

Load kernel modules if not already loaded:

```shell
lsmod | grep -i vbox || /etc/init.d/vboxadd setup
```

Start VirtualBox Guest Additions service if not already started:

```shell
ps -ef | grep -i vbo[x] || /etc/init.d/vboxadd-service start
```

```shell
/etc/init.d/vboxadd-service status
```

## Boot from USB

```shell
VBoxManage internalcommands createrawvmdk -filename usb.vmdk -rawdisk /dev/disk2
```

then add vmdk to VM storage controller in VirtualBox GUI settings.

## Reclaim Disk Space

First zero out free disk space. This doesn't actually consume space VirtualBox must be smart about not writing zeros

On Windows:

```shell
sdelete -z c:
```

On Linux:

```shell
dd if=/dev/zero of=zero.txt
sync
sleep 1
sync
rm -f zero.txt
```

Now shut down the VM and compact the disk image:

VDI:

```shell
VBoxManage modifyhd disk.vdi --compact
```

VMDK - use VMware Fusion / Workstation (VirtualBox runs vmdk but VBoxManage `modifyhd` command doesn't support `--compact`ing it in 4.2.6)

```shell
vmware-vdiskmanager -k disk.vmdk
```

## Convert VMware VMDK to VBox disk format for use in VirtualBox

Using VMware Fusion.

Convert to `.ovf`:

```shell
"/Applications/VMware Fusion.app/Contents/Library/VMware OVF Tool/ovftool" Cloudera-Training-VM-4.1.1.c/Cloudera-Training-VM-4.1.1.c.vmx Cloudera-Training-VM-4.1.1c-OVF/Cloudera-Training-VM.ovf
```

Convert to `.ova`:

```shell
"/Applications/VMware Fusion.app/Contents/Library/VMware OVF Tool/ovftool" cloudera-data-science-vm.vmx cloudera-data-science-vm.ova
```

```shell
mv cloudera-data-science-vm.ova ...
```

- Import into VirtualBox (name VM, don't start yet!)
- Add Sata controller + CD drive
- Install Guest Additions to added CD to drive
- created Shared folder /Users/hari/vagrant to v-root
- Network port forward so we can paste in all these commands

```shell
yum -y update kernel
```

```shell
vim /boot/grub/grub.conf
```

```shell
reboot
```

OR

- Installed CentOS 6 with @core @server-policy only
- set terminal profile transparency
- 40GB thin provision storage, leave swap partition
- leave swap partition it's more space friendly in thin provisioned disks than dd if=/dev/zero of=/swapfile

Old kernel-headers may not be available so update kernel:

```shell
yum install -y bind-utils \
               dstat \
               ethtool \
               iputils \
               lsof \
               mlocate \
               parted \
               sysstat \
               tcpdump \
               traceroute \
               wget \
               vim-enhanced &&
yum update -y kernel &&
reboot
```

### Root Keys & Networking

On RHEL5 this is `60-net.rules`:

```shell
rm -vf /etc/udev/rules.d/70-persistent-net.rules

mkdir -v /etc/udev/rules.d/70-persistent-net.rules # to prevent it being recreated

# rm -vf /etc/ssh/ssh_host_*

mkdir /vagrant
mkdir /root/.ssh

mount -t vboxsf v-root /vagrant

cp /vagrant/id_rsa.pub /root/.ssh/authorized_keys

chown -R root:root /root/.ssh
chmod 0700 /root/.ssh
chmod 0600 /root/.ssh/authorized_keys

service NetworkManager stop
chkconfig NetworkManager off

if ! [ -f /etc/sysconfig/network-scripts/ifcfg-eth0 ]; then
  echo GATEWAY=10.0.2.2 >> /etc/sysconfig/network
  perl -pi -e 's/^HOSTNAME=/HOSTNAME=training-ml-template' /etc/sysconfig/network
  cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<-EOF
  DEVICE=eth0
  IPADDR=10.0.2.15
  NETMASK=255.255.255.0
  ONBOOT=yes
  NAME=eth0
EOF
fi

service network restart
```

## Troubleshooting

`hostonlyif` create problem on `vagrant up` resolved by (couldn't enable `hostonlyif` in VirtualBox GUI as well)

On Mac, restart VirtualBox:

```shell
sudo /Library/StartupItems/VirtualBox/VirtualBox restart
```

This didn't work one time, had to do go via Menu:

```
VirtualBox -> Preferences -> Network -> add Host-only Network vboxnet0
```

`VBOX_E_INVALID_OBJECT_STATE` when trying to do:

```shell
vm_name="Hortonworks Sandbox 2.0"
VBoxManage showvminfo  $vm_name
VBoxManage stopvm      $vm_name
VBoxManage startvm     $vm_name
```

tried:

```shell
VBoxManage controlvm    $vm_name poweroff
VBoxManage controlvm    $vm_name reset
VBoxManage discardstate $vm_name
VBoxManage unregistervm $vm_name
```

None of that worked - it turns out there was a pop-up window still open behind other windows that was stopping the VM from going down properly

### To use `/root` home directory

- .ssh/id_rsa private keys don't work without tight permissions
- 0077 didn't work for umask, use 077
- mount -t vboxsf umask=077,uid=0,gid=0 SharedFolder /SharedFolder

## Upgrades

Beware upgrading VirtualBox may break your existing VMs containing versions of virtualbox guest additions.

**Ported from private Knowledge Base page 2013+**
