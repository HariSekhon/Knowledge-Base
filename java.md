# Java

NOT PORTED YET.

<!-- INDEX_START -->

- [Books](#books)
- [SDKman - Install and Manage Multiple Versions of Java at the same time](#sdkman---install-and-manage-multiple-versions-of-java-at-the-same-time)
- [Show Java Classpath](#show-java-classpath)
- [Inspect JAR contents](#inspect-jar-contents)
- [JKS - Java Key Store (SSL)](#jks---java-key-store-ssl)
- [Java Decompilers](#java-decompilers)
- [Libraries](#libraries)
- [JShell](#jshell)
- [JBang](#jbang)
  - [JBang CLI](#jbang-cli)
- [GraalJS](#graaljs)
- [Clojure](#clojure)
- [Memes](#memes)
  - [Books That Made You Cry](#books-that-made-you-cry)
  - [Porting Your Language to the JVM](#porting-your-language-to-the-jvm)

<!-- INDEX_END -->

## Books

[Head First Design Patterns](https://www.amazon.com/Head-First-Design-Patterns-Brain-Friendly/dp/0596007124)

## SDKman - Install and Manage Multiple Versions of Java at the same time

See [SDKman](sdkman.md) page.

## Show Java Classpath

Since the `java -cp` / `java -classpath` is one huge string of colon separated paths, it's nicer to show them one
per line using the scripts in [DevOps-Bash-tools](devops-bash-tools.md) or [DevOps-Perl-tools](devops-perl-tools.md)
repos:

```shell
java_show_classpath.sh
```

```shell
java_show_classpath.pl
```

Crude shell pipeline to do similar:

```shell
ps -ef |
grep java |
tee /dev/stderr |
awk '{print $2}' |
xargs -L1 jinfo |
grep java.class.path  |
tr ':' '\n'
```

although if it's just `jinfo` you're missing in the `$PATH` it would be better to just:

```shell
PATH="$PATH:/path/to/bin/containing/jinfo" java_show_classpath.sh
```

## Inspect JAR contents

Java jar files are just tars of the byte-compiled Java classes.

You can inspect them using the good old unix tar command, eg.:

```shell
jar tf mysql-connector-j-*.jar
```

or

```shell
tar tvf mysql-connector-j-*.jar
```

The directory layout of the class files corresponds to the class hierarchy eg.
is accessed as `com.mysql.jdbc.Driver` in Java code.

## JKS - Java Key Store (SSL)

See [SSL](ssl.md) doc.

## Java Decompilers

Use these to decompile JAR or .class files to read the Java source code.

Using [DevOps-Bash-tools](devops-bash-tools.md) repo:

For a GUI:

```shell
jd_gui.sh "$jar_or_class_file"
```

or

```shell
bytecode_viewer.sh
```

For command line output:

```shell
cfr.sh "$jar_or_class_file"
```

or

```shell
procyon.sh "$jar_or_class_file"
```

## Libraries

Some libraries of interest:

- [Faker](https://github.com/DiUS/java-faker) - generates fake but realistic data for unit testing

## JShell

Command line or interactive Java Shell.

Java 9+:

```shell
$ jshell
|  Welcome to JShell -- Version 21.0.4
|  For an introduction type: /help intro

jshell>
```

See also [Groovy](groovy.md) which is one of my favourite languages and has a shell:

```shell
groovysh
```

## JBang

<https://www.jbang.dev/>

<https://github.com/jbangdev>

Packages executable self-contained source-only Java programs.

Install using [SDKman](sdkman.md):

```shell
sdk install jbang
```

Create a source code CLI program:

```shell
jbang init -t cli hellocli.java
```

Reading the source code it shebangs `jbang` and annotates the class with some metadata for jbang.

The first run downloads the dependencies mentioned in the source code

```shell
$ ./hellocli.java --help
[jbang] Resolving dependencies...
[jbang]    info.picocli:picocli:4.6.3
[jbang] Dependencies resolved
[jbang] Building jar for hellocli.java...
Usage: hellocli [-hV] <greeting>
hellocli made with jbang
      <greeting>   The greeting to print
  -h, --help       Show this help message and exit.
  -V, --version    Print version information and exit.
```

```shell
$ ./hellocli.java JBANG!
Hello JBANG!
```

Automatic fetches any dependencies referenced in the source code using `//DEPS group:artifact:version` comments
or `@Grab` annotations.

Even downloads a JDK if needed.

This makes portable Java scripting easier.

### JBang CLI

```shell
jbang -c 'Java_code'
```

Example of JBang CLI using Faker library to output random names:

```java
// DEPS com.github.javafaker.javafaker:1.0.2

import com.github.javafaker.Faker

Faker faker = new Faker()
```

```java
cat > /tmp/faker.java <<EOF
//usr/bin/env jbang "$0" "$@" ; exit $?
//DEPS com.github.javafaker:javafaker:1.0.2

import com.github.javafaker.Faker;
import java.util.stream.Stream;

public class faker {
    public static void main(String[] args) {
      Faker faker = new Faker();
      Stream.generate(faker.name()::fullName)
          .filter(s -> s.contains("Hari"))
          .forEach(s -> System.out.println(s + " is Awesome"));
    }
}
EOF
```

```shell
jbang /tmp/faker.java
```

<!-- doesn't work, debug later

Using the JBang catalog:

```shell
jbang -s faker@jbangdev -c \
  'Stream.generate(faker.name()::FullName).filter(s->s.contains("Hari")).forEach(s -> println(s + " is Awesome"))''
```

-->

See also [Groovy](groovy.md) which is one of my favourite languages and wish I had more excuses to code it in other
than:

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Jenkins&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Jenkins)

## GraalJS

:octocat: [oracle/graaljs](https://github.com/oracle/graaljs)

JavaScript engine running on JVM via GraalVM.

ECMAScript-compliant runtime to execute JavaScript and Node.js applications on JVM with benefits of GraalVM stack
including interoperability with Java.

## Clojure

<https://clojure.org/>

Just a jar, no dependency like Scala predef.

```shell
java -jar my.jar
```

## Memes

### Books That Made You Cry

![Books That Made You cry](images/books_that_made_you_cry_java_data_structures.jpeg)

### Porting Your Language to the JVM

![Porting Your Language to the JVM](images/orly_porting_your_language_to_jvm.png)

**Ported from various private Knowledge Base pages 2010+**
