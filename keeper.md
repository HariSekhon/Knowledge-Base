# Keeper

<https://www.keepersecurity.com/>

SaaS Secrets Vault.

<!-- INDEX_START -->

- [Keeper CLI](#keeper-cli)
  - [Install](#install)
  - [Usage](#usage)
    - [Login](#login)
    - [Persisting Login for 30 days](#persisting-login-for-30-days)
  - [Shell vs CLI](#shell-vs-cli)
  - [Commands](#commands)
    - [Connection Commands](#connection-commands)
    - [Import / Export](#import--export)

<!-- INDEX_END -->

One of the worst things about Keeeper is having records owned by a user and not being able to recover it if they leave.

This might be a limitation of the Keeper organization where I was,
but users have to spend time transferring all the records owned by them to a colleague before leaving.

## Keeper CLI

[:octocat: Keeper-Security/Commander](https://github.com/Keeper-Security/Commander)

<https://docs.keeper.io/en/privileged-access-manager/commander-cli/overview>

Keeper Commander is a python-based CLI and SDK interface to Keeper.

This can be used as a workaround if you're restricted from accessing Keeper on your personal machines because the
authentication url can be copied and the login token copied back, for example in a corporate Windows Virtual Desktop.

### Install

Download and run the `.pkg` installer on Mac from:

<https://github.com/Keeper-Security/Commander/releases>

or if not on Mac / Windows, then using Python pip:

```shell
pip3 install keepercommander
```

or using [DevOps-Bash-tools](devops-bash-tools.md) which runs the above options:

```shell
install_keeper_cli.sh
```

Check it's install version and path:

```shell
$ ls -l $(which keeper)
/usr/local/bin/keeper@ -> /usr/local/keepercommandercli/bin/keeper-commander
```

```shell
keeper --version
```

```text
Keeper Commander, version 17.0.8
```

### Usage

#### Login

```shell
keeper shell
```

```shell
keeper login
```

```shell
Navigate to SSO Login URL with your browser and complete login.
Copy a returned SSO Token into clipboard.
Paste that token into Commander
NOTE: To copy SSO Token please click "Copy login token" button on "SSO Connect" page.

  a. SSO User with a Master Password
  c. Copy SSO Login URL to clipboard
  o. Navigate to SSO Login URL with the default web browser
  p. Paste SSO Token from clipboard
  q. Quit SSO login attempt and return to Commander prompt
Selection:
```

This process creates a file:

```text
~/.keeper/config.json
```

```text
whoami
```

#### Persisting Login for 30 days

[Logging in](https://docs.keeper.io/en/privileged-access-manager/commander-cli/commander-installation-setup/logging-in)
each time forces you to jump through lots of SSO, device verification email and 2FA hoops, which is not worth the
hassle.

[Configuration file](https://docs.keeper.io/en/privileged-access-manager/commander-cli/commander-installation-setup/configuration)
and persistence details.

Inside Keeper Shell:

```text
this-device register
```

```text
this-device persistent-login on
```

When prompted for 2FA enter

```text
forever
```

Then on the next prompt enter your TOTP (Time-based One Time Password) from your authenticator step.

```text
this-device ip-auto-approve on
```

```text
this-device timeout 30d
```

This will update this file:

```text
~/.keeper/config.json
```

### Shell vs CLI

Since starting the Keeper shell is a bit slow, enter the shell once, and then type the commands instead of:

```shell
keeper ls
```

do

```shell
keeper
```

then run the `ls` and other commands without exiting and incurring the startup overhead each time.

### Commands

[Command Reference](https://docs.keeper.io/en/privileged-access-manager/commander-cli/command-reference)

Lists all the secrets (this is a big mess):

```text
list
```

or

```text
l
```

Search for records via a regex:

```text
search "someregex"
```

List folders and secrets at current level:

```text
ls
```

or more clearly to see just the top level folder structure without top level secrets:

```text
tree
```

Show shared folders you have access to:

```text
list-sf
```

```text
cd My\ Folder
```

Then list only those secrets in that folder:

```text
ls
```

```text
record-history "My Secret"
```

```text
rh "My Secret"
```

```text
Version    Modified By               Time Modified
---------  ------------------------  -------------------
Current    hari@domain.com           2025-03-11 02:32:39
```

```text
clipboard-copy "My Secret"
```

```text
cc "My Secret"
```

Download all attachemnts for a given secret:

```text
download-attachment "My Secret"
```

Exploration commands:

```text
find-duplicate
```

```text
find-ownerless
```

```text
trash list
```

See the [Command Reference](https://docs.keeper.io/en/privileged-access-manager/commander-cli/command-reference) for more commands like `mkdir`,
`mv` a secret to a new folder,
`record-add`,
`record-update`,
`rm` (delete a record),
`upload-attachment`,
`delete-attachment`,
`append-notes`
etc.

#### Connection Commands

[Connection Commands](https://docs.keeper.io/en/privileged-access-manager/commander-cli/command-reference/connection-commands)

You can launch SSH, SSH-Agent, RDP or SFTP connections directly from Keeper using its secrets.

#### Import / Export

[Import/Export doc](https://docs.keeper.io/en/privileged-access-manager/commander-cli/command-reference/import-and-export-commands)

You can export your secrets to specific formats like KeePass, CSV or JSON.

You can import from CyberArk, LastPass, Keepass, ManageEngine, Myki, Proton Pass, CSV or JSON.
