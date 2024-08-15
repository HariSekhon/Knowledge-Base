# Bash - Shell & Scripting

This is the standard modern shell. You should always script in Bash for portability.

It's a rare exception where you'd need to script in the original Bourne shell
(bootstrapping [Alpine](https://github.com/HariSekhon/Dockerfiles/blob/master/alpine-dev/Dockerfile)
is one of the few use cases for that).

## Index

- [Core Reading Material](#core-reading-material)
- [Advanced Library of Scripts](#advanced-library-of-scripts)
- [Perl, Awk, Sed](#perl-awk-sed)
- [Other Cool Resources](#other-cool-resources)
- [Commands](#commands)
- [Tips & Tricks](#tips-tricks)
- [Debugging](#debugging)
- [Style Guide](#style-guide)

## Core Reading Material

### Books:

- [Classic Shell Scripting](https://www.amazon.com/Classic-Shell-Scripting-Arnold-Robbins/dp/0596005954)
- [Bash CookBook](https://www.amazon.com/bash-Cookbook-Solutions-Examples-Users/dp/1491975334/)
- [Unix Power Tools](https://www.amazon.com/Power-Tools-Third-Shelley-Powers/dp/0596003307/)

### Free:

- [Advanced Bash Scripting Guide (HTML)](https://tldp.org/LDP/abs/html/)
- [Advanced Bash Scripting Guide (PDF)](https://tldp.org/LDP/abs/abs-guide.pdf)

## Advanced Library of Scripts

1000+ DevOps Bash Scripts

AWS, GCP, Kubernetes, Docker, CI/CD, APIs, SQL, PostgreSQL, MySQL, Hive, Impala, Kafka,
Hadoop, Jenkins, GitHub, GitLab, BitBucket, Azure DevOps, TeamCity, Spotify, MP3, LDAP, Code/Build Linting, pkg mgmt
for Linux, Mac, Python, Perl, Ruby, NodeJS, Golang etc.

Also contains advanced configs. eg: `.bashrc`, `.vimrc`, `.gitconfig`, `.
screenrc`, `.tmux.conf` etc.

https://github.com/HariSekhon/DevOps-Bash-tools

This is more than the manuals above, you could study this repo for years, or just run its scripts today to save you
the time.

## Perl, Awk, Sed

You need to learn at least some basic one-liners of [Perl](perl.md), Awk and Sed to be proficient in shell scripting.

You also need to learn [Regex](regex.md) to use these tools effectively.

## Other Cool Resources

- [Greg's Wiki - Wooledge.org](https://mywiki.wooledge.org) - the grumpy old greycat guy on IRC in the 2000s would
  often send noobs to his classic resource
  - [Bash Guide](https://mywiki.wooledge.org/BashGuide)
  - [Bash FAQ](https://mywiki.wooledge.org/BashFAQ)
  - [Bash Pitfalls](https://mywiki.wooledge.org/BashPitfalls)
  - [Bash Programming](https://mywiki.wooledge.org/BashProgramming)
  - [Bash Reference Sheet](https://mywiki.wooledge.org/BashSheet)
- [Shelldorado](http://www.shelldorado.com/)
- [explainshell.com](https://explainshell.com) - explains a bash shell statement
- [Reddit - r/bash](https://www.reddit.com/r/bash/)
- [ShellCheck](https://www.shellcheck.net/) - online version of the popular `shellcheck` command line tool to find bugs and improvements to make in shell code

## Commands

See Also:

- [Disk Management](disk.md) commands

Some less well known commands to remember:

| Command                                 | Description                                                                                                                                                                                                |
|-----------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `cmp`                                   | compare whether two files diff. Shorter than doing an `md5sum` on both (`md5` on Mac)                                                                                                                      |
| `comm`                                  | print or omit lines are common or unique between two files                                                                                                                                                 |
| `expand`                                | expands tabs to spaces                                                                                                                                                                                     |
| `unexpand`                              | converts spaces to tabs                                                                                                                                                                                    |
| `fmt`                                   |                                                                                                                                                                                                            |
| `join`                                  | join matching records from multiple files                                                                                                                                                                  |
| `logger`                                | sends messages to the system log ie. syslog `/var/log/messages`                                                                                                                                            |
| `mail`                                  | send email from the command line                                                                                                                                                                           |
| `whatis`/ `proppos` / `man -k`          | search for man pages containing the argument string                                                                                                                                                        |
| `command`                               | execute a binary from the path instead of a function of the same name                                                                                                                                      |
| `builtin`                               | execute a shell builtin instead of a function of the same name                                                                                                                                             |
| `dialog`                                | create an interactive curses menu                                                                                                                                                                          |
| `say`                                   | Mac command that speaks the words piped in. I use this to impress my kids by making the computers talk                                                                                                     |
| `type`                                  | Tells you what a command is, path to binary or shell builtin. `-P` returns only binary                                                                                                                     |
| `xev`                                   | Prints the keystrokes to the Linux X server GUI                                                                                                                                                            |
| `tail --follow=name --retry <filename>` | GNU tail can retry and continue following a file if it's renamed                                                                                                                                           |
| `split`                                 | Split a text file into smaller parts by lines or bytes. Useful for parallel data processing                                                                                                                |
| `csplit`                                | Split with context by splitting on pattern such as regex                                                                                                                                                   |
| `pr -m`                                 | Prints files into columns                                                                                                                                                                                  |
| `column -t`                             | Prints stdin into aligned columns to tidy up output (used in various scripts in [DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools)                                                       |
| `paste`                                 | merges text files to stdout                                                                                                                                                                                |
| `open`                                  | Mac command to open a URL in the default web browser                                                                                                                                                       |
| `xmessage`                              | Linux X GUI pop-up message command                                                                                                                                                                         |
| `xclip`                                 | Copy stdin to the Linux X UI clipboard, or the clipboard to stdout                                                                                                                                         |
| `pbcopy`                                | Copy stdin to the Mac UI clipboard                                                                                                                                                                         |
| `pbpaste`                               | Prints the Mac UI clipboard to stdout                                                                                                                                                                      |
| `gprof`                                 | Profile output of an executable's time in each system call. Compile with `gcc -pg` first                                                                                                                   |
| `expect`                                | Controls interactive programs by sending them timed input from an 'expect' script                                                                                                                          |
| `autoexpect`                            | Generate an `expect` script automatically from an interactive run                                                                                                                                          |
| `flock`                                 | File lock, useful for advanced scripting. I'd previously written [flock.pl](https://github.com/HariSekhon/DevOps-Perl-tools/blob/master/flock.pl) to allow shell scripts to using programming file locking |
| `script`                                | Copy everything you write in the shell to a file to record an outline of a script for you                                                                                                                  |
| `tee`                                   | Pipes output to one or more file arguments as well as stdout for further piping. The `-a` switch appends instead of overwrites the file                                                                    |
| `fold`                                  | Wraps text to the width specified by `-w N`. Use `-s`  to only fold on spaces, not mid-word                                                                                                                |
| `pandoc`                                | Universal document converter<br/>(eg. [generate_repos_markdown_table.sh](https://github.com/HariSekhon/Kubernetes-configs/blob/master/generate_repos_markdown_table.sh))                                   |
| `iconv`                                 | Convert between character encodings                                                                                                                                                                        |
| `hexyl`                                 | Hex terminal viewer <https://github.com/sharkdp/hexyl>                                                                                                                                                     |
| `file`                                  | Determines file type                                                                                                                                                                                       |
| `pig`                                   | Parallel implementation of `gzip`. Call in tar using the `-I` option: `tar czvf -I 'pigz -9' myfile.tar.gz *`                                                                                              |

Environment variables to keep in mind:

| Variable  | Description                                                                      |
|-----------|----------------------------------------------------------------------------------|
| `EDITOR`  | Set the editor to open automatically in unix commands like `visudo`              |
| `TMOUT`   | Times out the shell or script after N seconds from the time this variable it set |
| `RANDOM`  | A random number                                                                  |
| `CDPATH`  | List of directories that a `cd` command will take you to with only the basename  |

## More Commands

- [JSON](json.md) commands

## Tips & Tricks

Treat a process as a file handle to read from:

```shell
<(somecommand)
```

Treat a process as a file handle to write in to:

```shell
>(somecommand)
```

A neat trick is to `tee /dev/stderr` to have the output appear on your screen while also sending it onwards for further
processing in a shell pipeline.

```shell
echo stuff | tee /dev/stderr | xargs echo processing
```

Tee to two programs:

```shell
echo stuff | tee >(cat) | cat
```

### Fifos

Something that seemed cool in the 2000s was FIFO pipes (first in first out). These are special files that one process
can write into and another process can read from:

```shell
mkfifo /tmp/test.fifo
```

this hangs if there isn't another process reading from the fifo pseudo-file:

```shell
echo stuff > /tmp/test.fifo
```

in another shell:

```shell
cat /tmp/test.fifo
```

In practice, I can't recall finding a need for this since the 2000s. There usually better solutions.

FIFOs have no real security though and rely on file permissions to stop somebody or some other program writing unexpected
input into the listening program, which may not be coded defensively enough. In practice people just use temporary files
between processes not started in the same shell if they really have to. Situations which require long-running IPC would
probably be better done in a real programming language.

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

### Miscellaneous

- `!n` - re-runs command number `n` from the `history`
- `!$` - the last argument of the previous command, usually a filename from a previous command. Useful to run another
command on the previous file operated on
- `!:n*` - takes the Nth arg to the end from the last command

## Debugging

### Shell executing tracing

Prints commands as a script runs so you can see what command generated an error:

```shell
set -x
```

### Fail on any error exit code

Fail if any command returns an unhandled non-zero exit code.

If you have unhandled errors your script should die so you know what the script is doing at all times and doesn't result
in unintended consequences:

```shell
set -e
```

### Fail if accessing any unset variable

This prevents commands running on typo variables or empty variables
(a variable set to the result of a command that returned nothing instead of the expected output) as that can have
disastrous consequences:

```shell
set -u
```

Imagine `rm -fr "/apps/$empty_variable"` which would delete all the apps instead of the expected one,
or worse on `/` would delete the entire operating system and all data on it.

### Clean Shell

Start a clean shell without any functions, aliases or other settings to help in debugging:

```shell
env - bash --norc --noprofile
```

In [DevOps-Bash-tools](devops-bash-tools.md) this a function called `cleanshell`.

## Style Guide

[Google Shell Guide](https://google.github.io/styleguide/shellguide.html) - I don't always agree with everything in here but here it is if you're interested

Points I disagree with the Google style guide on:

- 2 space indentation - Python already set the standard with 4 space indentation for ease of readability 20+ years ago
- 80 character width is also antiquated. 100 or 120 char width is probably fine for most people, you are unlikely to be editing scripts on an old 80 character console
- shell pipes should not all be on one line unless they're a trivial mere couple commands
  - because any changes will have a larger blast radius in trying to scan what part of the line changed
  - split command pipes one command per line for easier `git diff`ing showing the command that changed
- `${var}` variables surrounded by braces is only needed for variables that touch other strings and would otherwise be misinterpreted. You don't get paid to put in extra characters everywhere
- the Google guideline then tells you not to bother doing it for single character variables unless they touch another adjacent string, but doesn't follow this same logic for full word variables
- `[[` is more advanced and less portable than `[` - only use it when you need regex matching

###### Partial port from private Knowledge Base page 2008+
