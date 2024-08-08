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


## EC2 Instances

<http://aws.amazon.com/ec2/instance-types/>

<https://instances.vantage.sh/>

<https://aws.amazon.com/ec2/pricing/on-demand/>

DO NOT USE T-series (T3 / T2) **burstable** general instances types for anything besides your own personal PoC.

They can seize up under heavy load and are not recommended for any production workloads.

## Add an EC2 EBS volume

This can also be useful for temporary space increases, eg. add a big `/tmp` partition to allow some
migration loads in an [Informatica](informatica.md) agent, which can be removed later.

(since you cannot shrink partitions later if you enlarge them instead)

### Create EC2 EBS volume

Create an EC2 EBS volume of 500Gb in the eu-west-1a zone where the VM is:

```shell
AVAILABILITY_ZONE=eu-west-1a  # make sure this is same Availability Zone as the VM you want to attach it to

REGION="${AVAILABILITY_ZONE%?}"  # auto-infer the region by removing last character

aws ec2 create-volume \
    --size 500 \
    --region "$REGION" \
    --availability-zone "$AVAILABILITY_ZONE" \
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

Name the new volume so you know what is it when you look at it in future in the UI:

```shell
aws ec2 create-tags \
  --resources vol-007e4d5f88a46fb6f \
  --tags Key=Name,Value="dev-secure-agent-tmp"
```

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
aws ec2 attach-volume --device /dev/sdb \
                      --instance-id i-028fbf0c954ca82c7 \
                      --volume-id vol-007e4d5f88a46fb6f
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

Add it to `/etc/fstab` with a line like this, substituting the UUID from the above commands:

```shell
UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx /tmp xfs defaults 0 2
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

If it's XFS, extend the filesystem like so, in this case for the `/` root filesystem:

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

## Troubleshooting

### EC2 VM becomes unresponsive and cannot SSH under high loads

Make sure you are not using T-series (T3 / T2) **burstable** general purpose instance types.

Change to another instance type if you are.

###### Partial port from private Knowledge Base page 2012+
