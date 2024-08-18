# Perl

Perl is a legend of programming languages.

Easily one of the fastest easiest most powerful imperative scripting languages, and legendary
for text processing and regular expressions.

It's the language of elite unix sysadmins, and much of unix tooling is built on it, including [Git](git.md).

<!-- INDEX_START -->
- [PCRE - Perl Compatible Regular Expressions](#pcre---perl-compatible-regular-expressions)
- [Core Reading](#core-reading)
- [Perl in-place fast file editing (like sed but more powerful)](#perl-in-place-fast-file-editing-like-sed-but-more-powerful)
- [DevOps Perl tools](#devops-perl-tools)
- [Shell scripts with Perl](#shell-scripts-with-perl)
- [Nagios Plugins in Perl](#nagios-plugins-in-perl)
- [Perl Library with Unit Tests](#perl-library-with-unit-tests)
<!-- INDEX_END -->

## PCRE - Perl Compatible Regular Expressions

PCRE has the gold standard of regex for decades and is the standard by which other languages are judged.

It's regex engine is faster and more advanced than Python's. You can see many examples where both are used in the
following GitHub repos:

- [DevOps-Perl-tools](https://github.com/HariSekhon/DevOps-Perl-tools)
- [DevOps-Python-tools](https://github.com/HariSekhon/DevOps-Python-tools)
- [Advanced Nagios Plugins Collection](https://github.com/HariSekhon/Nagios-Plugins)

Bash / Grep style BRE / ERE - basic regular expressions / extended regular expressions are the poor man's version, and
awkward for serious usage. Still, you can see many examples of Bash / Grep BRE/ERE format regex usage in:

- [DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools)

Even if you don't know Perl programming you should at least in-place editing of files as it's even more powerful than `sed`.

## Core Reading

[Programming Perl](https://www.amazon.com/Programming-Perl-Unmatched-processing-scripting/dp/0596004923/)

## Perl in-place fast file editing (like sed but more powerful)

```shell
perl -pi -e 's/OLD/NEW/g' *.txt *.yaml ...
```

## DevOps Perl tools

[HariSekhon/DevOps-Perl-tools](https://github.com/HariSekhon/DevOps-Perl-tools)

## Shell scripts with Perl

Shell scripts using Perl and making it easier to install Perl libraries from CPAN.

[HariSekhon/DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools)

## Nagios Plugins in Perl

[HariSekhon/Nagios-Plugins](https://github.com/HariSekhon/Nagios-Plugins)

## Perl Library with Unit Tests

[HariSekhon/lib](https://github.com/HariSekhon/lib)

###### Partial port from private Knowledge Base page 2009+
