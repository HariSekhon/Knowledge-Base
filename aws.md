# AWS - Amazon Web Services

NOT PORTED YET

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


## Add an EC2 EBS volume

This can also be useful for temporary space increases, eg. add a big `/tmp` partition to allow some
migration loads in an [Informatica](informatica.md) agent, which can be removed later.

(since you cannot shrink partitions later if you enlarge them instead)

### Create EC2 EBS volume

Create an EC2 EBS volume of 500Gb in the eu-west-1a zone where the VM is:

```shell
AZ=eu-west-1a  # make sure this is same as the VM you want to attach to

REGION="${AZ:0:-1}"  # auto-infer the region by removing last character

aws ec2 create-volume \
    --size 500 \
    --region eu-west-1 \
    --availability-zone eu-west-1a \
    --volume-type gp3
```

output:

```
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

Note the `VolumeId` field, you'll need it for the attach command further down.


### Attach the new volume to the EC2 instance

This can be done with zero downtime while the VM is running.

Look up the EC2 instance ID of the VM you want to attach it to:

```shell
aws ec2 describe-instances \
    --query 'Reservations[*].Instances[*].[InstanceId, Tags[?Key==`Name`].Value | [0]]' \
    --output table
```

Use the `VolumeId` you saw from your volume creation output further above combined with the VM instance id you
see in the immediate above command, giving it a new device name:

```shell
aws ec2 attach-volume --device /dev/sdb --instance-id i-028fbf0c954ca82c7 --volume-id vol-007e4d5f88a46fb6f
```

(you cannot specify `/dev/nvme1` as the next disk you see on Nitro VMs but if you specify `/dev/sdb` then it will
appear as `/dev/nvme1n1` anyway)

### Partition and Format the new disk

Inside the VM - see if the new disk is available:

```shell
cat /proc/partitions
```

```
major minor  #blocks  name

 259        0  314572800 nvme0n1
 259        1       1024 nvme0n1p1
 259        2     204800 nvme0n1p2
 259        3     512000 nvme0n1p3
 259        4  313853935 nvme0n1p4
 259        5  524288000 nvme1n1  # <-- this is the new disk which has no partitions yet
```

If you can't see it yet, run `partprobe`

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

```
...
 259        7  524285952 nvme1n1p1
```

Format the partition with either:

ext4:

```shell
sudo mkfs.ext4 /dev/nvme1n1p1
```

or xfs:

```shell
sudo mkfs.xfs /dev/nvme1n1p1
```

Verify the new formatting:

```shell
lsblk -f /dev/nvme1n1
```

or

```shell
sudo blkid /dev/nvme1n1p1
```

### Mount the new volume by unchanging UUID for maximum stability

Since partition numbers can change, find the UUID using one of these commands:

I like this one best for scripting due to its simple 2 column output format which is easy to parse:

```shell
lsblk -o NAME,UUID
```

this one requires root permission:

```shell
sudo blkid
```

```shell
ls -l /dev/disk/by-uuid/
```

```shell
findmnt -o TARGET,UUID
```

requires root:

```shell
sudo fdisk -l
```

otherwise gets this error as regular user:

```
fdisk: cannot open /dev/nvme0n1: Permission denied
```

requires root or returns blank:

```shell
sudo parted -l
```

Add it to `/etc/fstab` with a line like this, substituting the UUID from the above commands:

```shell
UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx /mnt/newdisk xfs defaults 0 2
```

Create the mount point if it doesn't already exist:

```shell
mkdir -p /mnt/newdisk
```

Then mount it using this short form which tests the fstab at the same time:

```shell
mount /mnt/newdisk
```

## Resize an EC2 EBS volume

<https://docs.aws.amazon.com/ebs/latest/userguide/recognize-expanded-volume-linux.html>

Check the partition sizes in the EC2 VM:

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

If the partition is number 4, then

```shell
sudo growpart /dev/nvme0n1 4
```

output should look like this:

```
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

If it's XFS, extend the filesystem like so, in this case the `/` root filesystem:

```shell
sudo xfs_growfs -d /
```

output should look like this:

```
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

###### Partial port from private Knowledge Base page 2012+
