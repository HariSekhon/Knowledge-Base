# AWS - Amazon Web Services

NOT PORTED YET

<!-- INDEX_START -->

- [DevOps Bash tools for AWS, EKS, EC2 etc](#devops-bash-tools-for-aws-eks-ec2-etc)
- [Install AWS CLI](#install-aws-cli)
- [Set up access to EKS - Elastic Kubernetes Services](#set-up-access-to-eks---elastic-kubernetes-services)
- [EC2 Instances](#ec2-instances)
- [Get EC2 Console Output](#get-ec2-console-output)
- [Add an EC2 EBS volume](#add-an-ec2-ebs-volume)
  - [Create EC2 EBS volume](#create-ec2-ebs-volume)
  - [Attach the new volume to the EC2 instance](#attach-the-new-volume-to-the-ec2-instance)
  - [Partition and Format the new disk](#partition-and-format-the-new-disk)
  - [Mount the new volume by unchanging UUID for maximum stability](#mount-the-new-volume-by-unchanging-uuid-for-maximum-stability)
- [Resize an EC2 EBS volume](#resize-an-ec2-ebs-volume)
  - [Create a snapshot of the volume using its ID](#create-a-snapshot-of-the-volume-using-its-id)
  - [Increase the size of the EBS volume](#increase-the-size-of-the-ebs-volume)
  - [Inside the EC2 VM - grow the partition and extend the filesystem](#inside-the-ec2-vm---grow-the-partition-and-extend-the-filesystem)
- [Remove an EC2 EBS volume from a live running instance](#remove-an-ec2-ebs-volume-from-a-live-running-instance)
- [RDS - Relational Database Service](#rds---relational-database-service)
  - [List RDS instances](#list-rds-instances)
  - [Reset DB master password](#reset-db-master-password)
- [Troubleshooting](#troubleshooting)
  - [EC2 VM becomes unresponsive and cannot SSH under high loads](#ec2-vm-becomes-unresponsive-and-cannot-ssh-under-high-loads)
  - [RDS Write Stops Working due to Status `Storage Full`](#rds-write-stops-working-due-to-status-storage-full)
  - [EKS Spot - App fails to connect to DB due to race condition with Vault pod not being up yet](#eks-spot---app-fails-to-connect-to-db-due-to-race-condition-with-vault-pod-not-being-up-yet)
  - [EC2 Disk Mount Recovery](#ec2-disk-mount-recovery)

<!-- INDEX_END -->

## DevOps Bash tools for AWS, EKS, EC2 etc

[HariSekhon/DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools)

## Install AWS CLI

Follow the [install doc](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
or paste this to run an automated install script which auto-detects and handles Mac or Linux:

```shell
git clone https://github.com/HariSekhon/DevOps-Bash-tools
```

```shell
bash-tools/install/install_aws_cli.sh
```

Then [configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)
depending on if you're using SSO or access keys etc.

## Set up access to EKS - Elastic Kubernetes Services

See [eks.md](eks.md)

## EC2 Instances

<http://aws.amazon.com/ec2/instance-types/>

<https://instances.vantage.sh/>

<https://aws.amazon.com/ec2/pricing/on-demand/>

DO NOT USE T-series (T3 / T2) **burstable** general instances types for anything besides your own personal PoC.

They can seize up under heavy load and are not recommended for any production workloads.

## Get EC2 Console Output

Find the EC2 instance ID:

```shell
aws ec2 describe-instances \
        --query 'Reservations[*].Instances[*].[InstanceId,Tags[?Key==`Name`].Value | [0],Placement.AvailabilityZone]' \
        --output table
```

Debug if you're having issues rebooting a VM:

```shell
aws ec2 get-console-output --instance-id "$EC2_INSTANCE_ID" | jq -r .Output
```

## Add an EC2 EBS volume

This can also be useful for temporary space increases, eg. add a big `/tmp` partition to allow some
migration loads in an [Informatica](informatica.md) agent, which can be removed later.

(since you cannot shrink partitions later if you enlarge them instead)

### Create EC2 EBS volume

Find out the zone the EC2 instance is in - you will need to create the EBS volume in the same zone:

```shell
aws ec2 describe-instances \
        --query 'Reservations[*].Instances[*].[InstanceId,Tags[?Key==`Name`].Value | [0],Placement.AvailabilityZone]' \
        --output table
```

Set the Availability Zone environment variable to use in further commands:

```shell
AVAILABILITY_ZONE=eu-west-1a  # make sure this is same Availability Zone as the VM you want to attach it to
```

Choose a size in GB:

```shell
DISK_SIZE_GB=500
```

Create an EC2 EBS volume of 500Gb in the eu-west-1a zone where the VM is:

```shell
REGION="${AVAILABILITY_ZONE%?}"  # auto-infer the region by removing last character

aws ec2 create-volume \
    --size "$DISK_SIZE_GB" \
    --region "$REGION" \
    --availability-zone "$AVAILABILITY_ZONE" \
    --volume-type gp3
```

output:

```json
{
    "AvailabilityZone": "eu-west-1a",
    "CreateTime": "2024-08-02T11:55:18+00:00",
    "Encrypted": false,
    "Size": 500,
    "SnapshotId": "",
    "State": "creating",
    "VolumeId": "vol-007e4d5f88a46fb6f",
    "Iops": 3000,
    "Tags": [],
    "VolumeType": "gp3",
    "MultiAttachEnabled": false,
    "Throughput": 125
}
```

Set the `VolumeId` field to a variable to use in further commands:

```shell
VOLUME_ID="vol-007e4d5f88a46fb6f"
```

Create a description variable to use in next command:

```shell
VOLUME_DESCRIPTION="informatica-prod-secure-agent-tmp-volume"
```

Name the new volume so you know what is it when you look at it in future in the UI:

```shell
aws ec2 create-tags \
  --resources "$VOLUME_ID" \
  --tags Key=Name,Value="$VOLUME_DESCRIPTION"
```

### Attach the new volume to the EC2 instance

This can be done with zero downtime while the VM is running.

Look up the EC2 instance ID of the VM you want to attach it to:

```shell
aws ec2 describe-instances \
    --query 'Reservations[*].Instances[*].[InstanceId, Tags[?Key==`Name`].Value | [0]]' \
    --output table
```

Create a variable with the EC2 instance ID:

```shell
EC2_INSTANCE_ID="i-0a1234b5c6d7890e1"
```

Attach the new disk to the instance giving it a new device name, in this case `/dev/sdb`:

```shell
aws ec2 attach-volume --device /dev/sdb \
                      --instance-id "$EC2_INSTANCE_ID" \
                      --volume-id "$VOLUME_ID"
```

(you cannot specify `/dev/nvme1` as the next disk you see on Nitro VMs but if you specify `/dev/sdb` then it will
appear as `/dev/nvme1n1` anyway)

### Partition and Format the new disk

Inside the VM - follow the [Disk Management](disk.md) commands.

See if the new disk is available:

```shell
cat /proc/partitions
```

If you can't see it yet, run `partprobe`:

```shell
sudo partprobe
```

and then repeat the above `cat /proc/partitions` (it has also appeared after a few seconds on EC2 without this)

Create a new GPT partition table on the new disk:

```shell
sudo parted /dev/nvme1n1 --script mklabel gpt
```

Create a new partition that spans the entire disk:

```shell
sudo parted /dev/nvme1n1 --script mkpart primary 0% 100%
```

See the new partition:

```shell
cat /proc/partitions
```

Format the partition with XFS:

```shell
sudo mkfs.xfs /dev/nvme1n1p1
```

Verify the new formatting:

```shell
lsblk -f /dev/nvme1n1
```

### Mount the new volume by unchanging UUID for maximum stability

Since device numbers can change on rare occasion, find and use the UUID instead:

```shell
lsblk -o NAME,UUID
```

Edit `/etc/fstab`:

```shell
sudo vi /etc/fstab
```

and add a line like this, substituting the UUID from the above commands:

```shell
UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx /tmp xfs defaults,nofail 0 2
```

If the mount point is `/tmp` make sure you shut down any processes that might be using it first like
[Informatica](informatica.md) agent.

Then mount it using this short form of the `mount` command which tests the fstab at the same time:

```shell
sudo mount /tmp
```

```shell
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
```

```shell
sudo systemctl daemon-reload
```

Check new mounted partition and space is available:

```shell
df -Th /tmp
```

If you've just mounted a new `/tmp` make sure to set a sticky bit and world writable permissions for people and apps
to be able to use it:

```shell
sudo chmod 1777 /tmp
```

Start back up any processes that you shut down before mounting the disk.

## Resize an EC2 EBS volume

<https://docs.aws.amazon.com/ebs/latest/userguide/recognize-expanded-volume-linux.html>

Check the partition sizes by running this inside the EC2 VM shell:

```shell
lsblk
```

List EC2 EBS volumes using script in [DevOps-Bash-tools](devops-bash-tools.md) repo:

```shell
aws_ec2_ebs_volumes.sh
```

or find it in the AWS Console UI:

```shell
open "https://$AWS_DEFAULT_REGION.console.aws.amazon.com/ec2/home?region=$AWS_DEFAULT_REGION#Volumes:"
```

### Create a snapshot of the volume using its ID

Using script in [DevOps-Bash-tools](devops-bash-tools.md) repo:

```shell
aws_ec2_ebs_create_snapshot_and_wait.sh "$volume_id" "before root partition expansion"
```

(this script automatically determines and prefixes the name of the EC2 instance to the description)

or manually create and keep checking for completion:

```shell
aws ec2 create-snapshot --volume-id "$volume_id" --description "myvm: before root partition expansion"
```

The snapshot may take a while. Watch its progress at in the AWS Console UI here:

```shell
open "https://$AWS_DEFAULT_REGION.console.aws.amazon.com/ec2/home?region=$AWS_DEFAULT_REGION#Snapshots:"
```

or check for pending snapshots using AWS CLI:

```shell
aws ec2 describe-snapshots --query 'Snapshots[?State==`pending`].[SnapshotId,VolumeId,Description,State]' --output table
```

### Increase the size of the EBS volume

After the snapshot above is complete, run this script from [DevOps-Bash-tools](devops-bash-tools.md) repo:

```shell
aws_ec2_ebs_resize_and_wait.sh "$volume_id" "$size_in_gb"
```

or manually:

```shell
aws ec2 modify-volume --volume-id "$voume_id" --size "$size_in_gb"
```

and then repeatedly manually monitor the modification:

```shell
aws ec2 describe-volumes-modifications --volume-ids "$volume_id"
```

### Inside the EC2 VM - grow the partition and extend the filesystem

Double check which partition you want to enlarge by running this inside the EC2 VM shell:

```shell
lsblk
```

If the partition is number 4, then

```shell
sudo growpart /dev/nvme0n1 4
```

output should look like this:

```none
CHANGED: partition=4 start=1437696 old: size=417992671 end=419430366 new: size=627707871 end=629145566
```

verify the new size:

```shell
lsblk
```

Check the filesystem sizes and types:

```shell
df -hT
```

If it's Ext4, extend the filesystem like so:

```shell
sudo resize2fs /dev/nvme0n1p4
```

If it's XFS, extend the filesystem like so, in this case for the `/` root filesystem:

```shell
sudo xfs_growfs -d /
```

output should look like this:

```none
meta-data=/dev/nvme0n1p4         isize=512    agcount=86, agsize=610431 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=52249083, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 52249083 to 78463483
```

Verify the new filesystem size:

```shell
df -hT
```

## Remove an EC2 EBS volume from a live running instance

This is only for non-root volumes.

For example if you want to replace the `/tmp` disk with a smaller one now that data migration is complete.

**IMPORTANT: First shut down any software in the VM using the volume to avoid data corruption**

Inside the VM, unmount the volume, eg:

```shell
umount /tmp
```

If you get an error like:

```none
umount: /tmp: target is busy.
```

check:

```shell
lsof /tmp
```

or

```shell
fuser -mv /tmp
```

and kill those processes or ask users to log out if it's their shell session holding it.

If there is nothing left except:

```none
                     USER        PID ACCESS COMMAND
/tmp:                root     kernel mount  /tmp
```

You may have to reboot the VM - in which case remove or comment out the disk's mount point entry eg.
entry in this case from `/etc/fstab` first to prevent it having a possible boot time error.

You can do the detachment but the volume will still be visible in an `ls -l /tmp` and may require a reboot to clear
the state and connection to the EBS volume.

**WARNING: do not reboot the EC2 instance without commenting out the disk mount or setting the `nofail` option**

Otherwise you will be forced to do a disk mount recovery using another EC2 instance as per the
[EC2 Disk Mount Recovery](#ec2-disk-mount-recovery) procedure from the troubleshooting section.

If you do that beware that a Reboot instance may not succeed and you may need a `Force Instance Stop` cold shutdown and
startup to clear the state as a regular Reboot may get stuck starting up before SSH comes up to do anything.

From [DevOps-Bash-tools](devops-bash-tools.md) list instances and their EBS volumes:

```shell
aws_ec2_ebs_volumes.sh
```

```shell
aws ec2 detach-volume --volume-id "$VOLUME_ID" --instance-id "$EC2_INSTANCE_ID" --device "$DEVICE"
```

List unattached EBS volumes:

```shell
aws ec2 describe-volumes --query 'Volumes[?Attachments==`[]`].[VolumeId]' --output table
```

Optionally deleted the EBS volume if you're 100% sure you don't need it any more:

```shell
aws ec2 delete-volume --volume-id "$VOLUME_ID"
```

## RDS - Relational Database Service

Hosted SQL RDBMS like [MySQL](mysql.md), [PostgreSQL](postgres.md), Microsoft SQL Server etc.

### List RDS instances

AWS CLI doesn't have a convenient short form for just listing instances, but you can get one like this:

```shell
aws rds describe-db-instances | jq -r '.DBInstances[].DBInstanceIdentifier'
```

with their statuses in a table:

```shell
aws rds describe-db-instances --query "DBInstances[*].[DBInstanceIdentifier,DBInstanceStatus]" --output table
```

(notice this is using AWS CLI query not `jq` - hence the different query string format)

### Reset DB master password

Using the name returned from above commands:

```shell
aws rds modify-db-instance \
    --db-instance-identifier "$RDS_INSTANCE" \
    --master-user-password "MyNewVerySecurePassword"
```

## Troubleshooting

### EC2 VM becomes unresponsive and cannot SSH under high loads

Make sure you are not using T-series (T3 / T2) **burstable** general purpose instance types.

Change to another instance type if you are.

### RDS Write Stops Working due to Status `Storage Full`

When `Status` becomes `Storage Full` on the RDS home page the DB instance writes stop working due to no space to
write DB redo logs for ACID compliance. Reads may still work during this time.

Solution: Ensure `Enable storage autoscaling` is ticked and modify the instance to increase the
`Maximum Storage Threshold` by a reasonable amount, no less than 20%.

### EKS Spot - App fails to connect to DB due to race condition with Vault pod not being up yet

After EKS Spot pod migrations, the app pod sometimes comes up before the [Vault](vault.md) pod comes up so its
attempt to get the DB password from Vault fails and results in a blank DB password and later DB connection error.

In a Python Django app it may remain up but not functioning and its logs may contain Python tracebacks like this:

```Python
MySQldb._exceptions.OperationalError: (1045, "Access denied for user 'myuser'@'x.x.x.x' (using password: YES)")
```

#### Quick workaround

Restart the app deployment to restart the pod after the Vault pod has come up so that the
pod re-fetches the correct DB password from Vault.

```shell
kubectl rollout restart deployment <app>
```

#### Solutions

1. Create an init container to accurately test for Vault availability before allowing the app pod to come up
   1. This can test Vault availability
   1. It can fetch DB password similar to what the app container does
   1. It can test that the fetched DB password actually works using a test connection to the DB
1. The App itself could crash upon startup detection that the DB connection fails to cause the pod to crash and
   auto-restart until the DB password is fetched and connected successfully
   1. The DB connection and implicitly the Vault password load could be tested by the entrypoint trying to connect
      to the DB before starting the app

### EC2 Disk Mount Recovery

This is sometimes necessary when a Linux VM isn't coming up due to some disk changes such as detaching and deleting a
volume that is still in `/etc/fstab` or some other configuration imperfection that is preventing the boot process from
completing to give you SSH access.

#### Solution

Use another EC2 instance in the same Availability Zone as the problematic VM which owns the disk where the EBS
volume is physically located.

1. Shut down the problem instance which isn't booting.
1. Optional: mark the instance with tags `Name1` = `Problem` to make it easier to find
1. Detach the EBS volume from the problem instance
1. Find the volume (optionally using the `Problem` search in the list of EBS volumes)
1. Attach the EBS volume to your debug EC2 instance in the same Availabilty Zone as device `/dev/sdf`
1. On the debug instance:

Find the new disk. It's usually the largest partition on the new disk

```shell
cat /proc/mounts
```

Mount it:

```shell
mount /dev/xvdf4 /mnt
```

Edit the fstab:

```shell
sudo vi /mnt/etc/fstab
```

Add the `nofail` option to all disk lines mount options 4th field to ensure the Linux OS comes up even if it can't
find a disk (because for example you've detached it to replace it with a different EBS volume):

The lines should end up looking like this:

```shell
UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx       /       xfs     defaults,nofail        0       0
UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx       /tmp    xfs     defaults,nofail        0       2
UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx       /boot   xfs     defaults,nofail        0       0
UUID=xxxx-xxxx                              /boot/efi   vfat    defaults,uid=0,gid=0,umask=077,shortname=winnt,nofail  0       2
```

After editing and saving the `/etc/fstab` file, unmount the recovery disk:

```shell
sudo umount /mnt
```

7. Detach the volume from the debug instance
1. Attach the volume to the original instance
1. Start the original instance which should now come up
1. Remove the `Problem` tag from the volume

**Partial port from private Knowledge Base page 2012+**
