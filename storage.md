# Storage

<!-- INDEX_START -->

- [Disks](#disks)
  - [HDD - Hard Disk Drive](#hdd---hard-disk-drive)
  - [SSD - Sold State Drive](#ssd---sold-state-drive)
  - [SCSI](#scsi)
  - [SATA](#sata)
  - [IDE](#ide)
  - [Ram Disks](#ram-disks)
- [RAID](#raid)
  - [RAID Levels](#raid-levels)
  - [RAID 0 - striping across disks](#raid-0---striping-across-disks)
  - [RAID 1 - mirroring across 2 disks](#raid-1---mirroring-across-2-disks)
  - [RAID 4 - striping with parity on a single spare disk](#raid-4---striping-with-parity-on-a-single-spare-disk)
  - [RAID 5 - striping with distributed parity across N number of disks](#raid-5---striping-with-distributed-parity-across-n-number-of-disks)
  - [RAID 6 - striping with double distributed parity across N number of disks](#raid-6---striping-with-double-distributed-parity-across-n-number-of-disks)
  - [Nested RAID Levels](#nested-raid-levels)
  - [RAID 10 - RAID 0 striping over a collection of RAID 1 mirror arrays](#raid-10---raid-0-striping-over-a-collection-of-raid-1-mirror-arrays)
  - [RAID 01 - RAID 1 mirroring across two RAID 0 striped arrays](#raid-01---raid-1-mirroring-across-two-raid-0-striped-arrays)
  - [RAID 50 - RAID 0 striping on top of RAID 5 stripe arrays](#raid-50---raid-0-striping-on-top-of-raid-5-stripe-arrays)
  - [JBOD - Just a Bunch of Disks](#jbod---just-a-bunch-of-disks)
- [NAS - Network Attached Storage](#nas---network-attached-storage)
- [SAN - Storage Area Network](#san---storage-area-network)
- [SDS - Software Defined Storage](#sds---software-defined-storage)
- [MinIO](#minio)
  - [Docker Images](#docker-images)
- [Ceph](#ceph)
- [Hedvig](#hedvig)
- [Dell EqualLogic](#dell-equallogic)

<!-- INDEX_END -->

## Disks

### HDD - Hard Disk Drive

- spinning metal platters on which data is written by magnetic heads
- higher capacities than SSD disks
- cheaper but slower than SSD disks
- fine for sequential I/O
- poor for random I/O due to need for heads to move in/out on the circle of the spinning metal platters to seek data
- vulnerable to physical shocks such as dropping the disks breaking the somewhat delicate physical heads
- due to the slight physical inaccuracy of write heads on the platter the US DoD recommends 7 passes to secure delete
  data on the disk (this takes a long time to do)

### SSD - Sold State Drive

- no moving parts
- fast
- more expensive
- smaller storage capacities than HDD disks
- better for Random I/O due to no physical head seek time
- writes wear out the cells, less write lifespan than HDD
- only requires 1 pass to secure delete data (do not run multiple pass delete data, you will wear out the cells)

### SCSI

SCSI disks are enterprise class HDD disks that often come in higher RPM rotation variants such as 10k or 15k rotations
per minute to be able to read and write data faster.

### SATA

Consumer grade disks that are cheaper HDD disks than SCSI, and often come in more reasonable 7200rpm rotational speeds.

### IDE

Old consumer grade disks - usually in 7200pm or sometimes even slower 5400rpm.

Do not buy these any more.

Usually only laptops come with such slow 5400rpm disks in smaller 2.5inch size formats.

Modern laptops like Macbook Pros will be using SSDs.

### Ram Disks

Fake disks by mapping a portion of RAM as though it is a real disk.

Very fast to read/write from but expensive as RAM is less abundant than disk, and with zero data retention - all
data is lost upon any reboot.

Useful for temporary data only to speed up applications in specific [Performance](performance.md) critical scenarios.

## RAID

Redundant Array of Inexpensive Disks.

Usually used to improve performance and / or data safety redundancy by using multiple disks as a single volume.

Can be achieved with specialist hardware RAID cards or using software such as Linux
[mdadm](https://en.wikipedia.org/wiki/Mdadm).

In servers usually [hardware](hardware.md) RAID is used for reasons of performance offload and to hide the configuration
from the operating system and therefore any chance of administrative software mistakes leading to data loss.

Hardware RAID usually has local on-card cache and BBU - Battery Backup Unit - which is a battery that maintains the
data in cache in event of a power outage taking down the server.
This allows for the data in the cache to not be lost, and flushed to disk upon next power up.

Using RAID in 'write-through' mode will have severe performance degradation compared to the smoothing out of disk
I/O patterns that the 'write-back' cache allows which buffers writes to optimize their I/O patterns.
This is a big performance advantage of hardware RAID and why nearly all corporate and enterprise RAID is hardware
RAID.

Hardware RAID is usually configured just after BIOS, but can also be monitored and managed using hardware vendor
supplied software.

[Nagios Plugins](nagios.md) exists for many popular hardware RAID software management tools.

Hardware RAID cards are local to the server.

Other hardware RAID may be networked to one or more servers via a
[NAS](#nas---network-attached-storage)
or [SAN](#san---storage-area-network).

### RAID Levels

These are the different configurations of using multiple disks.

### RAID 0 - striping across disks

- no redundancy
- do not use this for anything that is not temporary disposable data

### RAID 1 - mirroring across 2 disks

- redundancy to cover the loss of 1 disk and keep working
- overhead is 100%
- as good performance as a single disk
- I ran 1.5TB Oracle databases with data files spread across many RAID 1 mounts because Random I/O performance was
  better than any other disk array

### RAID 4 - striping with parity on a single spare disk

- redundancy to survive and replace a single failed disk
- minimum of 3 disks (2 for data + 1 for parity)
- overhead is 1/N disks
- parity information is written on a single disk to allow to calculate the missing bits on any one
  failed disk
- parity disk becomes a bottleneck
- obsolete because RAID 5 has better performance for the same number of disks with same level of fault tolerance

### RAID 5 - striping with distributed parity across N number of disks

- redundancy to survive and replace a single failed disk
- minimum of 3 disks
- overhead is 1/N disks
- parity information is striped across disks for better performance than RAID 4
  any one failed disk
- cheaper redundancy than RAID 1 but...
- poor performance
- rebuilds are very expensive and time consuming, during which performance will be even more degraded
- probability of a disk failure goes up as the array gets bigger

### RAID 6 - striping with double distributed parity across N number of disks

- redundancy to survive and replace up to two failed disks
- overhead is 2/N disks - costs a bit more disk space than RAID 5 but not as much as RAID 1 or 10
- minimum of 3 disks
- two layers of parity is striped across disks to allow to allow to calculate the missing
  bits on any two failed disks
- more expensive than RAID 5 but less than RAID 1
- poor performance like RAID 5
- probability of a disk failure goes up as the array gets bigger
- rebuilds are very expensive and time consuming, during which performance will be even more degraded
- better suited to larger arrays since it can survive two simultaneous disk failures

### Nested RAID Levels

Combining one or more RAID levels together, creating a RAID array using other RAID arrays as though they are a
single disk.

RAID 10, Raid 01, and Raid 50 below are all examples of this:

### RAID 10 - RAID 0 striping over a collection of RAID 1 mirror arrays

- overhead is 100% like RAID 1
- redundancy to survive loss of one disk in each of the RAID 1 mirrors
- on the low odds of two disks in the same RAID 1 mirror failing, the entire volume's data would be lost
- not to be confused with the inverse RAID level below

### RAID 01 - RAID 1 mirroring across two RAID 0 striped arrays

- overhead is 100% like RAID 1
- performance is similar to RAID 10 but...
- much less fault tolerant than RAID 10
- can only survive a single disk failure
  - because one disk failure will lose all the data on its RAID 0 array
  - a second disk failure on the other RAID 0 array will result in complete data loss as both RAID 0 arrays are then
    lost
- do not use this RAID level

### RAID 50 - RAID 0 striping on top of RAID 5 stripe arrays

- requires minimum of 6 disks (3 for each RAID 5 array, minimum 2 arrays to stripe over)
- better performance and faster rebuilds than RAID 5 or RAID 6
  - performance does not degrade as much as in a RAID 5 because a single disk failure only affects one of the
    underlying RAID 5 arrays
- slightly better data protection than RAID 5 because disks can fail in different underlying RAID 5 arrays
- but costs more disk space than RAID 5 or 6

### JBOD - Just a Bunch of Disks

- individually used disks
- best for Random I/O performance, especially on [HDD](#hdd---hard-disk-drive) disks

## NAS - Network Attached Storage

Storage, usually RAID arrays (but can be individual disks too), networked to one or more servers over TCP/IP networking.

They are shared using network filesystems like NFS for unix-based systems like [Linux](linux.md)
or SMB/CIFS for[Windows](windows.md).

These network file systems allow multiple servers to access and share the same storage volume.

## SAN - Storage Area Network

RAID arrays networked to servers as block devices, usually using fiber channel, fast and expensive, or iSCSI
which is slower but cheaper and uses a protocol on top of TCP/IP networking.

SANs are usually expensive enterprise appliances, which is why the industry has been moving towards cheaper and
more flexible software based solutions.

## SDS - Software Defined Storage

<https://en.wikipedia.org/wiki/Software-defined_storage>

<https://www.redhat.com/en/topics/data-storage/software-defined-storage>

<https://www.vmware.com/topics/software-defined-storage>

<https://www.purestorage.com/knowledge/what-is-software-defined-storage.html>

## MinIO

Open source blob storage software that is compatible with [AWS](aws.md) S3.

### Docker Images

Server image:

```none
minio/minio
```

Client image:

```none
minio/mc
```

Start a local test MinIO server in Docker:

```shell
docker run --rm -p 9000:9000 minio/minio server /data \
           -e MINIO_ACCESS_KEY=MyAccessKey \
           -e MINIO_SECRET_KEY=MySecretKey
```

Then browse to <http://docker:9000> for a nice MinIO web UI.

Get interactive shell with `mc` client:

```shell
docker run -ti --entrypoint=/bin/sh minio/mc
```

## Ceph

<https://ceph.io>

Open source distributed software storage.

- copy-on-write

## Hedvig

Notes from early 2015:

Proprietary storage based on Cassandra paradigms, by founder of Cassandra.

Last licensing price I knew was €500/TB perpetual license + 15% yearly support for upgrades + 24x7 support.

## Dell EqualLogic

iSCSI storage [SAN](#san---storage-area-network) appliance.

- Active / Passive controllers
- must reserve space for volume snapshots - minimum 5%, default 100%.
- thin provisioning
- deduplication technology
- no global Hot Spare Disks
  - each shelf requires its own spares, so the more shelves/volumes you have, the more
    wasted disks
  - 3Par by comparison uses every disk, therefore gets more I/O and faster rebuild times when failures occur
- can work around this by not using spares and just using RAID 6
- only 1 RAID level can be configured on an enclosure
- ok for sequential operations but...
- poor read latency with a consistently moderate I/O load
- 20 VMs on a PS400E low I/O can cause cumulative IOPS in a random pattern that degrade performance
- weak write caching also degrades performance
- snapshots are space hungry with 16MB chunk allocations, compared to more efficient EMC / NetApp
- replication inefficient with bandwidth
- CLI not that good, esp for automation
- can't combine PS5500E and PS5000X into one pool, so effectively get stuck with 2 smaller sans instead when trying
  to scale out.
- what happens if they don't make the same model of chassis when we want to expand?
- support was not that good. Run Diag. No idea what the problem is etc... sounds like typical Dell.

<!-- Can we hot add disk shelves? -->

- 6000E
  - 16 disks
  - RAID-5, 50 or 10
  - can mix sas 10/15K + sata
  - 4 x 1GB ports
  - auto-rebuild
  - RAID 5 will automatically assign 1 hot spare
  - 10 or 50 assign 2 hot spares
  - no native dedupe with 4/5/6000 models!
  - SanHQ monitoring software
  - NO JBOD, can't not have RAID on the array
  - Can't have separate JBOD disks in the array because of the single RAID level
  - Lead time 2 week delivery

**Ported from private Knowledge Base page 2010+ - worked on storage systems since 2005 but young guys don't document enough, so these are late notes**
