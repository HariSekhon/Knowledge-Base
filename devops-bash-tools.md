# DevOps-Bash-tools

[HariSekhon/DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools)

```shell
git clone https://github.com/HariSekhon/DevOps-Bash-tools bash-tools

cd bash-tools
```

### Make (optional)

Then run `make` to install any dependencies, system packages, libraries etc.

If you only want to use a specific script you could skip this setp and install bits yourself,
possibly using the `install/install*.sh` scripts.

```shell
make
```

OR individual install only the individual bits you need for a specific script you want to run:

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

Now run whatever script you came for...

## Configs

The `configs/` directory is full of dotfiles that get symlinked to your `$HOME` directory if you do a `make link` at
the top level of the repo. Any existing configs get skipped for safety. Any `.bash*` files have a `source`
line added to not interfere with existing files.
