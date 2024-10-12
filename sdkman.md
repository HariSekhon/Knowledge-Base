# SDKman

SDK Manager installs and manages multiple versions od JDKs for things like Java,
Groovy, Scala, Kotlin and related build systems Maven, Gradle, SBT, Ant etc.

It has in recent years even extended to some Java-based products like
[Hadoop](hadoop.md),
Flink,
ActiveMQ,
Grails,
Tomcat,
JMeter

<!-- INDEX_START -->

- [Install SDKman](#install-sdkman)
- [How It Works Under the Hood](#how-it-works-under-the-hood)
- [Using SDKman](#using-sdkman)
  - [Help](#help)
  - [Update list of SDKs available to install:](#update-list-of-sdks-available-to-install)
  - [List Java versions](#list-java-versions)
  - [Install the latest Java SDK](#install-the-latest-java-sdk)
  - [Install another SDK version](#install-another-sdk-version)
  - [Switch to use another SDK Version](#switch-to-use-another-sdk-version)
  - [List all the selected SDKs](#list-all-the-selected-sdks)
  - [Delete a version of Java JDK installed](#delete-a-version-of-java-jdk-installed)

<!-- INDEX_END -->

## Install SDKman

```shell
curl -s "https://get.sdkman.io" | bash
```

Add SDKman to `$PATH`:

```shell
source "$HOME/.sdkman/bin/sdkman-init.sh"
```

Will usually add something like this to the end of your `$HOME/.bash_profile` login profile script:

```shell
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/hari/.sdkman"
[[ -s "/Users/hari/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/hari/.sdkman/bin/sdkman-init.sh"
```

## How It Works Under the Hood

Future shells will then automatically call `/Users/hari/.sdkman/bin/sdkman-init.sh` to add paths like this:

```none
/Users/hari/.sdkman/candidates/scala/current/bin
/Users/hari/.sdkman/candidates/sbt/current/bin
/Users/hari/.sdkman/candidates/maven/current/bin
/Users/hari/.sdkman/candidates/java/current/bin
/Users/hari/.sdkman/candidates/groovy/current/bin
/Users/hari/.sdkman/candidates/gradle/current/bin
```

early in your `$PATH` list to default to using whatever version of each SDK SDKman has installed and switched to
internally via symlinks in each case to:

```
/Users/hari/.sdkman/candidates/<name>/<version>
```

and are atomically switched to different versions by the `sdk use` command.

## Using SDKman

### Help

Show list of commands:

```shell
sdk help
```

### Update list of SDKs available to install:

```shell
sdk update
```

### List Java versions

```shell
sdk list java
```

### Install the latest Java SDK

```shell
sdk install java
```

(can also shorten to `sdk i java`)

### Install another SDK version

```shell
sdk install java <version>
```

### Switch to use another SDK Version

```shell
sdk use java <version>
```

### List all the selected SDKs

```shell
sdk current
```

output:

```none
Using:

gradle: 7.3.3
groovy: 4.0.0
java: 21.0.4-tem
maven: 3.8.4
sbt: 1.6.2
scala: 3.1.1
```

### Delete a version of Java JDK installed

```shell
sdk rm java 17.0.1-tem
```

```shell
sdk rm java 21.0.4-tem
```

```none
Deselecting java 21.0.4-tem...

Uninstalling java 21.0.4-tem...
```
