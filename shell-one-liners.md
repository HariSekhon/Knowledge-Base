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
  - [Use Process Outputs Like Files](#use-process-outputs-like-files)
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
  - [Deduplicate Lines Using Awk](#deduplicate-lines-using-awk)
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

### Use Process Outputs Like Files

Access command outputs like files without using temp files.

The `<(...)` Bash syntax returns a temporary process file descriptor.

```text
some_command_expecting_a_file <(some_command_printing_to_stdout)
```

For example, compare two unsorted files without using temp files:

```shell
diff <(sort "$file1") <(sort "$file2")
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

### Deduplicate Lines Using Awk

If you have an input such as `<id> <content>` and want to deduplicate lines with the same ID by comparing the
first field, this is simple and powerful:

```shell
awk '!seen[$1]++'
```

You could of course deduplicate entire lines by just using `$0` as the associative array index:

```shell
awk '!seen[$0]++'
```

This uses the trick of populating an associative array using the field as the index and an `++` incrementer to just
create a value (1) to signal existance.

This follows standard computer science post-increment behaviour such that the first time it does this it returns nothing
since it didn't already exist and so the leading negation will allow the first instance through and print the line, but
subsequent instances where the value used for the index, `$1` for the ID field or the `$0` for the entire line,
actually returns an existing value from the last time that index value was seen and incremented into existence, it'll
match the negation and suppress those lines.

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

### Find Lines in a File not present in Other Files

Same as above just `grep -v` it:

```shell
grep -Fvxhf "$patterns_file" "$file1" "$file2" ...
```

**Example:**

I use this to find tracks in my [Spotify playlists](https://github.com/HariSekhon/Spotify-Playlists) that are not in
Spotify's `Like Songs` so I can quickly add them programmatically.

The `spotify/<files>` paths contain the downloaded track URIs, while the top level contains the
`Artist - Track` human readable downloads.

Find the URIs in a playlist that are not in the `Liked Songs`, which we use as the first arg, the patterns file:

```shell
grep -Fvxhf "spotify/Liked Songs" "spotify/$playlist"
```

and then pipe it to one of my many spotify scripts that can be found in [DevOps-Bash-tools](devops-bash-tools.md)
to programmatically 'Like' all of the straggers found.

First exclude local tracks which can't be `Liked`, and then pipe it to `spotify_uri_to_name.sh` to see the track names:

```shell
grep -Fvxhf "spotify/Liked Songs" "spotify/Smooth Hip-Hop 😎" |
grep -v "^spotify:local:" |
spotify_uri_to_name.sh
```

Once you've reviewed the songs to be Liked, pipe it to `spotify_set_tracks_uri_to_liked.sh` instead of
`spotify_uri_to_name.sh`, to actually programmatically `Like` them:

```shell
grep -Fvxhf "spotify/Liked Songs" "spotify/Smooth Hip-Hop 😎" |
grep -v "^spotify:local:" |
spotify_set_tracks_uri_to_liked.sh
```

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
