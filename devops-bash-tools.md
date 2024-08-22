# DevOps-Bash-tools

[HariSekhon/DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools)

<!-- INDEX_START -->

- [Clone](#clone)
- [Install Dependencies](#install-dependencies)
- [Add to `$PATH`](#add-to-path)
- [Link Configs and Inherit Bash Environment and `$PATH`](#link-configs-and-inherit-bash-environment-and-path)
- [Import just the `$PATH`](#import-just-the-path)

<!-- INDEX_END -->

## Clone

```shell
mkdir -p -v ~/github

git clone https://github.com/HariSekhon/DevOps-Bash-tools ~/github/bash-tools
```

## Install Dependencies

Then run `make` to install any dependencies, system packages, libraries etc.

If you only want to use a specific script you could skip this setp and install bits yourself,
possibly using the `install/install*.sh` scripts.

```shell
cd ~/github/bash-tools
```

```shell
make
```

OR install only the individual bits you need for a specific script you want to run:

```shell
install/install_aws_cli.sh
```
```shell
install/install_gcloud_sdk.sh
```
```shell
install/install_homebrew.sh

brew install jq
```

Now run whichever script you came for...

## Add to `$PATH`

Much of the rest of this knowledge base gives the short script names for brevity.

You should add the directories containing the scripts to your `$PATH`.

You can do this manually or by automatically linking

## Link Configs and Inherit Bash Environment and `$PATH`

The `configs/` directory is full of dotfiles that get symlinked to your `$HOME` directory if you run this at the root
of the repo:

```
make link
```

Any existing configs get skipped for safety.

The output will show what is symlinked and what is skipped.

Any `~/.bash*` or `~/.zsh*` files will have a `source` line added which will include all the aliases,
functions and paths to the subdirectories of the repo containing the many scripts.

## Import just the `$PATH`

If you'd rather not import everything,
you can just source the `.bash.d/paths.sh` yourself in your `~/.bashrc` by adding this:

```shell
source ~/github/bash-tools/.bash.d/paths.sh
```
