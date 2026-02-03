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
  - [Testing Alpine Upgrades](#testing-alpine-upgrades)
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

### Testing Alpine Upgrades

Run an older version, eg. 3.18:

```shell
docker run --rm -it alpine:3.18 sh
```

Download the package lists and ensure the alpine-keys are installed:

```shell
apk update &&
apk add --no-cache alpine-keys
```

Update the repository to point to a newer version:

```shell
sed -i 's/v3\.18/v3\.21/g' /etc/apk/repositories
```

Update the package lists to the newer version:

```shell
apk update
```

Now you should see several outdated packages to test with:

```shell
apk version -l '<'
```

```text
Installed:                                Available:
alpine-baselayout-3.4.3-r1              < 3.6.8-r1
alpine-baselayout-data-3.4.3-r1         < 3.6.8-r1
alpine-keys-2.4-r1                      < 2.5-r0
apk-tools-2.14.4-r0                     < 2.14.6-r3
busybox-1.36.1-r7                       < 1.37.0-r14
busybox-binsh-1.36.1-r7                 < 1.37.0-r14
ca-certificates-bundle-20241121-r1      < 20250911-r0
libcrypto3-3.1.8-r0                     < 3.3.6-r0
libssl3-3.1.8-r0                        < 3.3.6-r0
musl-1.2.4-r3                           < 1.2.5-r9
musl-utils-1.2.4-r3                     < 1.2.5-r9
scanelf-1.3.7-r1                        < 1.3.8-r1
ssl_client-1.36.1-r7                    < 1.37.0-r14
zlib-1.2.13-r1                          < 1.3.1-r2
```

Now test whatever upgrades you want.

### apk-file

[:octocat: genuinetools/apk-file](https://github.com/genuinetools/apk-file)

`apt-file` but for Alpine, finds

Go binary that searches which packages contain a given filename.

```shell
docker run --rm -ti jess/apk-file <file>
```

**Ported from private Knowledge Base page 2015+**
