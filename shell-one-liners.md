# Shell One Liners

Because who doesn't love shell tricks.

For far more serious tricks see the [DevOps-Bash-tools](devops-bash-tools.md) repo.

<!-- INDEX_START -->

- [System & Shell](#system--shell)
  - [Show CPU Cores](#show-cpu-cores)
  - [Show your $PATH entries one per line](#show-your-path-entries-one-per-line)
  - [Log all Commands in a Shell Session](#log-all-commands-in-a-shell-session)
  - [List Your 100 Most Used Bash Commands](#list-your-100-most-used-bash-commands)
- [Processes](#processes)
  - [Find disowned processes owned by the init PID 1](#find-disowned-processes-owned-by-the-init-pid-1)
- [Dates](#dates)
  - [Get Current Epoch](#get-current-epoch)
  - [Convert Epoch Seconds to Human Readable Date](#convert-epoch-seconds-to-human-readable-date)
- [Files & Strings](#files--strings)
  - [Generate ASCII Art](#generate-ascii-art)
  - [Number Lines](#number-lines)
  - [Copy to Both Clipboard and Stdout simultaneously](#copy-to-both-clipboard-and-stdout-simultaneously)
  - [Squeeze Out Multiple Blank Lines](#squeeze-out-multiple-blank-lines)
  - [Reverse a String](#reverse-a-string)
  - [Reverse the lines of a file](#reverse-the-lines-of-a-file)
  - [Shuffle Lines of a File](#shuffle-lines-of-a-file)
  - [Split Big File into 10MB chunks](#split-big-file-into-10mb-chunks)
  - [Show Files Open by a Process](#show-files-open-by-a-process)
  - [Generate a Random Password](#generate-a-random-password)
  - [Base64 Secrets to avoid dodgy characters](#base64-secrets-to-avoid-dodgy-characters)
  - [Find Lines in a File present in Other Files](#find-lines-in-a-file-present-in-other-files)
- [Network](#network)
  - [Get Your Public IP Address](#get-your-public-ip-address)
  - [List Open TCP/UDP Ports](#list-open-tcpudp-ports)
  - [Check if a Port is Open](#check-if-a-port-is-open)
  - [Wait and Make Audible Bell Sound when a Host is Online](#wait-and-make-audible-bell-sound-when-a-host-is-online)
  - [Quickly Serve Local Files over HTTP](#quickly-serve-local-files-over-http)
  - [Top for Network Processes](#top-for-network-processes)
- [Disk](#disk)
  - [Find Biggest Files Taking Up Space](#find-biggest-files-taking-up-space)
  - [Create a Ram Disk](#create-a-ram-disk)
- [Mac](#mac)
  - [Use GNU CoreUtils](#use-gnu-coreutils)
  - [Mask BSD Core Utils with GNU Core Utils](#mask-bsd-core-utils-with-gnu-core-utils)
- [More Resources](#more-resources)

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

### List Your 100 Most Used Bash Commands

If your shell history is vanilla without timestamps:

```shell
history | awk '{ a[$2]++ } END { for(i in a) { print a[i] " " i } }' | sort -rn | head -n 100
```

If you're using timestamped shell history:

```shell
history | awk '{ a[$4]++ } END { for(i in a) { print a[i] " " i } }' | sort -rn | head -n 100
```

## Processes

### Find disowned processes owned by the init PID 1

```shell
 ps -ef | awk '$3 == 1 {print}'
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

### Number Lines

```shell
cat -n
```

```shell
less -N
```

```shell
nl
```

### Copy to Both Clipboard and Stdout simultaneously

`tee` to both a command to copy to clipboard as well as stdout.

Use `/dev/stdout` for further pipeline processing, not `/dev/tty`, as the latter outputs directly to the terminal.

The `copy_to_clipboard.sh` script from [DevOps-Bash-tools](devops-bash-tools.md) works on both Linux and Mac:

```shell
echo test | tee >("copy_to_clipboard.sh") /dev/stdout
```

### Squeeze Out Multiple Blank Lines

Useful to remove multiple blank lines between paragraphs in text replacements like
[shorten_text_selection.scpt](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/applescript/shorten_text_selection.scpt).

```shell
cat -s
```

### Reverse a String

```shell
echo "testing" | rev
```

### Reverse the lines of a file

More portable than `tac`:

```shell
tail -r file.txt
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

### Base64 Secrets to avoid dodgy characters

Useful in things like [GitHub Actions CI/CD](github-actions.md) for safer character handling.

```shell
base64
```

use `--decode` switch instead of `-d` for better portability between your Mac and Linux:

```shell
base64 --decode
```

### Find Lines in a File present in Other Files

I used this to find Spotify tracks that are in one of my blacklists
as I download all my playlists to Git revision controlled backups and use scripts to remove songs I've already checked
([HariSekhon/Spotify-Playlists](https://github.com/HariSekhon/Spotify-Playlists)).

- `-F` - for fixed string
- `-x` - to ensure we match whole lines
- `-h` - to not return the prefix of "$fileN: " before each line printed as we just want the line itself
- `-f` - take the lines as patterns from the first file and look for them in all subsequent file arguments

```shell
grep -Fxhf "$patterns_file" "$file1" "$file2" ...
```

Pipe to `sort -u` to deduplicate if something is found in more than one file.

## Network

### Get Your Public IP Address

These tricks use publicly available services to return what your actual public IP address is after all NAT translation
ie. what your IP is actually seen as by other computers on the internet.

```shell
curl ifconfig.co
```

```shell
curl checkip.amazonaws.com
```

or using just DNS:

```shell
dig +short myip.opendns.com @resolver1.opendns.com
```

Websites that return the IP without a trailing newline:

```shell
curl ifconfig.me
```

```shell
curl https://ipinfo.io
```

```shell
curl ident.me
```

Programmatically useful with more details returned in JSON:

```shell
curl ifconfig.co/json
```

### List Open TCP/UDP Ports

Show your local listening ports:

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

### Wait and Make Audible Bell Sound when a Host is Online

Checks every 3 seconds, makes an audible bell, and exits when a host comes online:

```shell
ping -i 3 -o -a "$host"
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

### Create a Ram Disk

```shell
mkdir /tmp/ramdisk &&
mount -t tmpfs tmpfs /tmp/ramdisk -o size=1024m
```

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

## More Resources

- [Bash](bash.md) page
- [DevOps-Bash-tools](devops-bash-tools.md)
- [CommandLineFu](https://www.commandlinefu.com/)
- [ShellDorado](http://www.shelldorado.com/)
- [Bash Guide](https://mywiki.wooledge.org/BashGuide)
