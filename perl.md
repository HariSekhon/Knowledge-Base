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
- [Libraries](#libraries)
  - [General](#general)
  - [Web](#web)
  - [Databases](#databases)
  - [Testing & Logging](#testing--logging)
  - [Other](#other)
  - [More](#more)
- [My Perl Library with Unit Tests](#my-perl-library-with-unit-tests)

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

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=DevOps-Perl-tools&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/DevOps-Perl-tools)

## Shell scripts with Perl

Shell scripts using Perl and making it easier to install Perl libraries from CPAN.

[HariSekhon/DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools)

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=DevOps-Bash-tools&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/DevOps-Bash-tools)

## Nagios Plugins in Perl

[HariSekhon/Nagios-Plugins](https://github.com/HariSekhon/Nagios-Plugins)

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Nagios-Plugins&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Nagios-Plugins)

## Libraries

You can search for libraries at
[cpan.org](https://www.cpan.org/)
or
[metacpan.org](https://metacpan.org/).

Some of my favourite libraries you may find useful are below.

You can see most of these used throughout my GitHub repos, eg:

- [HariSekhon/DevOps-Perl-tools](https://github.com/HariSekhon/DevOps-Perl-tools)
- [HariSekhon/Nagios-Plugins](https://github.com/HariSekhon/Nagios-Plugins)
- [HariSekhon/DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools)
- [HariSekhon/lib](https://github.com/HariSekhon/lib)

### General

- [:package: DateTime](https://metacpan.org/pod/DateTime) - Date and time object for Perl

- [:package: Digest::MD5](https://metacpan.org/pod/Digest::MD5) - MD5 hash algorithm

- [:package: Template Toolkit](https://metacpan.org/pod/Template::Toolkit) - Template processing system

- [:package: Term::ANSIColor on CPAN](https://metacpan.org/pod/Term::ANSIColor) - ANSI colors for terminal

- [:package: Email::Sender](https://metacpan.org/pod/Email::Sender) - Email sending library

### Web

- [:package: LWP::UserAgent](https://metacpan.org/pod/LWP::UserAgent) - easy to use HTTP(S) request library

- [:package: Net::HTTP](https://metacpan.org/pod/Net::HTTP) - Low-level HTTP client

- [:package: JSON::XS](https://metacpan.org/pod/JSON::XS) - Fast JSON serializing

- [:package: XML::Parser](https://metacpan.org/pod/XML::Parser) - XML parsing using Expat

- [:package: URI](https://metacpan.org/pod/URI) - Uniform Resource Identifier handling

### Databases

- [:package: DBI](https://metacpan.org/pod/DBI) - Database interface for Perl to access RDBMS [databases](databases.md)

- [:package: DBD::mysql](https://metacpan.org/pod/DBD::mysql) - MySQL database driver for DBI

- [:package: DBD::Pg](https://metacpan.org/pod/DBD::Pg) - PostgreSQL database driver for DBI

- [:package: DBD::Oracle](https://metacpan.org/pod/DBD::Oracle) - Oracle database driver for DBI

- [:package: DBIx::Class](https://metacpan.org/pod/DBIx::Class) - Extensible ORM for Perl

### Testing & Logging

- [:package: Data-Faker](https://metacpan.org/pod/Data::Faker) - generates fake data for testing

- [:package: Log::Log4perl](https://metacpan.org/pod/Log::Log4perl) - Logging framework

- [:package: Test::Simple](https://metacpan.org/pod/Test::Simple) - Basic utilities for writing tests

- [:package: Test::More](https://metacpan.org/pod/Test::More) - More comprehensive utility functions for writing tests

- [:package: Test::Harness](https://metacpan.org/pod/Test::Harness) - Run Perl standard test scripts

### Other

- [:package: File::Slurp](https://metacpan.org/pod/File::Slurp) - Simple file reading/writing

- [:package: Path::Tiny](https://metacpan.org/pod/Path::Tiny) - Simple file path manipulation

- [:package: Try::Tiny](https://metacpan.org/pod/Try::Tiny) - Minimal try/catch framework

### More

Other popular libraries:

- [:package: Mojolicious](https://metacpan.org/pod/Mojolicious) - Real-time web framework

- [:package: Catalyst](https://metacpan.org/pod/Catalyst::Runtime) - MVC web framework

- [:package: Plack](https://metacpan.org/pod/Plack) - PSGI compliant web application framework

- [:package: Dancer2](https://metacpan.org/pod/Dancer2) - Lightweight web framework

- [:package: Moose](https://metacpan.org/pod/Moose) - Modern object system for Perl

- [:package: Mouse](https://metacpan.org/pod/Mouse) - Lightweight object system for Perl

- [:package: Crypt::OpenSSL::RSA](https://metacpan.org/pod/Crypt::OpenSSL::RSA) - RSA encryption

- [:package: AnyEvent](https://metacpan.org/pod/AnyEvent) - Framework for asynchronous programming

- [:package: Parallel::ForkManager](https://metacpan.org/pod/Parallel::ForkManager) - Simple parallel processing manager

- [:package: SOAP::Lite](https://metacpan.org/pod/SOAP::Lite) - Client and server SOAP library

## My Perl Library with Unit Tests

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=lib&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/lib)

**Partial port from private Knowledge Base page 2009+**
