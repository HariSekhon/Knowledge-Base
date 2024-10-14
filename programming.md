# Programming

<!-- INDEX_START -->

- [Languages](#languages)
- [Expect](#expect)
- [Free Programming Courses](#free-programming-courses)
- [Testing](#testing)
- [Big O Notation](#big-o-notation)
- [Memes](#memes)
  - [Hello World](#hello-world)
  - [Documentation](#documentation)
  - [Are You Really Sure You Want to be a Software Developer??](#are-you-really-sure-you-want-to-be-a-software-developer)
  - [Coding with GPT](#coding-with-gpt)
  - [Senior Devs Fixing Bugs in Production](#senior-devs-fixing-bugs-in-production)

<!-- INDEX_END -->

## Languages

1. [Bash](bash.md) - the gold standard for shell scripting
1. [Python](python.md) - general purpose object oriented language, easy to write, widely used but hard to maintain due to environment differences, language and library changes over time
1. [Golang](golang.md) - imperative compiled self-contained binaries, simple toolchain, smashes Python in portability, maintainability, build time etc.
1. [Perl](perl.md) - fast to write imperative code, stable, the gold standard for regex string processing, works everywhere and doesn't break every few years like Python
1. [Groovy](groovy.md) - a better version of Java, with interactive REPL and some language construct conveniences. Hard to want to write in Java again after getting spoilt by Groovy
1. [Java](java.md) - battle tested, but slower to develop in than the above languages
1. [Scala](scala.md) - was supposed to be the next Java but wasn't
1. Kotlin - another next Java, we'll see
1. Clojure - another JVM language
1. [R](r.md) - old data analytics languages, matrices, awkward, but widely used and lots of libraries
1. [Expect](#expect) - an extension of the Tcl language specialized in interactive text interface automation and keystroke control

Beware the `"Hello World"`... see [this meme](#hello-world) further down.

## Expect

Excellent TCL language framework for automating systems which have no alternative but interactive timed text inputs.

[Autoexpect](https://linux.die.net/man/1/autoexpect) - generates an expect script from an interactive session, tune from there

[Expect](https://linux.die.net/man/1/expect) has libraries in most languages.

For example, used Perl's `Net::SSH::Expect` library to test [iDRAC and iLO controllers](hardware.md)
in [check_ssh_login.pl](https://github.com/HariSekhon/Nagios-Plugins/blob/master/check_ssh_login.pl)

Add this to the top of an expect script to debug output:

```shell
exp_internal 1
```

## Free Programming Courses

You are limited only by time and effort.

- [Coursera](https://www.coursera.org/)
- [edX](https://www.edx.org/learn/coding)
- [FreeCodeCamp](https://www.freecodecamp.org/)
- [CodeCademy](https://www.codecademy.com/)
- [Udemy](https://www.udemy.com/topic/programming-fundamentals/free/)
- [LearnCodeTheHardWay](https://learncodethehardway.org/)
- [Khan Academy](https://www.khanacademy.org/computing/computer-programming)
- [Class Central](https://www.classcentral.com/subject/programming-and-software-development)

## Testing

See [Testing](testing.md)

## Big O Notation

![Big O Notation](images/big_O_notation.gif)

## Memes

### Hello World

![Printing Hello World](images/printing_hello_world_in_5_languages.jpeg)

### Documentation

The importance of documentation:

![There's No Documentation - The Code is the Documentation](images/theres_no_documentation_code_is_self_explanatory.jpeg)

### Are You Really Sure You Want to be a Software Developer??

![People Who Sell vs Build Software](images/people_who_sell_software_vs_build_software.jpeg)

### Coding with GPT

Watch out for that quality and not knowing WTF you're doing!

![Coding with GPT](images/oreilly_book_coding_with_gpt.jpeg)

### Senior Devs Fixing Bugs in Production

![Senior Devs Fixing Bugs in Production](images/senior_devs_fixing_bugs_in_production.gif)

**Ported from various private Knowledge Base pages 2008+**
