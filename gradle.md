# Gradle

<https://gradle.org/>

Newer JVM build system written in Groovy with a nicer build configuration file `build.gradle`.

Good replacement for [Maven](maven.md).

<!-- INDEX_START -->
- [Summary](#summary)
- [Plugins](#plugins)
- [Uber jar](#uber-jar)
- [SonarQube](#sonarqube)
- [VersionEye](#versioneye)
- [Gradle Wrapper](#gradle-wrapper)
- [build.gradle](#buildgradle)
<!-- INDEX_END -->

## Summary

- good docs
- good plugin support
- easy to work with
- Gradle Wrapper `./gradlew` shell script for guaranteed Gradle version download for compatibility

See Gradle cookbook.

Gradle Daemon runs in the background:

```shell
gradle --stop
```

or if changing versions, gradle only manages its current version, so:

```shell
pkill -f org.gradle.launcher.daemon.bootstrap.GradleDaemon
```

## Plugins

Adds support for compiling languages:

```shell
apply plugin: 'java'
apply plugin: 'scala'
apply plugin: 'groovy'
```

adds `install` task for publishing to Maven repo, generates poms under `build/poms/`:

```groovy
apply plugin: 'maven'
```

There is also a factory method for generating the pom without uploading to a Maven repo:

see <https:docs.gradle.org/current/userguide/maven_plugin.html#N13A3E>

executable jar:

```groovy
apply plugin: 'application'
mainClassName = 'com.linkedin.harisekhon.Main'
```

## Uber jar

- ShadowJar
- Application plugin

# SonarQube

<http:docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner+for+Gradle>

A build.gradle plugin.

Configure `~/.gradle/gradle.properties`:

```groovy
systemProp.sonar.host.url
# optionally
systemProp.sonar.login
systemProp.sonar.password
```

```shell
gradle sonarqube -Dsonar.host.url=http:sonar.mycompany.com \
                 -Dsonar.jdbc.password=myPassword \
                 -Dsonar.verbose=true
```

## VersionEye

See [HariSekhon/lib-java](https://github.com/HariSekhon/lib-java):

`build.gradle`:

```groovy
plugins { id "org.standardout.versioneye" version "1.4.0" }
```

`gradle.properties`:

```groovy
versioneye.projectid=<long_num_from_project_page_no_spaces>
```
```shell
gradle versionEyeUpdate
```

## Gradle Wrapper

Generates:

- `gradlew` / `gradlew.bat` scripts
- `gradle/wrapper/gradle-wrapper.jar`
  - stub program that downloads the exact same version of gradle recorded in `gradle-wrapper.properties` as you just
ran or the version specifed by `--gradle-version` eg. `2.0`
- `gradle/wrapper/gradle-wrapper.properties`

All of the above should be checked in to revision control.

```shell
gradle wrapper
```

```shell
git add -f gradlew gradlew.bat gradle/
git ci -m "added gradle wrapper"
```

In future gradle commands just substitute `gradle` for `./gradlew`.

This downloads same gradle version as original builder to

```
.gradle/wrapper/dists/gradle-2.11-bin/
```

and uses that:

```shell
./gradlew ...
```


## build.gradle

Create `build.gradle` - will port existing `pom.xml` if found:

```shell
gradle init
```

- must specify `rootProject.name` otherwise taken to be name of containing directory which can be random on CI systems
- `name = property` is read-only in `build.gradle`

`settings.gradle`:

```
rootProject.name = 'harisekhon-utils'
```

[HariSekhon/Templates - build.gradle](https://github.com/HariSekhon/Templates/blob/master/build.gradle)

build.gradle structure:

- project
  - tasks

```shell
gradle --help
```

Show list of available tasks:

```shell
gradle tasks
```

Gradle build is equivalent to `gradle check assemble` - creates artifacts in `build/libs/`:

```shell
gradle build
```

Requires `maven` plugin - create artifacts + installs to `~/.m2/repository`:

```shell
gradle install
```

`build/`
  - dependencies_cache
  - libs - find jar artifact here
  - reports/tests - open index.html for breakdown of unit tests

All verification tasks, including `test`. Some plugins add more checks (eg. CheckStyle):

```shell
gradle check
```

Create archives / jars:

```shell
gradle assemble
```

Show tree graph of dependencies for different stages, test:

```shell
gradle dependencies
```

###### Ported from private Knowledge Base page 2016+
