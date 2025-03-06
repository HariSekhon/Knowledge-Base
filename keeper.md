# Keeper

<https://www.keepersecurity.com/>

SaaS Secrets Vault.

<!-- INDEX_START -->

- [Keeper CLI](#keeper-cli)
  - [Install](#install)
  - [Usage](#usage)

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

```shell
keeper shell
```

This causes you to jump through lots of SSO and 2FA hoops, which is not worth the hassle.

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

This takes minutes to get through all these steps,
making this CLI a waste of time, just use the UI at least it'll stay logged in for a while.
