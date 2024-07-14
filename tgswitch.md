# tgswitch


## Install
<https://github.com/warrensbox/tgswitch?tab=readme-ov-file#installation>

```shell
brew install warrensbox/tap/tgswitch
```

or

```shell
curl -L https://raw.githubusercontent.com/warrensbox/tgswitch/release/install.sh | bash
```

## Usage

Will prompt to download a version of [Terragrunt](terragrunt) from a list of recent versions:

```shell
tgswitch
```

or install a specific version as an arg without the `v` prefix:

```shell
tgswitch 0.39.2
```

using environment variable (put this in [direnv](direnv.md)'s `.envrc`):

```shell
export TG_VERSION=0.39.2
```

will now automatically download and switch to the above version:

```shell
tgswitch
```
