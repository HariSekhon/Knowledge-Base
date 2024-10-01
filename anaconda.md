# Anaconda

<https://docs.anaconda.com/>

Python distribution for Scientific / Maths / Data Analysis by Continuum.

<!-- INDEX_START -->

- [Key Points](#key-points)
  - [Anaconda Enterprise](#anaconda-enterprise)
- [Install](#install)
- [Create Environment](#create-environment)
- [Delete Environment](#delete-environment)
- [Enter / Leave Environment](#enter--leave-environment)
- [Python Versions](#python-versions)
- [Packages](#packages)

<!-- INDEX_END -->

## Key Points

- installs in home directory
- binary packages available from Anaconda Cloud - can upload your own

- select customize Anaconda installation and de-select Modify Path otherwise it'll change the bash profile
- Anaconda appends path to `.bash_profile` otherwise, move to `.bashrc`
  - manually add `~/anaconda/bin` to `$PATH` in `.bashrc`
- removing Anaconda is simple `rm -fr ~/anaconda`

### Anaconda Enterprise

- Anaconda Enterprise - expensive, manages deployments across nodes
- cheat workaround is to install open source + rsync to other nodes

## Install

<https://docs.anaconda.com/miniconda/>

or

<https://docs.anaconda.com/anaconda/install/>

Add to .bashrc:

```shell
export PATH="/opt/anaconda2/bin:$PATH"
```

```shell
alias python="/opt/anaconda2/bin/python2.7"
```

```shell
conda --version
```

```shell
conda info
```

Show all environments using `-e` / `--envs`, `*` denotes active ones:

```shell
conda info --envs
```

Update conda packager manager:

```shell
conda update conda
```

Update packages metadata:

```shell
conda update anaconda
```

Adds nose package to yaml key `create_default_packages` in `~/.condarc`, so can create new envs without package args:

```shell
conda config --add create_default_packages nose
```

```shell
conda config --add channels pandas
```

Show all config keys or specify a key:

```shell
config config --get # [<key>]
```

## Create Environment

Create environment with `biopython` package in it using `-n` / `--name`:

```shell
conda create --name "$env" "$pkg"
```

Clone from an existing env:

```shell
conda create -n "$env2" --clone "$env"
```

Create another environment with specific python version 3:

```shell
conda create -n "$env" python=3 "$pkg"
```

## Delete Environment

```shell
conda remove -n "$env" --all
```

## Enter / Leave Environment

```shell
source activate "$env"
```

```shell
source deactivate
```

From within an env:

```shell
conda env export > py26.yml
```

Create new env from saved config:

```shell
conda create "$env2" -f py26.yml
```

## Python Versions

Show available python versions using `-f` / `--full-name`:

```shell
conda search --full-name python
```

## Packages

List installed packages in current env:

```shell
conda list
```

Search for package:

```shell
conda search "$pkg"
```

Specify `-n` / `--name` or will install in current env:

```shell
conda install [-n "$env"] "$pkg'
```

```shell
conda update  [-n "$env"] "$pkg"
```

Install from anaconda.org, search on anaconda.org and then specify specific channel's package:

```shell
conda install --channel https://conda.anaconda.org/pandas bottleneck
```

PIP - for stuff not available in Anaconda, activate the environment and then use pip as normal:

```shell
source activate "$env"
```

```shell
pip install "$pkg"
```

Show package was installed

```shell
conda list
```

Delete packages:

```shell
conda remove [-n "$env"] "$pkg" "$pkg2" ...
```

Search for stuff in a specific channel on <https://anaconda.org>:

```shell
conda search --override-channels -c pandas bottleneck
```

See if available from Anaconda repository:

```shell
conda search --override-channels -c defaults beautiful-soup
```

Build a conda package from PIP:

```shell
conda skeleton pypi "$package"
```

```shell
conda build "$package"
```

**Ported from private Knowledge Base Python page 2019+**
