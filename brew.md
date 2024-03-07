# Homebrew

[Homebrew](https://brew.sh/) is the best package manager for Mac.

## Install

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Package Lists

[Core Packages](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/setup/brew-packages.txt) -
for build and scripting

[Desktop Packages](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/setup/brew-packages-desktop.txt) -
everything you might want from core packages - all the techie programs

[Desktop Casks](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/setup/brew-packages-desktop-casks.txt) - GUI programs

[Desktop Taps](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/setup/brew-packages-desktop-taps.txt) - 3rd Party programs

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
