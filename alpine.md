# Alpine

<https://wiki.alpinelinux.org>

Minimal Linux distribution used mainly to create small Docker images.

Uses `busybox` all-in-one binary with minimal core shell and coreutils functionality.

Replaced `libc` with `musl` core library which sometimes causes problems with progam compiling or grep buggy behaviour.

<!-- INDEX_START -->

- [Package Management](#package-management)
  - [Repositories](#repositories)
  - [Search](#search)
  - [Install / Uninstall Packages](#install--uninstall-packages)
  - [Info](#info)
  - [Upgrades](#upgrades)
  - [apk-file](#apk-file)

<!-- INDEX_END -->

## Package Management

<https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management>

## Repositories

```text
/etc/apk/repositories
```

Get the latest package lists:

```shell
apk update
```

## Search

Search packages for anything with the word "$name" in it:

```shell
apk search "$name"
```

Show all packages:

```shell
apk search
```

Show all packages and versions:

```shell
apk search -v
```

## Install / Uninstall Packages

Install a given package:

```shell
apk add "$pkg"
```

On Alpine 3+ you can skip the prerequisite `apk update` by adding the `-u` switch to add:

```shell
apk add -u "$pkg"
```

Uninstall package:

```shell
apk del "$pkg"
```

Delete the local package list cache:

(usually done at the end of a Dockerfile `RUN` to not save it to the docker image)

```shell
apk cache clean
```

## Info

List packages:

```shell
apk info
```

Show versions:

```shell
apk -v info
```

Show versions + descriptions:

```shell
apk -vv info
```

Find which package installed a given file on disk:

```shell
apk info --who-owns /bin/sh
```

Show package contents:

```shell
apk info -L <pkg>
```

Show all info on package:

```shell
apk info -a "$pkg"
```

## Upgrades

Upgrade system, all packages:

```shell
apk upgrade
```

Upgrade specific package:

```shell
apk add --upgrade "$pkg"
```

### apk-file

[:octocat: genuinetools/apk-file](https://github.com/genuinetools/apk-file)

`apt-file` but for Alpine, finds

Go binary that searches which packages contain a given filename.

```shell
docker run --rm -ti jess/apk-file <file>
```

**Ported from private Knowledge Base page 2015+**
