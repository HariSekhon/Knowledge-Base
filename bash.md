# Bash - Shell & Scripting

This is the standard modern shell. You should always script in Bash for portability.

It's a rare exception where you'd need to script in the original Bourne shell
(bootstrapping [Alpine](https://github.com/HariSekhon/Dockerfiles/blob/master/alpine-dev/Dockerfile)
is one of the few use cases for that).

## Core Reading Material

Books:

[Classic Shell Scripting](https://www.amazon.com/Classic-Shell-Scripting-Arnold-Robbins/dp/0596005954)

[Bash CookBook](https://www.amazon.com/bash-Cookbook-Solutions-Examples-Users/dp/1491975334/)

[Unix Power Tools](https://www.amazon.com/Power-Tools-Third-Shelley-Powers/dp/0596003307/)

Free:

[Advanced Bash Scripting Guide (HTML)](https://tldp.org/LDP/abs/html/)

[Advanced Bash Scripting Guide (PDF)](https://tldp.org/LDP/abs/abs-guide.pdf)

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

## Other Cool Resources

- [Greg's Wiki - Wooledge.org](https://mywiki.wooledge.org) - the grumpy old greycat guy on IRC in the 2000s will
  often send noobs to his classic resource
  - [Bash FAQ](https://mywiki.wooledge.org/BashFAQ)
  - [Bash Pitfalls](https://mywiki.wooledge.org/BashPitfalls)
  - [Bash Programming](https://mywiki.wooledge.org/BashProgramming)
  - [Bash Reference Sheet](https://mywiki.wooledge.org/BashSheet)
- [Shelldorado](http://www.shelldorado.com/)

## Tips

Some less well known commands to remember:

| Command                                 | Description                                                                                                                                                                                                     |
|-----------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `cmp`                                   | compare whether two files diff. Shorter than doing an `md5sum` on both (`md5` on Mac)                                                                                                                           |
| `comm`                                  | print or omit lines are common or unique between two files                                                                                                                                                      |
| `expand`                                | expands tabs to spaces                                                                                                                                                                                          |
| `unexpand`                              | converts spaces to tabs                                                                                                                                                                                         |
| `fmt`                                   |                                                                                                                                                                                                                 |
| `join`                                  | join matching records from multiple files                                                                                                                                                                       |
| `logger`                                | sends messages to the system log ie. syslog `/var/log/messages`                                                                                                                                                 |
| `mail`                                  | send email from the command line                                                                                                                                                                                |
| `whatis`/ `proppos` / `man -k`          | search for man pages containing the argument string                                                                                                                                                             |
| `command`                               | execute a binary from the path instead of a function of the same name                                                                                                                                           |
| `builtin`                               | execute a shell builtin instead of a function of the same name                                                                                                                                                  |
| `dialog`                                | create an interactive curses menu                                                                                                                                                                               |
| `say`                                   | Mac command that speaks the words piped in. I use this to impress my kids by making the computers talk                                                                                                          |
| `type`                                  | Tells you what a command is, path to binary or shell builtin. `-P` returns only <br/>binary                                                                                                                     |
| `xev`                                   | Prints the keystrokes to the Linux X server GUI                                                                                                                                                                 |
| `tail --follow=name --retry <filename>` | GNU tail can retry and continue following a file if it's renamed                                                                                                                                                |
| `split`                                 | Split a text file into smaller parts by lines or bytes. Useful for parallel data processing                                                                                                                     |
| `csplit`                                | Split with context by splitting on pattern such as regex                                                                                                                                                        |
| `pr -m`                                 | Prints files into columns                                                                                                                                                                                       |
| `column -t`                             | Prints stdin into aligned columns to tidy up output (used in various scripts in [DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools)                                                            |
| `paste`                                 | merges text files to stdout                                                                                                                                                                                     |
| `open`                                  | Mac command to open a URL in the default web browser                                                                                                                                                            |
| `xmessage`                              | Linux X GUI pop-up message command                                                                                                                                                                              |
| `xclip`                                 | Copy stdin to the Linux X UI clipboard, or the clipboard to stdout                                                                                                                                              |
| `pbcopy`                                | Copy stdin to the Mac UI clipboard                                                                                                                                                                              |
| `pbpaste`                               | Prints the Mac UI clipboard to stdout                                                                                                                                                                           |
| `gprof`                                 | Profile output of an executable's time in each system call. Compile with `gcc -pg` first                                                                                                                        |
| `expect`                                | Controls interactive programs by sending them timed input from an 'expect' script                                                                                                                               |
| `autoexpect`                            | Generate an `expect` script automatically from an interactive run                                                                                                                                               |
| `flock`                                 | File lock, useful for advanced scripting. I'd previously written [flock.<br/>pl](https://github.com/HariSekhon/DevOps-Perl-tools/blob/master/flock.pl) to allow shell scripts to using programming file locking |
| `script`                                | Copy everything you write in the shell to a file to record an outline of a script for you                                                                                                                       |

Environment variables to keep in mind:

| Variable  | Description                                                                      |
|-----------|----------------------------------------------------------------------------------|
| `EDITOR`  | Set the editor to open automatically in unix commands like `visudo`              |
| `TMOUT`   | Times out the shell or script after N seconds from the time this variable it set |
| `RANDOM`  | A random number                                                                  |
| `CDPATH`  | List of directories that a `cd` command will take you to with only the basename  |

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

###### Partial port from private Knowledge Base 2008+
