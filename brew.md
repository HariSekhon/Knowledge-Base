# Homebrew

[Homebrew](https://brew.sh/) is the best package manager for Mac.

## Install

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Package Management

```shell
brew install <package>
```

```shell
brew reinstall <package>
```

```shell
brew remove <package>
```

## Info

```shell
brew info <package>
```

List files for package:

```shell
brew ls --verbose <package>
```

## Package Lists

[Core Packages](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/setup/brew-packages.txt) -
for scripting

[Desktop Packages](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/setup/brew-packages-desktop.txt) -
everything you might want

[Desktop Taps](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/setup/brew-packages-desktop-taps.txt)

[Desktop Casks](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/setup/brew-packages-desktop-casks.txt)

## Troubleshooting

Fix SSL of a package:

[brew_fix_openssl_dependencies.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/setup/brew_fix_openssl_dependencies.sh)

###### Partial port from private Knowledge Base page 2013+
