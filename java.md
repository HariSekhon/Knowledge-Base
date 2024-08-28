# Java

NOT PORTED YET.

<!-- INDEX_START -->

- [Show Java Classpath](#show-java-classpath)
- [Inspect JAR contents](#inspect-jar-contents)
- [Clojure](#clojure)

<!-- INDEX_END -->

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
tar tvf mysql-connector-j-*.jar
```

The directory layout of the class files corresponds to the class hierarchy eg.
is accessed as `com.mysql.jdbc.Driver` in Java code.

## Java Decompile .class files

Using [DevOps-Bash-tools](devops-bash-tools.md) repo:

For a GUI:

```shell
jd_gui.sh "$jar_or_class_file"
```

Output the Java code on the command line:

```shell
cfr.sh "$jar_or_class_file"
```

## Clojure

<https://clojure.org/>

Just a jar, no dependency like Scala predef.

```shell
java -jar my.jar
```

**Ported from various private Knowledge Base pages 2010+**
