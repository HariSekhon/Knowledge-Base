# Python

Python is a popular and easy to use general purpose programming language that is heavily used in Data Analytics and
Data Science as well as systems administration.

It's not as amazing for one-liners as [Perl](perl.md) is though, which can boost [shell scripts](shell.md) more easily.

<!-- INDEX_START -->

- [Core Reading](#core-reading)
- [DevOps Python  tools](#devops-python--tools)
- [Shell scripts with Python](#shell-scripts-with-python)
- [Nagios Plugins in Python](#nagios-plugins-in-python)
- [Python Library with Unit Tests](#python-library-with-unit-tests)
- [VirtualEnv](#virtualenv)
- [Pipenv](#pipenv)
- [Libraries](#libraries)
- [Troubleshooting](#troubleshooting)
  - [Alpine `ModuleNotFoundError: No module named 'pip._vendor.six.moves'`](#alpine-modulenotfounderror-no-module-named-pip_vendorsixmoves)

<!-- INDEX_END -->

## Core Reading

[Learning Python](https://www.amazon.com/Learning-Python-5th-Mark-Lutz/dp/1449355730/)

## DevOps Python  tools

[HariSekhon/DevOps-Python-tools](https://github.com/HariSekhon/DevOps-Python-tools)

## Shell scripts with Python

Shell scripts using Python and making it easier to install Python pip libraries from PyPI.

[HariSekhon/DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools)

## Nagios Plugins in Python

[HariSekhon/Nagios-Plugins](https://github.com/HariSekhon/Nagios-Plugins)

## Python Library with Unit Tests

[HariSekhon/pylib](https://github.com/HariSekhon/pylib)

## VirtualEnv

Creates a virtual environment in the local given sub-directory in which to install PyPI modules to avoid clashes with system python libraries.

```shell
virtualenv "$directory_name_to_create"
```

I like top always the directory name `venv` for the virtualenv:

```shell
virtualenv venv
```

Then to use it before you starting `pip` installing:

```shell
source venv/bin/activate
```

This prepends to `$PATH` to use the `bin/python` and `lib/python-3.12/site-packages` under the local `venv` directory:

Now install PyPI modules as usual.

The `venv/pyvenv.cfg` file will contain some metadata like this:

```properties
home = /opt/homebrew/Cellar/python@3.12/3.12.3/bin
implementation = CPython
version_info = 3.12.3.final.0
virtualenv = 20.25.3
include-system-site-packages = false
base-prefix = /opt/homebrew/Cellar/python@3.12/3.12.3/Frameworks/Python.framework/Versions/3.12
base-exec-prefix = /opt/homebrew/Cellar/python@3.12/3.12.3/Frameworks/Python.framework/Versions/3.12
base-executable = /opt/homebrew/Cellar/python@3.12/3.12.3/Frameworks/Python.framework/Versions/3.12/bin/python3.12
```

## Pipenv

<https://pipenv.pypa.io/en/latest/>

<https://github.com/pypa/pipenv>

Combines Pip and VirtualEnv into one command.

```shell
brew install pipenv
```

Creates a `Pipfile` and `Pipfile.lock`,
plus a virtualenv in a standard location `$HOME/.local/share/virtualenvs/` if not already inside one.

```shell
pipenv install
```

Activates the virtualenv

```shell
pipenv shell
```

Automatically converts a `requirements.txt` file into a `Pipfile`:

```shell
pipenv check
```

Dependency graph:

```shell
pipenv graph
```

## Libraries

- `boto3` - [AWS](aws.md)
- `GitPython` - [Git](git.md)
- `happybase` - [HBase](hbase.md)
- `humanize` - converts units to human readable
- `kafka-python` - [Kafka](kafka.md)
- `mysqlclient` - [MySQL](mysql.md) client
- `pika` - [RabbitMQ](rabbitmq.md)
- `psycopg2` - [PostgreSQL](postgres.md)
- `psycopg2-binary`
- `requests` - easy HTTP request library
- `beautifulsoup4` - HTML parsing library
- `docker` - control local [Docker](docker.md)
- `pylint` - linting CLI tool
- `python-jenkins` - [Jenkins](jenkins.md)
- `snakebite` - [HDFS](hdfs.md)
- `PyYAML` - work with [YAML](yaml.md) files in Python
- `nose` - test library
- `unittest2` - test library
- [Scrapy](https://scrapy.org/) - web scraping
- `TravisPy` - for [Travis CI](travis.md)
- `sh` - execute shell commands more easily
- `PyHive` - for Apache [Hive](hive.md)
- `PyInstaller` - bundle Python code into standalone executablers (doesn't work for advanced code)
- `pyvmomi` - VMware
- `kazoo` - [ZooKeeper](zookeeper.md)
- `avro` - [Avro](avro.md)
- `elasticsearch` - [Elasticsearch](elasticsearch.md)
- `impyla` - [Impala](impala.md)
- `jinja2` - Jinja2 templating
- `ldif3` - LDAP LDIF format
- `numpy`
- `Markdown`
- `MarkupSafe`
- `psutil`
- `python-cson`
- `python-ldap`
- `python-snappy` - work with Snappy compression format, often pulled as a dependency
- `sasl`
- `selenium` - Selenium web testing framework
- `yamllint` - CLI [YAML](yaml.md) linting tool
- `xmltodict`
- `toml`
- `pyarrow` - Apache Arrow and Parquet support, but Parquet support in this is weak, prefer
              [Parquet Tools](parquet.md#parquet-tools)
- `python-krbV` - Kerberos support, often pulled as a dependency for `snakebite[kerberos]`

## Troubleshooting

### Alpine `ModuleNotFoundError: No module named 'pip._vendor.six.moves'`

```shell
ModuleNotFoundError: No module named 'pip._vendor.six.moves'
```

Fix:

```shell
apk del py3-pip py-pip
apk add py3-pip
```

**Partial port from private Knowledge Base page 2008+**
