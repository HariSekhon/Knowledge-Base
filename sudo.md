# Sudo

<!-- INDEX_START -->

- [Elevate to a root shell](#elevate-to-a-root-shell)
- [Configure Which Users / Groups Can Sudo](#configure-which-users--groups-can-sudo)
- [Passwordless Sudo](#passwordless-sudo)
- [Test Sudo](#test-sudo)

<!-- INDEX_END -->

Elevate to root using the `sudo` command.

```text
sudo <somecommand>
```

## Elevate to a Root Shell

```shell
sudo su
```

The above is sometimes frowned upon if you want every elevated command logged for strict auditing.

## Configure Which Users / Groups Can Sudo

Configure which users and groups can sudo and to which commands by editing the `/etc/sudoers` file
(or sometimes `/etc/sudoers.d/...` include files).

This command drop you into your `$EDITOR` if it's set (see [IntelliJ](intellij.md) page), or if not set then it'll open
`/etc/sudoers` in the classic [vi](vim.md) editor.

```shell
sudo visudo
```

The line you need to add is:

```text
hari        ALL = (ALL) ALL
```

Replace `hari` with your username.

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

## Test Sudo

Test sudo permission by first invalidating your sudo cached credential:

```shell
sudo -k
```

and then retrying a basic command which should return successfully without a password prompt:

```shell
sudo -n echo success
```
