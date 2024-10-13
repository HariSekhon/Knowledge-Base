# SonarQube

Leading open source code quality tool.

<https://www.sonarsource.com/open-source-editions/sonarqube-community-edition/>

<!-- INDEX_START -->

- [Config](#config)
  - [SonarCloud](#sonarcloud)
- [SonarQube on Kubernetes](#sonarqube-on-kubernetes)
- [SonarQube Plugins](#sonarqube-plugins)
- [Sonar Scanner CLI](#sonar-scanner-cli)
  - [Download Sonar Scanner](#download-sonar-scanner)
  - [Create `sonar-project.properties` from template](#create-sonar-projectproperties-from-template)
  - [Back up the config first](#back-up-the-config-first)
  - [Replace the `sonar.host.url` with the docker address](#replace-the-sonarhosturl-with-the-docker-address)
  - [Run Sonar Scanner](#run-sonar-scanner)

<!-- INDEX_END -->

## Config

The `sonar.properties` config should be at the top of a repo - example configs:

[HariSekhon/lib-java sonar-project.properties](https://github.com/HariSekhon/lib-java/blob/master/sonar-project.properties)

[Nagios-Plugin-Kafka - sonar-project.properties](https://github.com/HariSekhon/Nagios-Plugin-Kafka/blob/master/sonar-project.properties)

[HariSekhon/Nagios-Plugins - sonar-project.properties](https://github.com/HariSekhon/Nagios-Plugins/blob/master/sonar-project.properties)

[HariSekhon/DevOps-Bash-tools - sonar-project.properties](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/sonar-project.properties)

[HariSekhon/DevOps-Python-tools - sonar-project.properties](https://github.com/HariSekhon/DevOps-Python-tools/blob/master/sonar-project.properties)

### SonarCloud

`.sonarcloud.properties` - also at the top of repo:

```shell
sonar.host.url=https://sonarcloud.io
```

<https://docs.sonarqube.org/10.0/devops-platform-integration/github-integration/>

## SonarQube on Kubernetes

[HariSekhon/Kubernetes-configs - sonarqube](https://github.com/HariSekhon/Kubernetes-configs/tree/master/sonarqube)

Comparison to last triggered only for pull between branches - everyone has to develop on their own branch.

SonarLint plugin in [IntelliJ](intellij.md) for on-the-fly feedback of new bugs and quality issues.

Default username/password: `admin/admin`

Free hosted instance:

<https://sonarqube.com/dashboard/index>

Local Docker instance:

```shell
docker run -d --name sonar-postgres \
              -e POSTGRES_USER=sonar \
              -e POSTGRES_PASSWORD=sonarpw \
              postgres
```

Don't map `-p 5432` in case we have more than one postgres container, so check via temporary container psql:

```shell
docker run -ti --rm --link sonar-postgres postgres sh \
      -c 'exec psql -h "$SONAR_POSTGRES_PORT_5432_TCP_ADDR" -p "$SONAR_POSTGRES_PORT_5432_TCP_PORT" -U sonar'
```

This would run with in-built H2 database which is not recommended

```shell
#docker run -d --name sonarqube \
            -p 9000:9000 \
            -p 9092:9092 \
            sonarqube # :5.1
```

```shell
docker run -d --name sonarqube \
              --link sonar-postgres:pgsonar \
              -p 1026:9000 \
              -e SONARQUBE_JDBC_URL=jdbc:postgresql://pgsonar:5432/sonar \
              -e SONARQUBE_JDBC_USERNAME=sonar \
              -e SONARQUBE_JDBC_PASSWORD=sonarpw \
              sonarqube # :5.1
```

## SonarQube Plugins

`Administration` -> `System` -> `Update Center` -> `Available`:

- CheckStyle
- Findbugs
- Groovy
- Java Properties
- PMD
- Puppet
- Python
- XML

-> `Restart` button at top to install plugins

Scoverage plugin?

## Sonar Scanner CLI

### Download Sonar Scanner

```shell
export SONAR_VERSION=2.6.1 &&
cd /usr/local &&
wget "https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-$SONAR_VERSION.zip" &&
unzip "sonar-scanner-$SONAR_VERSION" &&
ln -sv sonar-scanner "sonar-scanner-$SONAR_VERSION"
```

### Create `sonar-project.properties` from template

<https://github.com/HariSekhon/Templates/blob/master/sonar-project.properties>

```shell
wget -nc https://raw.githubusercontent.com/HariSekhon/Templates/master/sonar-project.properties
```

### Back up the config first

```shell
cp -av sonar-scanner/conf/sonar-scanner.properties{,.bak.$(date '+%F_%H%S')}
```

### Replace the `sonar.host.url` with the docker address

```shell
sed -i 's/#sonar.host.url.*/sonar.host.url=http:\/\/docker:1026/' sonar-scanner/conf/sonar-scanner.properties
```

Optional arg:

```text
-Dsonar.verbose=true
```

### Run Sonar Scanner

```shell
sonar-scanner
```

Now see SonarQube dashboard.

**Ported from private Knowledge Base page 2016+**
