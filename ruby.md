# Ruby

<https://www.ruby-lang.org/en/>

Dynamically typed open-source programming language known for its simplicity, flexibility, and focus on developer
happiness.

Not my main language but it's an easy language to pick up so I've written a few bits and pieces over the years
eg. [check_puppet.rb](https://github.com/HariSekhon/Nagios-Plugins/blob/master/check_puppet.rb).

<!-- INDEX_START -->

- [Popularity Over the Years](#popularity-over-the-years)
- [Poignant Guide to Ruby](#poignant-guide-to-ruby)
- [IRB](#irb)
  - [JIRB](#jirb)
- [Gem](#gem)
  - [Install Gems](#install-gems)
  - [Interesting Gems](#interesting-gems)
  - [List Installed Gems](#list-installed-gems)
  - [Install from Custom Gem Server](#install-from-custom-gem-server)
- [RVM - Ruby Version Manager](#rvm---ruby-version-manager)
  - [RVM Install](#rvm-install)
  - [RVM Usage](#rvm-usage)
- [Code](#code)
- [JRuby](#jruby)
  - [Rubinius](#rubinius)
  - [Ludicrous](#ludicrous)
- [RubyMine](#rubymine)

<!-- INDEX_END -->

## Popularity Over the Years

IMO was at peak popularity in the late 2000s when [Puppet](puppet.md) was the big thing
(Puppet was written in Ruby) and was the first widely used configuration language
([CFengine](https://cfengine.com/) wasn't as widely used).

Update: a quick Google found [this article](https://berk.es/2022/03/08/the-waning-of-ruby-and-rails/)
showing Ruby actually peaked in the mid 2000s rather than the late 2000s.
I probably should have made more notes here at that time...

## Poignant Guide to Ruby

A popular source for learning Ruby.

<https://poignant.guide/book/>

<http://www.rubyinside.com/media/poignant-guide.pdf>

## IRB

Interactive Ruby interpreter.

(if you need to install the `irb` Gem see next section)

Start the `irb` interactive ruby interpreter:

```shell
irb
```

### JIRB

JRuby interactive Ruby interpreter.

Start the `jirb` interactive ruby interpreter:

```shell
jirb
```

GUI irb using swing:

```shell
jruby -S jirb_swing
```

```ruby
java_import java.lang.System
version = System.getProperties["java.runtime.version"]
```

## Gem

### Install Gems

```shell
gem install "$name"
```

Install the `mdl` gem for markdown linting (used heavily to check the docs in this repo):

```shell
gem install mdl
```

Run `mdl` to check an `.md` file:

```shell
mdl README.md
```

### Interesting Gems

- `irb` - Interactive Ruby interpreter
- `mdl` - Markdown lint
- `lolcat` - turns text into rainbow colours
- `gitlab` - GitLab CLI
- `jgrep`
- `httparty`
- `gist`
- `kramdown`

### List Installed Gems

```shell
gem list
```

Configure `gem` command to install gems to user writable `$HOME/.gem/ruby/<version>/gems/` directory:

In `$HOME/.gemrc`:

```none
gem: --user-install
```

`gem install` then installs to `~/.gem/ruby/<version>/gems`.

Then make sure to add `$HOME/.gem/ruby/<version>/bin` to `$PATH` environment to be able to run commands installed by
gems:

```shell
gem env
```

Runs server on <http://localhost:8808> to show installed gems:

```shell
gem server
```

```shell
gem install ruby-debug
```

```shell
gem install cheat
```

### Install from Custom Gem Server

```shell
gem install --source http://server
```

## RVM - Ruby Version Manager

<https://rvm.io/>

Installs multiple Ruby environments, interpreters and `gem` commands under

Like VirtualEnv in Python - multiple ruby environments, interpreters and gems

### RVM Install

Install GPG Keys:

```shell
gpg2 --keyserver keyserver.ubuntu.com \
     --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
                 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
```

On Mac, had to do this instead:

```shell
gpg --keyserver hkps://keys.openpgp.org \
    --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
                7D2BAF1CF37B13E2069D6956105BD0E739499BDB
```

Prompts to import GPG keys if you skipped the step above:

```shell
curl -sSL https://get.rvm.io | bash -s stable
```

or with Ruby-on-Rail (compiles, takes ages):

```shell
curl -sSL https://get.rvm.io | bash -s stable --rails
```

You will likely get a warning to remove the user gem setting from `$HOME/.gemrc` as it'll clash with RVM:

In `$HOME/.gemrc`, remove:

```none
gem: --user-install
```

### RVM Usage

<https://rvm.io/rvm/basics>

See available interpreters:

```shell
rvm list known
```

Install a recent Ruby interpreter:

```shell
rvm install ruby
```

Further help:

```shell
rvm help
```

## Code

| Code        | Description                                                                       |
|-------------|-----------------------------------------------------------------------------------|
| `foo`       | local    variable <br> (default: `NameError: undefined local variable` exception) |
| `$foo`      | global   variable <br> (default: `nil`)                                           |
| `@foo`      | instance variable <br> (default: `nil`)                                           |
| `@@foo`     | class    variable <br> (default: `NameError` exception)                           |
| `^[A-Z]...` | constant          <br> (default: `NameError` exception)                           |

```ruby
puts object.inspect
```

```ruby
object.to_yaml
```

Path to code modules:

```none
$LOAD_PATH
```

## JRuby

```ruby
require '/path/to/my.jar'
```

Not needed in `jirb`:

```ruby
require 'java'
```

```java
import java.lang.System
```

Newer safer way to import from Java:

```ruby
java_import java.lang.System
```

```ruby
version = System.getProperties["java.runtime.version"]
```

this does equiv of: `import org.xxx.yyy` and `includes *`:

```ruby
include_package "org.xxx.yyy"
```

### Rubinius

<https://github.com/rubinius/rubinius#readme>

JIT for Ruby

### Ludicrous

<http://rubystuff.org/ludicrous/>

JIT for Ruby

Experimental last I checked and performance roughly on par with YARV (Yet Another Ruby VM bytecode interpreter) which
has since been merged into official Ruby 1.9 interpreter 2007.

## RubyMine

<https://www.jetbrains.com/ruby/>

Ruby-specific IDE by Jebrains, based off [IntelliJ IDEA](intellij.md).

Unfortuntely,
this is proprietary paid for only and doesn't have a free version like [PyCharm](#pycharm) or main
[IntelliJ](intellij.md).

<br>

**Ported from private Knowledge Base page 2012+**
