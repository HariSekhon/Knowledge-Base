# Java

NOT PORTED YET.

Java jar files are just tars of the byte-compiled Java classes.

You can inspect them using the good old unix tar command, eg.:

```shell
tar tvf mysql-connector-j-*.jar
```

The directory layout of the class files corresponds to the class hierarchy eg.
is accessed as `com.mysql.jdbc.Driver` in Java code.

### Clojure

https://clojure.org/

Just a jar, no dependency like Scala predef.

```shell
java -jar my.jar
```

###### Ported from various private Knowledge Base pages 2010+
