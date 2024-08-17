# Homebrew

<https://brew.sh/>

[Homebrew](https://brew.sh/) is the best package manager for Mac.

The guy who wrote this didn't get hired by Google ffs... who cares about old bubble sort comp-sci bullshit. Seriously.

<!-- INDEX_START -->
<!-- INDEX_END -->

## Install

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Package Lists

All the packages I use on Mac are stored in the [DevOps-Bash-tools](devops-bash-tools.md) repo.

[Core build packages and core utils](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/setup/brew-packages.txt)

[Desktop Packages](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/setup/brew-packages-desktop.txt) - long list of cool & techie packages for Mac

[Desktop Casks](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/setup/brew-packages-desktop-casks.txt) - major GUI 3rd party apps

[Desktop Taps](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/setup/brew-packages-desktop-taps.txt) - more 3rd party apps

## Package Management

```shell
brew install "$package"
```

```shell
brew reinstall "$package"
```

```shell
brew remove "$package"
```

## Info

```shell
brew info "$package"
```

List files for package:

```shell
brew ls --verbose "$package"
```

## Troubleshooting

Fix SSL of a package:

[brew_fix_openssl_dependencies.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/setup/brew_fix_openssl_dependencies.sh)

###### Partial port from private Knowledge Base page 2013+
