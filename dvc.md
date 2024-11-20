# DVC - Data Version Control

<https://dvc.org/>

Git for data science projects.

<!-- INDEX_START -->

- [Install](#install)
  - [Mac](#mac)
  - [Debian / Ubuntu](#debian--ubuntu)
- [Pull Path](#pull-path)

<!-- INDEX_END -->

## Install

### Mac

```shell
brew install dvc
```

### Debian / Ubuntu

Download the apt sources list:

```shell
sudo wget \
     https://dvc.org/deb/dvc.list \
     -O /etc/apt/sources.list.d/dvc.list
```

Download the GPG key:

```shell
curl -sSf https://dvc.org/deb/iterative.asc |
gpg --dearmor > dvc.gpg
```

```shell
sudo install -o root -g root -m 644 dvc.gpg /etc/apt/trusted.gpg.d/ &&
rm -f dvc.gpg
```

```shell
sudo apt update
```

```shell
sudo apt install dvc
```

## Pull Path

```shell
dvc pull "$DVC_PATH"
```
