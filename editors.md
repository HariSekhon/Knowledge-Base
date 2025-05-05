# Editors & IDEs

<!-- INDEX_START -->

- [Editors](#editors)
  - [ViM](#vim)
  - [Neovim](#neovim)
  - [GNU Emacs](#gnu-emacs)
  - [Nano](#nano)
  - [Brackets](#brackets)
  - [Phoenix Code](#phoenix-code)
  - [Komodo Edit](#komodo-edit)
  - [Sublime](#sublime)
  - [Atom](#atom)
- [IDEs](#ides)
  - [IntelliJ IDEA](#intellij-idea)
    - [PyCharm](#pycharm)
    - [WebStorm](#webstorm)
    - [RubyMine](#rubymine)
    - [PHPStorm](#phpstorm)
    - [GoLand](#goland)
    - [RustRover](#rustrover)
    - [CLion](#clion)
    - [dotUltimate](#dotultimate)
    - [Fleet](#fleet)
    - [Compose MultiPlatform](#compose-multiplatform)
    - [Datagrip](#datagrip)
    - [Dataspell](#dataspell)
    - [Aqua](#aqua)
    - [WriterSide](#writerside)
  - [VS Code](#vs-code)
  - [Eclipse](#eclipse)
  - [Geany](#geany)
- [Editor Config](#editor-config)
- [IDE Details](#ide-details)
  - [Eclipse Details](#eclipse-details)
    - [Eclipse Plugins](#eclipse-plugins)
- [Meme](#meme)
  - [Light Theme IDE](#light-theme-ide)
  - [Powerful Computer](#powerful-computer)

<!-- INDEX_END -->

## Editors

Tip: from `less`, you can hit the `v` key to open the file in the default `$EDITOR`.

### ViM

Vi iMproved.

- `vi` was the core editor available on every unix system
- `vim` means `vi` improved
- highly configurable but steep learning curve
- basic knowledge of `vi` is a core skill for all unix / linux server administrators
- tonnes of plugins, highly extensible and widely used
- see my advanced [.vimrc](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/configs/.vimrc) for all
  sorts of trips & tricks, hotkey linting and building, plugins etc.

See [vim.md](vim.md) for more details.

### Neovim

[:octocat: neovim/neovim](https://github.com/neovim/neovim)

Fork of vim above.

- more actively developed
- asynchronous plugins
- extensible in Lua instead of vimscript
- config can be in lua and vimscript
- better external UI support
- built-in terminal

### GNU Emacs

- advanced highly customizable programming editor written by unix veteran by Richard Stallman in 1976
- steep learning curve like vim
- git integration via Magit
- can run shell commands and interact with system processes directly from Emac
- modes for different programming languages and tasks:
  - major modes provide features specific to a language or type of file (e.g., Python mode, HTML mode)
  - minor modes add additional functionalities, such as enabling version control, spell-checking, or syntax highlighting
- integration with external tools: Emacs supports a wide array of external tools, such as Git (via Magit), debuggers, shells, email clients, and more. You can run shell commands and interact with system processes directly from Emacs
- people used to joke that Emacs stood for *"Eight Megabytes and Constantly Swapping"* thinking it was resource hungry
  - contrast to today with [IntelliJ](intellij.md) sucking up 8GB of RAM!
- extensible via Emacs Lisp (Elisp)

### Nano

<https://www.nano-editor.org/>

Simple lightweight text editor for beginners.

Easier to use than vim or emacs.

Developed as an alternative to the pico text editor which was not entirely open source.

### Brackets

<https://brackets.io/.io>

### Phoenix Code

<https://phcode.io/>

[:octocat:phcode-dev/phoenix](https://github.com/phcode-dev/phoenix)

Next generation of the above Brackets editor that runs everywhere, even in web browser.

Web Editor:

<https://phcode.dev/>

Desktop Editor:

<https://phcode.io/#/home>

### Komodo Edit

<https://www.activestate.com/products/komodo-edit/>

### Sublime

<https://www.sublimetext.com/>

Slick.

### Atom

Discontinued. Seemed slow on big files.

<https://github.blog/news-insights/product-news/sunsetting-atom/>

## IDEs

### IntelliJ IDEA

<https://www.jetbrains.com/idea/>

State of the art modern popular IDE - proprietary but has a free version.

- fast & slick
- feature rich
- highly extensible with tonnes of plugins
  - (see [IntelliJ](intellij.md) page for many good ones)
- built-in terminal
- resource intensive - just buy a more powerful machine like my M3 Max, it's worth it

The best of the best in my opinion.

See the [IntelliJ IDEA](intellij.md) page for more.

#### PyCharm

<https://www.jetbrains.com/pycharm/>

Python-focused version of the grand daddy IntelliJ IDEA.

#### WebStorm

<https://www.jetbrains.com/webstorm/>

JavaScript-focused version of IntelliJ IDEA.

#### RubyMine

<https://www.jetbrains.com/ruby/>

Ruby-focused version of the grand daddy IntelliJ IDEA.

Unfortuntely, this is proprietary paid for only and doesn't have a free version like [PyCharm](#pycharm).

#### PHPStorm

<https://www.jetbrains.com/phpstorm/>

Proprietary paid for IntelliJ IDEA for PHP developers.

#### GoLand

<https://www.jetbrains.com/go/>

Paid for Golang version of IntelliJ IDEA.

#### RustRover

<https://www.jetbrains.com/rust/>

Rust-focused version of IntelliJ IDEA.

#### CLion

<https://www.jetbrains.com/clion/>

C / C++ IDE version of IntelliJ - paid for.

#### dotUltimate

<https://www.jetbrains.com/dotnet/>

.NET IDE.

#### Fleet

<https://www.jetbrains.com/fleet/>

AI-powered polyglot IDE, determines your project language.

#### Compose MultiPlatform

<https://www.jetbrains.com/compose-multiplatform/>

UI IDE to create shared UIs for Android, iOS, desktop, and web.

#### Datagrip

<https://www.jetbrains.com/datagrip/>

Paid for RDBMS & NoSQL client.

#### Dataspell

<https://www.jetbrains.com/dataspell/>

Paid for data & analytics clients. A step further than Datagrip above.

#### Aqua

<https://www.jetbrains.com/aqua/>

Focused on Test Automation.

#### WriterSide

<https://www.jetbrains.com/writerside/>

Focused on writing API, SDKs, Documentation and Tutorials.

### VS Code

<https://code.visualstudio.com/>

Microsoft's Visual Studio Code is a free modern popular open-source IDE with plugins.

- IntelliSense - code completion
- remote development extensions enable developers to work seamlessly on remote machines or containers, enhancing the
  flexibility for those who work in cloud-based or server environments
- built-in terminal
- not quite as feature rich as Visual Studio

Not as good as IntelliJ in my opinion.

See the [VS Code](vs-code.md) page for more details.

### Eclipse

<https://www.eclipse.org/>

Old open source IDE.

Most people prefer IntelliJ as it's much faster and slicker.

### Geany

<https://www.geany.org/>

Flyweight - fast & small.

## Editor Config

- `.editorconfig` - standard config file that many editors will read, including [GitHub](github.md) for displaying the `README.
  md` in the repo home page
  - see my [.editorconfig](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/configs/.editorconfig)

## IDE Details

### Eclipse Details

I haven't used eclipse enough to warrant its own page, so here are some minor bits.

`F3` on a class to go it it's definition

Next / Previous Tab - `Fn`-`Ctrl`-`Left` / `Fn`-`Ctrl`-`Right`

| Shortcut                                                     | Description                                      |
|--------------------------------------------------------------|--------------------------------------------------|
| `sysout` -> `Ctrl`-`Space`                                   | Fills in the common `System.out.println` in Java |
| Right-click -> `Source` -> `Generate Getters & Setters`      |                                                  |
| default package -> Right-click -> `Export` -> `Java` -> `JAR file` |                                                  |

Eclipse -> Preferences (Mac):

- Window
  - Preferences
    - Maven
      - untick - `Do not automatically update dependencies from remote repositories`
      - tick   - `Download repository index updates on startup`

Eclipse JSONTools validation plugin (Help -> MarketPlace), but needs files to be .json (not .template from CloudFormation)

IntelliJ also has JSON error validation, but it's not as good as it's hard to see underscores not the big red cross eclipse puts in the left column.

#### Eclipse Plugins

- CheckStyle
- Cucumber
- PMD
- Findbugs
- CodeTemplates
- Mylyn

## Meme

### Light Theme IDE

Any of you who advocate for light theme IDE are not to be trusted in my opinion... 😉😂

![Light Theme IDE](images/light_theme_ide.jpeg)

### Powerful Computer

![Powerful Computer, IDE with Dark Theme, My Code](images/powerful_computer_ide_with_dark_theme_my_code.jpeg)

**Ported from various private Knowledge Base pages 2013+**
