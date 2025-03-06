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
    - [Connection Commands](#connection-commands)
    - [Import / Export](#import--export)

<!-- INDEX_END -->

## Keeper CLI

[:octocat: Keeper-Security/Commander](https://github.com/Keeper-Security/Commander)

<https://docs.keeper.io/en/privileged-access-manager/commander-cli/overview>

Keeper Commander is a python-based CLI and SDK interface to Keeper.

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

[Logging in](https://docs.keeper.io/en/privileged-access-manager/commander-cli/commander-installation-setup/logging-in)
each time forces you to jump through lots of SSO, device verification email and 2FA hoops, which is not worth the
hassle.

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

#### Shell vs CLI

[Command Reference](https://docs.keeper.io/en/privileged-access-manager/commander-cli/command-reference)

Since starting the Keeper shell is a bit slow, enter the shell once, and then type the commands instead of:

```shell
keeper ls
```

do

```shell
keeper
```

```text
ls
```

#### Connection Commands

[Connection Commands](https://docs.keeper.io/en/privileged-access-manager/commander-cli/command-reference/connection-commands)

You can launch SSH, SSH-Agent, RDP or SFTP connections directly from Keeper using its secrets.

#### Import / Export

[Import/Export doc](https://docs.keeper.io/en/privileged-access-manager/commander-cli/command-reference/import-and-export-commands)

You can export your secrets to specific formats like KeePass, CSV or JSON.

You can import from CyberArk, LastPass, Keepass, ManageEngine, Myki, Proton Pass, CSV or JSON.
