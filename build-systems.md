# Build Systems

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Make](#make)
- [Maven](#maven)
- [Gradle](#gradle)
- [Sbt](#sbt)
- [Bazel](#bazel)
  - [Install](#install)

<!-- INDEX_END -->

## Key Points

- [Make](https://www.gnu.org/software/make/) - simple classic, battle tested for decades. Even if you don't code you should know this to make sysadmin stuff easier
- [Maven](https://maven.apache.org/) - used mainly by Java / JVM programmers, build file is XML showing its age
- [Gradle](https://gradle.org/) - modern replacement for Maven, used mainly by Java / JVM programmers
- [SBT](https://www.scala-sbt.org/) - used mainly by Scala programmers - my least favourite of the 3 main JVM build tools
- [Bazel](https://bazel.build/) - incremental build system

## Make

See [make.md](make.md)

## Maven

See [maven.md](maven.md)

## Gradle

See [gradle.md](gradle.md)

## Sbt

See [sbt.md](sbt.md)

## Bazel

<https://bazel.build/>

- fast incremental builds tracks changes to files and only rebuilds what is necessary

### Install

On Mac you'll need XCode:

```shell
xcode-select --install
sudo xcodebuild -license accept
```

On Mac:

```shell
brew install bazel
```

Manual download:

```shell
export BAZEL_VERSION=3.2.0
curl -fLO "https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-darwin-x86_64.sh"
chmod +x "bazel-${BAZEL_VERSION}-installer-darwin-x86_64.sh"
./bazel-${BAZEL_VERSION}-installer-darwin-x86_64.sh --user  # --user installs to ~/bin and sets the .bazelrc path to ~/.bazelrc
```

In [HariSekhon/DevOps-Bash-tools](devops-bash-tools.md) repo `install/` directory you can just run this instead:

```shell
install_bazel.sh  # 3.2.0  # optional version number arg
```

Check installed:

```shell
bazel version
```

Ported from various private Knowledge Base pages 2010+ - not sure why I didn't have Makefile notes from years earlier - young guys don't document enough!
Bazel notes from 2021
