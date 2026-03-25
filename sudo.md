# Sudo

<!-- INDEX_START -->

- [Elevate to a Root Shell](#elevate-to-a-root-shell)
- [Configure Which Users / Groups Can Sudo](#configure-which-users--groups-can-sudo)
- [Passwordless Sudo](#passwordless-sudo)
- [BioMetric Sudo](#biometric-sudo)
- [Test Sudo](#test-sudo)
- [Sudo Security](#sudo-security)
  - [Dangerous Commands Which Can Escape to Elevated Shells](#dangerous-commands-which-can-escape-to-elevated-shells)
  - [Sudo Path Vulnerability](#sudo-path-vulnerability)
  - [Sudo File Path Disallow Vulnerability](#sudo-file-path-disallow-vulnerability)
  - [Sudo Path Write Vulnerability](#sudo-path-write-vulnerability)

<!-- INDEX_END -->

Elevate to root using the `sudo` command.

```text
sudo <somecommand>
```

## Elevate to a Root Shell

This is often frowned upon if you want every elevated command logged for strict auditing.

```shell
sudo su
```

For better auditing you need to enforce putting sudo in front of each individual command and
disable any command that can do arbitrary elevated actions.

This is harder than it first seems.

The only really secure way to do this is with an explicit careful sudo command whitelist.

See some issues under the [Sudo Security](#sudo-security) section below.

## Configure Which Users / Groups Can Sudo

Configure which users and groups can sudo and to which commands by editing the `/etc/sudoers` file
(or sometimes `/etc/sudoers.d/...` include files).

Use the `visudo` command because it validates the changes before it allows saving them.

This command drop you into your `$EDITOR` if it's set (see [IntelliJ](intellij.md) page), or if not set then it'll open
`/etc/sudoers` in the classic [vi](vim.md) editor.

```shell
sudo visudo
```

If you want to add to another file under `/etc/sudoers.d/` then:

```shell
sudo visudo -f /etc/sudoers.d/hari
```

Replace `hari` with your username.

The line you need to add is:

```text
hari        ALL = (ALL) ALL
```

Ensure if you're create a new file `/etc/sudoers.d/hari` that you set correct permissions:

```shell
sudo chmod 440 /etc/sudoers.d/hari
```

## Passwordless Sudo

To allow your user to use `sudo` without having to enter their password every 5 minutes, set the line to:

```text
hari        ALL = (ALL) NOPASSWD: ALL
```

**Ensure the above line comes after the following line found by default on macOS**:

```text
%admin      ALL = (ALL) ALL
```

as this `%admin` line requires a password for all members of the `admin` group which you will be in on your macOS.

## BioMetric Sudo

On [Mac](mac.md) you can enable using Touch ID fingerprint authorization of sudo.

Create a file called `/etc/pam.d/sudo_local` with contents:

```text
auth    sufficient    pam_tid.so
```

This file is automatically sourced by `/etc/pam.d/sudo` and survives upgrades.

Command to create this file if it doesn't already exist:

```shell
sudo sh -c '[ -f /etc/pam.d/sudo_local ] || echo "auth sufficient pam_tid.so" >> /etc/pam.d/sudo_local'
```

## Test Sudo

First clear sudo cached credential:

```shell
sudo -k
```

Then try a basic command which should return successfully without a password prompt.

```shell
sudo echo success
```

To test Passwordless Sudo while disallowing a password prompt you can use the `-n` switch.

You cannot use this to test BioMetric Sudo because it suppresses the GUI pop-up prompt for fingerprint ID.

```shell
sudo -n echo success
```

## Sudo Security

### Dangerous Commands Which Can Escape to Elevated Shells

Any of the following commands if allowed to `sudo` can bypass elevated shell restrictions:

- `su`
- `sudo -i` / `sudo -s`
- [shells](shell.md)
- scripts
- pagers - `man`, `more`, `less` can run `!sh`
- compilers & interpreters (eg.
  [Python](python.md),
  [Perl](perl.md),
  [Ruby](ruby.md) etc.),
- [IDEs and Editors](editors.md) ([IntelliJ](intellij.md), `vi`and `emacs` can run shells inside them).

### Sudo Path Vulnerability

You need to restrict the `$PATH`, in `/etc/sudoers`

```shell
Defaults restricted_envs += "PATH"
Defaults env_reset
Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
```

### Sudo File Path Disallow Vulnerability

Using disallowed paths is easily bypassed by just changing the path eg:

```shell
sudo cp /bin/sh "$HOME"/
sudo "$HOME/sh
```

### Sudo Path Write Vulnerability

The sudo allowed paths must not be writable or replaceable using even a sudo command.

This is in itself hard to strict since any command which can write file contents or modify directory contents
(two separate permissions) can replace the contents of a whitelisted path binary or script with hostile contents to
gain full root shell elevation.
