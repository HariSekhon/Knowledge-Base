# Maven

<https://maven.apache.org/>

The standard Java build tool.

Uses an XML configuration file `pom.xml` at the root of the project directory and a `mvn` command to build `.jar`
package files.

<!-- INDEX_START -->
<!-- INDEX_END -->

## Real World Example `pom.xml` builds

[HariSekhon/Nagios-Plugin-Kafka - pom.xml](https://github.com/HariSekhon/Nagios-Plugin-Kafka/blob/master/pom.xml)

[HariSekhon/lib-java - pom.xml](https://github.com/HariSekhon/lib-java/blob/master/pom.xml)

### Best practice for release version incrementing

https://maven.apache.org/guides/mini/guide-releasing.html

```shell
mvn release:prepare ...
```

```shell
mvn release:perform...
```

Dependencies are downloaded to the local `~/.m2/repository` directory.

Maven shaded jars (monolithic jars containing all dependencies)

## Executable Jar

```xml
<plugin>
  <groupid>org.apache.maven.plugins</groupid>
  <artifactid>maven-jar-plugin</artifactid>
  <version>2.4</version>
  <configuration>
    <archive>
    <manifest>
      <mainclass>com.harisekhon.linkedin.MyApp</mainclass>
    </manifest>
   </archive>
 </configuration>
</plugin>
```

## Maven Shade

Executable Jars:

- ManifestResourceTransformer:
- `<Main-Class>com.domain.class</Main-Class>`
- can also put an integer `<key>value</key>` in the `.pom.xml` too

XXX: see Relocating Classes page in Maven docs

```xml
<configuration>
  <relocations>
    <relocation>
      <pattern>org.blah</pattern>
      <shadedPattern>org.shaded.blah</shadedPattern>
    </relocation>
  </relocations>
</configuration>
```

XXX: Fix Eclipse build path to support Maven local repository:

Eclipse -> `Preferences`
-> `Java`
-> `Build Path`
-> `Classpath Variables`
-> `New`
-> `M2_REPO`
-> `/Users/hari/.m2/repository`

## Surefire

Calls unit tests.

## Maven Wrapper

<https://github.com/takari/maven-wrapper>

- Generates `mvnw` / `mvn.bat` wrapper scripts (should be committed to git)
- Downloads `.mvn/wrapper/maven-wrapper.jar`
- wrapper scripts download version specified in `maven-wrapper.properties`
  - (defaults to same version used to generate the wrapper)
- downloads to `.m2/wrapper/dists/apache-maven-3.3.3-bin`

Generate the `mvnw`, optionally set version explicitly:

```shell
mvn -N io.takari:maven:wrapper  # -Dmaven=3.3.3
```

```shell
git add -f .mvn mvnw mvnw.cmd
```

```
git ci -m "added maven wrapper"
```

Now just use the `./mvnw` command instead of `mvn`.

It will then download use the same version of Maven as the original:

```shell
./mvnw clean package
```

## Sonar Plugin

<http://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner+for+Maven>

See `~/.m2/settings.xml` which contains `docker:1026` address of SonarQube

```shell
mvn sonar:sonar
```

## VersionEye

[HariSekhon/lib-java - pom.xml](https://github.com/HariSekhon/lib-java/blob/master/pom.xml)

```shell
mvn versioneye:help
```

Check API connectivity:

```shell
mvn versioneye:ping
```

Show dependencies:

```shell
mvn versioneye:list
```

or `VERSIONEYE_API_KEY` environment variable - good for CI systems:

```shell
echo "api_key=xxxxxxxxxxx" >> ~/.m2/versioneye.properties
```

Put the projectId in the pom under plugin configuration, see
[HariSekhon/lib-java - pom.xml](https://github.com/HariSekhon/lib-java/blob/master/pom.xml).

Send the dependency updates to the VersionEye API:

```shell
mvnw versioneye:update
```

Check + send security package updates:

```shell
mvn versioneye:securityCheck
```

## Polyglot Maven

<https://github.com/takari/polyglot-maven>

- allows to write POM in languages other than XML
- eg. Groovy, Scala, Ruby, Clojure, Atom, Yaml
- can convert POMs between XML and the different formats

## Maven Coordinates

```
groupid:artifactid:packaging:version
```

packaging == jar

version   == `1.0-SNAPSHOT` by default

## Maven Repositories

Web server structure:

```
/<groupId>/<artifactId>/<version>/<artifact>-<version>.<packaging>
```

`~/.m2/settings.xml`:

```
/repository/org/org.elasticsearch/elasticsearch/<version>/elasticsearch-<version>.jar
...
/repository/org/org.apache.hadoop/hadoop-client/<version>/hadoop-client-<version>.jar
hadoop-client-<version>.jar.sha1
hadoop-client-<version>.pom             # This pom allows Maven to resolve transitive dependencies automatically
hadoop-client-<version>.pom.sha1
```

For proxy put this in `~/.m2/settings.xml`, replacing `$SHELL_VARIABLES` with their literals:

(`JAVA_OPTS` didn't work)

```shell
MAVEN_OPTS="-Dhttp.proxyHost=proxyhost -Dhttp.proxyPort=8080 -Dhttps.proxyHost=proxyhost -Dhttps.proxyPort=8080 ..."
```

```xml
<settings>
  ...
  <proxies>
    <proxy>
      <id>myHttpProxy</id>
      <active>true</active>
      <protocol>http</protocol>
      <host>$PROXY_HOST</host>
      <port>$PROXY_PORT</port>
      <username>$USERNAME</username>
      <password>$PASSWORD</password>
      <nonProxyHosts>127.0.0.1|10.*|172.16.*|192.168.*|*.localdomain|*.local</nonProxyHosts>
    </proxy>
    <proxy>
      <id>myHttpsProxy</id>
      <active>true</active>
      <protocol>https</protocol>
      <host>$PROXY_HOST</host>
      <port>$PROXY_PORT</port>
      <username>$USERNAME</username>
      <password>$PASSWORD</password>
      <nonProxyHosts>127.0.0.1|10.*|172.16.*|192.168.*|*.localdomain|*.local</nonProxyHosts>
    </proxy>
  </proxies>
  ...
</settings>
```

See also [Artifact Registries](artifact-registries.md).

## Stop wasting time downloading newer Snapshots

```xml
<repository>
  <id>blah</id>
  <!--
  <releases>
      <updatePolicy>never</updatePolicy>
  </releases>
  -->
  <snapshots>
  <updatePolicy>never</updatePolicy>
  </snapshots>
</repository>
```

## Phases

Each phase executes all previous phases

`plugin:goal` is often bound to a phase of the lifecycle

```shell
mvn <phase>                 mvn <plugin:goal>
process-resources           resources:resources     # fetches dependencies using Maven coordinates from repositories
compile                     compiler:compile
process-classes
process-test-resources      resources:testResources
test-compile                compiler:testCompile
test                        surefire:test
prepare-package
package                     jar:jar
install
site  # generates reports under target/site/index.html from src/site
```

## Help

```shell
mvn help:active-profiles
```

```shell
mvn help:effective-pom
```

```shell
mvn help:effective-settings
```

```shell
mvn help:describe
```

```shell
mvn help:describe -Dplugin=help
```

Full help:

```shell
mvn help:describe -Dplugin=help -Dfull
```

Full help on only a specific goal in the plugin:

```shell
mvn help:describe -Dplugin=compiler -Dmojo=compile -Dfull
```

## Templating

From [HariSekhon/Templates](https://github.com/HariSekhon/Templates) `pom.xml` template
using [DevOps-Perl-tools](devops-perl-tools.md) `new.pl` (aliased to just `new` in
[DevOps-Bash-tools](devops-bash-tools.md) `.bashrc`)

```shell
new pom.xml
```

This will instantiate a new `pom.xml` files while inferring NAME from directory.

-B batch mode doesn't prompt you for which archetype and version,
accepts default Quickstart archetype and latest version 1.1

```shell
#mvn archetype:generate -DgroupId=HariSekhon.Utils -DpackageName=HariSekhon -DartifactId=Utils -Dversion=0.1
```

package defaults to groupId:

```shell
mvn archetype:generate -DgroupId=HariSekhon -DartifactId=Utils -Dversion=0.1
```

generates:
```none
Utils/
Utils/pom.xml
/src/main/
/main/java/HariSekhon/App.java
/src/test/
/test/java/HariSekhon/AppTest.java
```

```shell
mvn install
```

## Maven Exec

Use `exec-maven-plugin` from org.codehaus.mojo, add to `pom.xml`:

```xml
<plugin>
  <groupId>org.codehaus.mojo</groupId>
  <artifactId>exec-maven-plugin</artifactId>
  <version>1.5.0</version>
  <configuration>
  <mainClass>com.linkedin.harisekhon.kafka.CheckKafka</mainClass>
  </configuration>
</plugin>
```

```shell
mvn exec:java -Dexec.mainClass=org.apache.blah.something.Main -Dexec.args="<args>"
```

Can skip exec.mainClass if specifying in the pom.xml configuration section:

```shell
mvn exec:java -Dexec.args="<args>"
```

## Dependencies

```shell
mvn dependency:resolve
```

```shell
mvn dependency:tree
```

```shell
mvn install -X  # debug flag shows what dependencies were resolved, which rejected etc..
```

## Test

```shell
mvn test # executes all JUnit tested under src/test/java/**/Test*.java
```

occasionally ignore errors to get build a test:

```shell
mvn test -Dmaven.test.failure.ignore=true
```

## Taken from HBase

```shell
mvn assembly:assembly
```

HBase tests take >1hr to complete, skip them using `-DskipTests`:

```shell
mvn -DskipTests assembly:assembly
```

## Maven Eclipse support

Import in to Eclipse:

```shell
mvn -Declipse.workspace="$HOME/workspace" \
      eclipse:configure-workspace \
      eclipse:eclipse
```

from: <http://blog.cloudera.com/blog/2012/08/developing-cdh-applications-with-maven-and-eclipse/>

Downloads dependencies to `~/.m2/repository` and writes project's top level `.classpath` file for Eclipse pointing to `.m2/repository`
then go to Eclipse -> Right click project -> Refresh to pick up the new .classpath

```shell
mvn eclipse:clean
```

```shell
mvn eclipse:eclipse
```

Don't use this any more, just `install` to `.m2/repository`:

```shell
mvn deploy:deploy-file -Durl=file://$PWD/../repo \
                       -Dfile=$(echo target/harisekhon-utils-*.jar) \
                       -DgroupId=com.linkedin.harisekhon \
                       -DartifactId=utils \
                       -Dpackaging=jar \
                       -Dversion=1.0
```

###### Ported from private Knowledge Base page 2013+
