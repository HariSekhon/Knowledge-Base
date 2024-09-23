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
  - [General](#general)
  - [Web](#web)
  - [Databases](#databases)
  - [Cloud](#cloud)
  - [CI/CD & Linting](#cicd--linting)
  - [Unit Testing](#unit-testing)
  - [Virtualization & Containerization](#virtualization--containerization)
  - [Big Data & NoSQL](#big-data--nosql)
  - [Data Formats & Analysis](#data-formats--analysis)
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

You can see these used throughout these GitHub repos:

- [HariSekhon/DevOps-Python-tools](https://github.com/HariSekhon/DevOps-Python-tools)
- [HariSekhon/Nagios-Plugins](https://github.com/HariSekhon/Nagios-Plugins)
- [HariSekhon/DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools)
- [HariSekhon/pylib](https://github.com/HariSekhon/pylib)

### General

- `GitPython` - [Git](git.md)
- `sh` - execute shell commands more easily
- `jinja2` - [Jinja2](https://jinja.palletsprojects.com) templating
- `humanize` - converts units to human readable
- `pyobjc-framework-Quartz` - control Mac UI
- `psutil`
- `PyInstaller` - bundle Python code into standalone executablers (doesn't work for advanced code)
- `sasl`

### Web

- `requests` - easy HTTP request library
- `beautifulsoup4` - HTML parsing library
- [Scrapy](https://scrapy.org/) - web scraping
- `selenium` - Selenium web testing framework

### Databases

- `mysqlclient` - [MySQL](mysql.md) client
- `psycopg2` - [PostgreSQL](postgres.md)
- `psycopg2-binary`

### Cloud

- `boto3` - [AWS](aws.md)
- `aws-consoler`

### CI/CD & Linting

- `python-jenkins` - [Jenkins](jenkins.md)
- `TravisPy` - for [Travis CI](travis.md)
- `pylint` - Python linting CLI tool
- `grip` - [Grip](https://github.com/joeyespo/grip) renders local markdown using a local webserver
- `Markdown`
- `MarkupSafe`
- `checkov`
- `semgrep` - security / misconfiguration scanning
- `jsonlint`
- `yamllint` - CLI [YAML](yaml.md) linting tool

### Unit Testing

- `unittest2`
- `nose`

### Virtualization & Containerization

- `docker` - control local [Docker](docker.md)
- `kubernetes` - [Kubernetes](kubernetes.md)
- `pyvmomi` - VMware

### Big Data & NoSQL

- `elasticsearch` - [Elasticsearch](elasticsearch.md)
- `happybase` - [HBase](hbase.md)
- `impyla` - [Impala](impala.md)
- `kafka-python` - [Kafka](kafka.md)
- `kazoo` - [ZooKeeper](zookeeper.md)
- `pika` - [RabbitMQ](rabbitmq.md)
- `PyHive` - for Apache [Hive](hive.md)
- `python-krbV` - [Kerberos](kerberos.md) support, often pulled as a dependency for `snakebite[kerberos]`
- `snakebite` - [HDFS](hdfs.md)

### Data Formats & Analysis

- `avro` - [Avro](avro.md)
- `ldif3` - LDAP LDIF format
- `jsonlint`
- `Markdown`
- `MarkupSafe`
- `numpy` - [NumPy](https://numpy.org/) for scientific numeric processing
- `pandas` - [Pandas](https://pandas.pydata.org/) for data analysis
- `python-cson`
- `pyarrow` - Apache Arrow and Parquet support, but Parquet support in this is weak, prefer
              [Parquet Tools](parquet.md#parquet-tools)
- `python-ldap`
- `python-snappy` - work with Snappy compression format, often pulled as a dependency
- `PyYAML` - work with [YAML](yaml.md) files in Python
- `toml`
- `xmltodict`
- `yamllint` - CLI [YAML](yaml.md) linting tool

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
