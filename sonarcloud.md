# SonarCloud

Cloud hosted version of [SonarQube](sonarqube.md).

<!-- INDEX_START -->

- [SonarCloud Config](#sonarcloud-config)
- [Generate an IntelliJ config for SonarLint plugin](#generate-an-intellij-config-for-sonarlint-plugin)

<!-- INDEX_END -->

## SonarCloud Config

When you add to SonarCloud web UI and add your project it'll give you a sample config, which should look like this:

From [DevOps-Bash-tools - sonar-project.properties](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/sonar-project.properties):

```properties
sonar.host.url=https://sonarcloud.io

# Required metadata
sonar.organization=harisekhon
sonar.projectName=DevOps-Bash-tools
sonar.projectKey=HariSekhon_DevOps-Bash-tools
sonar.projectVersion=1.0

sonar.projectDescription=DevOps-Bash-tools

# Some nice optional bits to add for the UI
sonar.links.homepage=https://github.com/HariSekhon/DevOps-Bash-tools
sonar.links.scm=https://github.com/HariSekhon/DevOps-Bash-tools
sonar.links.issue=https://github.com/HariSekhon/DevOps-Bash-tools/issues
sonar.links.ci=https://github.com/HariSekhon/DevOps-Bash-tools/actions

# directories to scan (defaults to sonar-project.properties dir otherwise)
sonar.sources=.

#sonar.language=py

sonar.sourceEncoding=UTF-8

#sonar.exclusions=**/tests/**
sonar.exclusions=**/zookeeper-*/**/*
```

## Generate an IntelliJ config for SonarLint plugin

From the above config you can easily generate the [IntelliJ](intellij.md) SonarLint plugin connected config like this:

```shell
org="$(awk -F= '/^[[:space:]]*sonar.organization/{print $2}' sonar-project.properties | sed 's/[[:space:]]//g')"
project_key="$(awk -F= '/^[[:space:]]*sonar.projectKey/{print $2}' sonar-project.properties | sed 's/[[:space:]]//g')"

mkdir -p -v .sonarlint

cat << EOF > .sonarlint/connectedMode.json
{
    "sonarCloudOrganization": "$org",
    "projectKey": "$project_key"
}
EOF

cat .sonarlint/connectedMode.json
```
