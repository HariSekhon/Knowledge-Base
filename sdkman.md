# SDKman

SDK Manager installs and manages multiple versions of JDKs.

Originally it was just for JDK languages and their main build systems,
but has in recent years extended to a wider list of support technologies:

- JDK languages - Java, Groovy, Scala, Kotlin
- JDK related build systems - Maven, Gradle, SBT, Ant
- JDK based frameworks - Grails, Spring Boot, JBang
- JDK based products - [Hadoop](hadoop.md), [Spark](spark.md), Flink, ActiveMQ, Tomcat, JMeter, VisualVM etc.

<!-- INDEX_START -->

- [Install SDKman](#install-sdkman)
- [How It Works Under the Hood](#how-it-works-under-the-hood)
- [Using SDKman](#using-sdkman)
  - [Help](#help)
  - [Update list of SDKs available to install:](#update-list-of-sdks-available-to-install)
  - [List all products SDKman can install](#list-all-products-sdkman-can-install)
  - [List Java versions](#list-java-versions)
  - [Install the latest Java SDK](#install-the-latest-java-sdk)
  - [Install another SDK version](#install-another-sdk-version)
  - [Switch to use another SDK Version](#switch-to-use-another-sdk-version)
  - [List all the selected SDKs](#list-all-the-selected-sdks)
  - [List the Version of a Specific SDK](#list-the-version-of-a-specific-sdk)
  - [Delete a version of Java JDK installed](#delete-a-version-of-java-jdk-installed)
  - [Clean up temp space](#clean-up-temp-space)
- [Troubleshooting](#troubleshooting)
  - [Internet Not Reachable despite being online](#internet-not-reachable-despite-being-online)
  - [Can't Find Java Version to Install That is Clearly There](#cant-find-java-version-to-install-that-is-clearly-there)

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

```text
/Users/hari/.sdkman/candidates/scala/current/bin
/Users/hari/.sdkman/candidates/sbt/current/bin
/Users/hari/.sdkman/candidates/maven/current/bin
/Users/hari/.sdkman/candidates/java/current/bin
/Users/hari/.sdkman/candidates/groovy/current/bin
/Users/hari/.sdkman/candidates/gradle/current/bin
```

early in your `$PATH` list to default to using whatever version of each SDK SDKman has installed and switched to
internally via symlinks in each case to:

```text
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

### List all products SDKman can install

```shell
sdk list
```

(or `sdk ls`)

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

(or `sdk c`)

Output:

```text
Using:

gradle: 7.3.3
groovy: 4.0.0
java: 21.0.4-tem
jbang: 0.119.0
maven: 3.8.4
pomchecker: 1.13.0
sbt: 1.6.2
scala: 3.1.1
visualvm: 2.1.10
```

### List the Version of a Specific SDK

```shell
sdk current java
```

Output:

```text
Using java version 21.0.4-tem
```

### Delete a version of Java JDK installed

```shell
sdk rm java 21.0.4-tem
```

```text
Deselecting java 21.0.4-tem...

Uninstalling java 21.0.4-tem...
```

### Clean up temp space

```shell
sdk flush
```

Output:

```text
       9 archive(s) flushed, freeing 619M       /Users/hari/.sdkman/archives.
      20 archive(s) flushed, freeing 104K       /Users/hari/.sdkman/tmp.
       9 archive(s) flushed, freeing  48K       /Users/hari/.sdkman/var/metadata.
```

## Troubleshooting

### Internet Not Reachable despite being online

If you get this error:

```text
$ sdk list
==== INTERNET NOT REACHABLE! ===================================================

 Some functionality is disabled or only partially available.
 If this persists, please enable the offline mode:

   $ sdk offline

================================================================================

This command is not available while offline.
```

Check your connection like this:

```shell
curl -I https://api.sdkman.io/2/healthcheck
```

```text
HTTP/1.1 200 OK
Server: nginx/1.19.10
Date: Thu, 27 Feb 2025 08:02:39 GMT
Content-Type: application/octet-stream
Content-Length: 24
Connection: keep-alive
Content-Type: text/plain
```

Check if SDKman can fetch the list manually:

```text
curl -s https://api.sdkman.io/2/candidates/all
```

```text
activemq,ant,asciidoctorj,ballerina,bld,bpipe,btrace,concurnas,connor,coursier,cuba,cxf,detekt,doctoolchain,flink,gaiden,gcn,grace,gradle,gradleprofiler,grails,groovy,groovyserv,hadoop,helidon,hsc,http4k,infrastructor,jarviz,java,jbake,jbang,jetty,jextract,jikkou,jmc,jmeter,joern,jreleaser,karaf,kcctl,ki,kobweb,kotlin,kscript,ktx,layrry,leiningen,liquibase,maven,mcs,micronaut,mulefd,mvnd,mybatis,neo4jmigrations,pierrot,pomchecker,quarkus,sbt,scala,scalacli,schemacrawler,skeletal,spark,springboot,sshoogr,taxi,test,tomcat,toolkit,vertx,visualvm,webtau,znai
```

Clear SDKman cache and then retry `sdk list`:

```shell
sdk flush candidates
rm -rf ~/.sdkman/var
sdk list
```

If all else fails:

```shell
rm -fr ~/.sdkman
```

and then re-install:

```shell
curl -s "https://get.sdkman.io" | bash
```

### Can't Find Java Version to Install That is Clearly There

```shell
sdk current
```

```text
Using:

java: 21.0.6-tem
```

```shell
sdk install java 21.0.6-tem
```

```text
Stop! java 21.0.6-tem is not available. Possible causes:
 * is an invalid version
 * java 21.0.6-tem binaries are incompatible with your platform
 * java 21.0.6-tem has not been released yet

Tip: see all available versions for your platform:

  $ sdk list java 21.0.6-tem
```

Launch a new shell - it is a state problem with SDKman.
