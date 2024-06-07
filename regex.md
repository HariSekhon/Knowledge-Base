# Regex

Regular expressions are a core skill for any half decent programmer.

I use them extensively in languages from Python and Perl to Java/Scala/Groovy and even in shell scripts in Bash
for grep, sed & awk.

## Online Regex Testing

https://regex101.com/

https://regexr.com/

## PCRE vs BRE vs ERE

### PCRE - Perl Compatible Regular Expressions

The gold standard from [Perl](perl.md) which most popular languages aspire to

GNU grep has a `grep -P` switch to use PCRE but beware it's not portable. It won't work on BSD based systems like macOS.

On Mac you can install coreutils to get the better GNU Grep

```shell
brew install coreutils
```
but then you'll have to use the `ggrep` command instead.

Your shell scripts will have to figure our if they're on Mac and override the grep command (examples in
[DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools) repo).

## BRE - Basic Regular Expression

This is the neutered regex that old grep uses.

## ERE - Extended Regular Expressions

Slightly better than BRE but still weak & awkward compared to PCRE.

Don't support back references.

Grep on most systems can support EREs via the `grep -E` switch.

Awk also uses EREs.

## Core Reading

[Master Regular Expressions](https://www.amazon.com/Mastering-Regular-Expressions-Jeffrey-Friedl/dp/0596528124/)

## Library of Regex in Perl

PCRE regex:

[HariSekhon/lib](https://github.com/HariSekhon/lib)

## Library of Regex in Python

PCRE regex:

[HariSekhon/pylib](https://github.com/HariSekhon/pylib)

## Library of Regex in Bash

BRE / ERE Regex:

[HariSekhon/DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools)

## Examples of Real-world Regex Used Extensively

PCRE regex - see especially anonymize.py / anonymize.pl in these repos among many other scripts:

[HariSekhon/DevOps-Python-tools](https://github.com/HariSekhon/DevOps-Python-tools)

[HariSekhon/DevOps-Perl-tools](https://github.com/HariSekhon/DevOps-Perl-tools)

[HariSekhon/Nagios-Plugins](https://github.com/HariSekhon/Nagios-Plugins)
