# SBT

Simple Build Tool / Scala Build Tool

<https://www.scala-sbt.org/>

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Build File - `build.sbt`](#build-file---buildsbt)
- [Usage](#usage)
  - [Create jar](#create-jar)
  - [Create self-contained 'uber jar' with all dependencies included using Assembly plugin](#create-self-contained-uber-jar-with-all-dependencies-included-using-assembly-plugin)
  - [Interactive Console - REPL](#interactive-console---repl)
  - [Watch `src/` + Auto-Trigger](#watch-src--auto-trigger)
  - [Use the Ivy cache](#use-the-ivy-cache)
  - [Compile the main sources in `src/main/scala` and `src/main/java`](#compile-the-main-sources-in-srcmainscala-and-srcmainjava)
  - [Compile and run all tests](#compile-and-run-all-tests)
  - [Install jar to local Ivy repository](#install-jar-to-local-ivy-repository)
  - [Install jar to local Maven repository](#install-jar-to-local-maven-repository)
  - [Push jar to remote repo (if configured)](#push-jar-to-remote-repo-if-configured)
  - [Pull down dependencies to `lib_managed/`](#pull-down-dependencies-to-libmanaged)
  - [Add task](#add-task)
- [Eclipse](#eclipse)
  - [SBT <= 0.12](#sbt--012)
  - [SBT 0.13+](#sbt-013)
- [IntelliJ](#intellij)
- [Build.sbt](#buildsbt)

<!-- INDEX_END -->

## Key Points

- incremental compilation
- interactive shell
- uses [StackOverflow.com/tags/sbt](https://stackoverflow.com/tags/sbt) for Q&A

- tasks are Scala functions (see further below to define your own)

- slow to start, optimizes as much as it can at start as Scala can be slow to compile so it minimizes recompilation

- first run will prompt to create a project, ask for name, organization, version, scala version etc to initialize project

## Build File - `build.sbt`

The build configuration file of what dependencies to include.

### Build Configs

[HariSekhon/Nagios-Plugin-Kafka - build.sbt](https://github.com/HariSekhon/Nagios-Plugin-Kafka/blob/master/build.sbt)

[HariSekhon/lib-java - build.sbt](https://github.com/HariSekhon/lib-java/blob/master/build.sbt)

[HariSekhon/Templates - build.sbt](https://github.com/HariSekhon/Templates/blob/master/build.sbt)

```shell
wget -nc https://raw.githubusercontent.com/HariSekhon/Templates/master/build.sbt
```

## Usage

```shell
sbt help
```

```shell
sbt tasks
```

```shell
sbt clean
```

### Create jar

```shell
sbt package
```

### Create self-contained 'uber jar' with all dependencies included using Assembly plugin

Useful for both CLIs and distributed computing programs running on big data clusters.

`project/assembly.sbt`:

```sbt
// for SBT 0.13.6+
addSbtPlugin("com.eed3si9n" % "sbt-assembly" % "0.13.0")
// for SBT < 0.13.6
//addSbtPlugin("com.eed3si9n" % "sbt-assembly" % "0.11.2")
```

```shell
sbt assembly
```

### Interactive Console - REPL

Launches Scala repl with all deps loaded, compiles all `src/`.

REPL = Read–Eval–Print Loop

```shell
sbt console
```

### Watch `src/` + Auto-Trigger

Use `~` to watch the `src/` dir and run the given `<command>` every time source code changes - fast, nice.

In REPL console:

```shell
~ <command>
```

Automatically run unit-tests every time `src/` code changes:

```shell
~ test
```

Only runs unit tests for the bits of code that changed:

```shell
~ testQuick
```

```shell
sbt "run <args>"
```

### Use the Ivy cache

```shell
sbt -D sbt.ivy.home=sbt/ivy package
```

Jar deps stored in:

```none
~/.ivy2/cache/org.apache.spark/spark-core_2.10/jars/spark-core_2.10-1.3.1.jar
```

### Compile the main sources in `src/main/scala` and `src/main/java`

```shell
sbt compile
```

### Compile and run all tests

```shell
sbt test
```

### Install jar to local Ivy repository

```shell
sbt publishLocal
```

### Install jar to local Maven repository

```shell
sbt publishLocal
```

### Push jar to remote repo (if configured)

```shell
sbt publish
```

### Pull down dependencies to `lib_managed/`

```shell
sbt update
```

### Add task

```scala
lazy val print = task {
  log.info("testing")
  None
}
```

## Eclipse

`sbteclipse` plugin to download deps and build project's top level .classpath file for [Eclipse IDE](editors.md).

### SBT <= 0.12

```
~/.sbt/plugins/plugins.sbt:
```

### SBT 0.13+

```shell
~/.sbt/0.13/plugins/plugins.sbt:
addSbtPlugin("com.typesafe.sbteclipse" % "sbteclipse-plugin" % "3.0.0")
```

Downloads dependencies to `~/.ivy2/cache` and writes project's top level .classpath file for Eclipse pointing to `~/.ivy/cache`.

Then go to `Eclipse -> Right click project -> Refresh` to pick up the new `.classpath`:

```shell
sbt eclipse
```

## IntelliJ

Not sure this is actually needed in new IntelliJ versions.

```sbt
~/.sbt/0.13/plugins/plugins.sbt
addSbtPlugin("com.github.mpeltonen" % "sbt-idea" % "1.6.0")
```

Run after each `build.sbt` change:

```shell
sbt gen-idea
```

## Build.sbt

```sbt
name := "MyApp"

version := "0.1"

scalaVersion := "2.10.4"

libraryDependencies ++= Seq(
// %% appends scala version to spark-core
"org.apache.spark" %% "spark-core" % "1.3.1"
"org.apache.hadoop" % "hadoop-client" % "2.6.0"
"org.elasticsearch" % "elasticsearch" % "1.4.1"
)
```

On Windows, set options like this:

```batch
setx SBT_OPTS "-Dsbt.global.base=C:/Users/hari/.sbt/0.13/ -Dsbt.ivy.home=C:/Quarantine/ivy-cache/ -Dsbt.boot.directory=C:/Quarantine/sbt/boot/ -Dsbt.override.build.repos=true -Dsbt.repository.config=C:/Users/hari/.sbt/repositories"
setx SBT_CREDENTIALS "C:/Users/hari/.sbt/.credentials"
```

### ~/.sbt/.credentials

```
realm=Sonatype Nexus Repository Manager
host=myFQDN
user=myUser
password=myPass
```

### ~/.sbt/0.13/plugins/credentials.sbt

```
credentials += Credentials(Path.userHome / ".sbt" / ".credentials")
```

### ~/.sbt/repositories

```
[repositories]
local
<name>-sbt: http://host:8081/nexus/content/groups/sbt/, [organization]/[module]/(scala_[scalaVersion]/)(sbt_[sbtVersion]/[type]s/[artifact])(-[classifier]).[ext]
<name>: http://host:8081/nexus/content/groups/public/
```

**Ported from private Knowledge Base page 2014+**
