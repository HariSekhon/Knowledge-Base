# Travis CI

One of the original hosted CI/CD systems.

<!-- INDEX_START -->
- [Key Points](#key-points)
  - [Travis CI Template](#travis-ci-template)
  - [Online Config Validator](#online-config-validator)
  - [Desktop Menu Notifications](#desktop-menu-notifications)
  - [Travis CI URL for monitoring a Repo](#travis-ci-url-for-monitoring-a-repo)
  - [Travis CI CLI](#travis-ci-cli)
  - [CLI Usage](#cli-usage)
- [Docker](#docker)
- [Troubleshooting](#troubleshooting)
  - [Debug Automation](#debug-automation)
<!-- INDEX_END -->

## Key Points

Reasonable UI, but...

[travis-ci.org](https://travis-ci.org) was free for open source, but has been retired.

[travis-ci.com](https://www.travis-ci.com/) remains as a paid offering.

This has caused Travis CI to go from once leading open source to now legacy CI/CD.

Superceded by newer more free CI/CD systems like [GitHub Actions](github-actions.md) now which is unlimited free for all public projects.

### Travis CI Template

Copy to root of GitHub repo and edit:

[.travis.yml](https://github.com/HariSekhon/Templates/blob/master/.travis.yml)

```shell
wget -nc -O https://raw.githubusercontent.com/HariSekhon/Templates/master/.travis.yml
```

### Online Config Validator

Paste `.travis.yml` config in this online validator to see parsing and job matrix:

https://config.travis-ci.com/explore

### Desktop Menu Notifications

- [CCMenu](https://ccmenu.org/) - Mac OSX menu watcher
- [BuildNotify](https://anaynayak.github.io/buildnotify/) - for Linux

### Travis CI URL for monitoring a Repo

Here is the URL for the above desktop notifiation tools

```
https://api.travis-ci.org/repos/<owner>/<repo>/cc.xml
```
Returns empty json `{}` if it doesn't find the repo

Config I used for CCMenu on Mac for several years to monitor my GitHub repos:

[CCMenu.plist](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/Library/Containers/net.sourceforge.cruisecontrol.CCMenu/Data/Library/Preferences/net.sourceforge.cruisecontrol.CCMenu.plist)

```shell
mkdir -p -v ~/Library/Containers/net.sourceforge.cruisecontrol.CCMenu/Data/Library/Preferences/

wget -nc -O ~/Library/Containers/net.sourceforge.cruisecontrol.CCMenu/Data/Library/Preferences/net.sourceforge.cruisecontrol.CCMenu.plist \
      https://raw.githubusercontent.com/HariSekhon/DevOps-Bash-tools/master/Library/Containers/net.sourceforge.cruisecontrol.CCMenu/Data/Library/Preferences/net.sourceforge.cruisecontrol.CCMenu.plist
```

### Travis CI CLI

Follow the [install doc](https://github.com/travis-ci/travis.rb#installation) or paste this to run an automated install script
which auto-detects and handles Mac or Linux:


```shell
git clone https://github.com/HariSekhon/DevOps-Bash-tools
```

```shell
bash-tools/install/install_travis.sh
```

OR manually:

```shell
gem install travis --no-rdoc --no-ri
```


```shell
travis login
```

```shell
travis token
```

### CLI Usage

Linting:

```shell
travis lint  # .travis.yml
```

Switches of notes:

| Switch | Description          |
|--------|----------------------|
| -q     | quiet mode           |
| -x     | exit 1 if lint fails |

```shell
travis lint -x .travis.yml
```

```shell
travis endpoint --org --set-default
```

```shell
travis login
```

Set up this token in github:

```shell
travis login --github-token
```

Set up token in `.netrc`:

```shell
travis login --auto
```

```shell
travis monitor -r <repo1> -r <repo2>
```

| Switch | Description    |
|--------|----------------|
| -n     | all my repos   |
| -m     | notify desktop |

Left hand pan recent repo statuses:
```shell
travis whatsup
```

```shell
travis history
```

Create `.travis.yml` template for given lang:
```shell
travis init <lang>
```

```shell
travis init java
```

Restart Travis CI build from within a Git repo checkout:

```shell
travis restart
```

Make sure it is case sensitive otherwise you'll get output:

```shell
repository not known to https://api.travis-ci.org/: harisekhon/nagios-plugins
```

in local checkout's `.git/config`:
```
[travis]
    slug = HariSekhon/nagios-plugins
```

## Docker

Travis hosts containers on [Quay.io](https://quay.io/organization/travisci)

- port 22
- login:
  - user: travis
  - password: travis

Supported for the following languages:

- android
- erlang
- go
- haskell
- jvm
- node-js
- perl
- php
- python
- ruby

Hangs so don't run in foreground:

```shell
docker run -d -p 2222; 22 --name travis-${TRAVIS_LANGUAGE} quay.io/travisci/travis-${TRAVIS_LANGUAGE}
```
```shell
ssh -p 2222 travis@$HOST # pw travis
```
or
```shell
docker exec travis-${TRAVIS_LANGUAGE}
su - travis
```

## Troubleshooting

Launch a debug VM

Username + Password for GitHub:

```shell
travis login --org --auto
travis token --org
```

This should be the last bit of the url, eg.
```
https://travis-ci.org/HariSekhon/nagios-plugin-kafka/jobs/144678953
```

means

```shell
JOB_ID=144678953
export JOB_ID
```

```shell
export TRAVIS_TOKEN=$(travis token --org | awk '{print $2}')
```

```shell
echo "Travis token is $TRAVIS_TOKEN"
```

```shell
curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Travis-API-Version: 3" -H "Authorization: token $TRAVIS_TOKEN" "https://api.travis-ci.org/job/$JOB_ID/debug"
```

`travis_debug()` in [.bash.d/travis_ci.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/.bash.d/travis_ci.sh)

In Web UI log, see lines

```shell
Setting up debug tools.
Preparing debug sessions.
Use the following SSH command to access the interactive debugging environment:
ssh <login_token>@ny2.tmate.io
```
SSH to the given address on the last line.

### Debug Automation

From [DevOps-Python-tools](devops-python-tools.md) repo:

- [travis_debug_session.py](https://github.com/HariSekhon/DevOps-Python-tools/blob/master/travis_debug_session.py)
  - automates creating a Travis CI interactive debug build session via the Travis API
  - tracks the creation of the debug build, parses the log and drops you in to the unique SSH shell login as soon as it's available
- [travis_last_log.py](https://github.com/HariSekhon/DevOps-Python-tools/blob/master/travis_last_log.py)
  - automates fetching the last running / completed / failed build log from Travis CI via the Travis API

###### Ported from private Knowledge Base page 2014+
