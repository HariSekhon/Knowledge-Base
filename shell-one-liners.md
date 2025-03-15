# Shell One Liners

Because who doesn't love shell tricks.

For far more serious tricks see the [DevOps-Bash-tools](devops-bash-tools.md) repo.

<!-- INDEX_START -->

- [System & Shell](#system--shell)
  - [Show CPU Cores](#show-cpu-cores)
  - [Show your $PATH entries one per line](#show-your-path-entries-one-per-line)
  - [Log all Commands in a Shell Session](#log-all-commands-in-a-shell-session)
  - [Create a Ram Disk](#create-a-ram-disk)
- [Dates](#dates)
  - [Get Current Epoch](#get-current-epoch)
  - [Convert Epoch Seconds to Human Readable Date](#convert-epoch-seconds-to-human-readable-date)
- [Files & Strings](#files--strings)
  - [Generate ASCII Art](#generate-ascii-art)
  - [Reverse a String](#reverse-a-string)
  - [Reverse the lines of a file](#reverse-the-lines-of-a-file)
  - [Shuffle Lines of a File](#shuffle-lines-of-a-file)
  - [Split Big File into 10MB chunks](#split-big-file-into-10mb-chunks)
  - [Show Files Open by a Process](#show-files-open-by-a-process)
  - [Generate a Random Password](#generate-a-random-password)
  - [Base64 Secrets to avoid funny characters](#base64-secrets-to-avoid-funny-characters)
- [Network](#network)
  - [Listen Open TCP/UDP Ports](#listen-open-tcpudp-ports)
  - [Check if a Port is Open](#check-if-a-port-is-open)
  - [Get your Public IP Address](#get-your-public-ip-address)
  - [Quickly Serve Local Files over HTTP](#quickly-serve-local-files-over-http)
  - [Top for Network Processes](#top-for-network-processes)
- [Disk](#disk)
  - [Find Biggest Files Taking Up Space](#find-biggest-files-taking-up-space)
- [Mac](#mac)
  - [Use GNU CoreUtils](#use-gnu-coreutils)
  - [Mask BSD Core Utils with GNU Core Utils](#mask-bsd-core-utils-with-gnu-core-utils)

<!-- INDEX_END -->

## System & Shell

### Show CPU Cores

```shell
nproc
```

### Show your $PATH entries one per line

```shell
echo $PATH | tr ':' '\n'
```

### Log all Commands in a Shell Session

```shell
script logfile.txt
```

### Create a Ram Disk

```shell
mkdir /tmp/ramdisk && mount -t tmpfs -o size=512m tmpfs /tmp/ramdisk
```

## Dates

### Get Current Epoch

Seconds since Unix birth 1st Jan 1970:

```shell
date '+%s'
```

### Convert Epoch Seconds to Human Readable Date

```shell
date -d @1741942727
```

## Files & Strings

### Generate ASCII Art

```shell
brew install figlet
```

```shell
figlet "Hari Sekhon"
```

```text
  _   _            _   ____       _    _
 | | | | __ _ _ __(_) / ___|  ___| | _| |__   ___  _ __
 | |_| |/ _` | '__| | \___ \ / _ \ |/ / '_ \ / _ \| '_ \
 |  _  | (_| | |  | |  ___) |  __/   <| | | | (_) | | | |
 |_| |_|\__,_|_|  |_| |____/ \___|_|\_\_| |_|\___/|_| |_|
```

### Reverse a String

```shell
echo "testing" | rev
```

### Reverse the lines of a file

More portable than `tac`:

```shell
tail -r
```

### Shuffle Lines of a File

```shell
shuf file.txt
```

### Split Big File into 10MB chunks

```shell
split -b 10M bigfile split_
```

### Show Files Open by a Process

```shell
lsof -p "$(pidof bash)"
```

### Generate a Random Password

```shell
brew install pwgen
```

Generates a bunch of passwords to choose from

```shell
pwgen
```

Or generate a single one of length 20 chars and avoid any ambiguous chars:

```shell
pwgen -1 -s -B 20
```

### Base64 Secrets to avoid funny characters

Useful in things like [GitHub Actions CI/CD](github-actions.md).

```shell
base64
```

use `--decode` switch instead of `-d` for better portability between your Mac and Linux:

```shell
base64 --decode
```

## Network

### Listen Open TCP/UDP Ports

```shell
netstat -lntpu
```

### Check if a Port is Open

```shell
nc -zv localhost 22
```

```text
localhost [127.0.0.1] 22 (ssh) open
```

### Get your Public IP Address

```shell
curl ifconfig.co
```

### Quickly Serve Local Files over HTTP

```shell
python3 -m http.server 8000
```

### Top for Network Processes

[:octocat: raboof/nethogs](https://github.com/raboof/nethogs)

```shell
brew install nethogs
```

```shell
sudo nethogs
```

## Disk

### Find Biggest Files Taking Up Space

This searches only the current directory and only on the current partition, not sub-mount-points.

```shell
du -max . | sort -k1n | tail -n 1000
```

See also for a GUI alternative:

- [Disk Inventory X](https://www.derlien.com/) - Mac
- [KDirStat](https://kdirstat.sourceforge.net/) - Linux
- [WinDirStat](https://windirstat.net/) - Windows

## Mac

### Use GNU CoreUtils

For cross-platform portability of your commands and scripts since GNU CoreUtils have better features than their BSD
counterparts, and less bugs in advanced usage in my experience.

```shell
brew install coreutils
```

This will install GNU Core Utils prefixed with `g` to not clash with the native BSD counterparts.

### Mask BSD Core Utils with GNU Core Utils

You can wrap them in functions (I do this in scripts and libraries eg. [DevOps-Bash-tools](devops-bash-tools.md):

```shell
grep(){
  command ggrep "$@"
}

sed(){
  command sed "$@"
}
```

Now when the script calls grep it gets the better functional version for cross-platform compatibility between Mac and
Linux.
