# Editors & IDEs

## Editors

- [ViM](vim.md) - `vi` improved
  - `vi` is the core editor available on every unix system
  - basic knowledge of `vi` is a core skill for all unix / linux server administrators
  - tonnes of plugins, highly extensible and widely used
  - see my advanced [.vimrc](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/configs/.vimrc) for all
    sorts of trips & tricks, hotkey linting and building, plugins etc.
- Emacs - the other classic unix editor
- Nano - simple editor, used by people scare of `vi`
- Pico - simple editor from which Nano was forked

### ViM

See [vim.md](vim.md).

## IDEs

- [IntelliJ IDEA](intellij.md) - the modern popular IDE - proprietary but has a free version
  - [PyCharm](https://www.jetbrains.com/pycharm/) - Python only cousin of IDEA
- [Eclipse](https://www.eclipse.org/) - open source IDE. Most prefer IntelliJ as it's slicker

## Editor Config

- `.editorconfig` - standard config file that many editors will read, including [GitHub](github.md) for displaying the `README.
  md` in the repo home page
  - see my [.editorconfig](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/configs/.editorconfig)

## Misc IDE Notes

### IntelliJ IDEA

Get plugins:

- SonarLint
- Python
- Scala
- SBT
- BashSupport
- Ruby
- Cypher (Neo4J)
- Pig
- Go

##### Manual Installation

Can download zips + install off disk where proxy blocked.

Zips must align to IntelliJ version.

#### See

Expression Evaluation

Productivity Guide (tracks how often you use each shortcut)

#### Keyboard Shortcuts

Alternative Keys when you see Windows vs Mac keyboard shortcuts:

| Windows    | Mac          |
|------------|--------------|
| `Ctrl`     | `Cmd`        |
| `Alt`      | `Option`     |
| `Ctrl-Alt` | `Cmd-Option` |

| Command                                      | Description                                                                                                                            |
|----------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------|
| `Cmd`-`;`                                    | Project Dialog configure JDK                                                                                                           |
| `Cmd`-`,`                                    | Settings dialogue                                                                                                                      |
| `Ctrl`-`Shift`-`T`                           | detect + put handlers around select code block                                                                                         |
| `Ctrl`-`Alt`-`T`                             | select, Ctrl-W (to increase selection),  Right-click -> Surround With -> if, try/catch (finds + adds all exceptions), synchronized ... |
| `Ctrl`-`W`                                   | increase selection                                                                                                                     |
| `Ctrl`-`N`                                   | open class by name                                                                                                                     |
| `Ctrl`-`Shift`-`N`                           | open file by name                                                                                                                      |
| `Ctrl`-`Space`                               | autocomplete                                                                                                                           |
| `Alt`-`F7`                                   | find all places class/variable/method under cursor is used                                                                             |
| `Ctrl`-`Q`                                   | show doc for class/method under cursor                                                                                                 |
| `Ctrl`-`B`                                   | jump to declaration                                                                                                                    |
| `Ctrl`-`Alt`-`B`                             | jump to Abstract Method's implementation                                                                                               |
| `Ctrl`-`F6`                                  | rename all locations of selected variable/method/class (Refactor -> Rename)                                                            |
| `Ctrl`-`F12`                                 | show methods of class to jump to                                                                                                       |
| `Ctrl`-`Shift`-`Space`                       | prompt for available methods/variables or objects of type if type specified on left                                                    |
| `Ctrl`-`P`                                   | in parens() opens pop-up list of valid parameters                                                                                      |
| `Ctrl`-`I`                                   | implements methods for class interface                                                                                                 |
| `Ctrl`-`O`                                   | overrides method of class                                                                                                              |
| `Alt`-`Insert` / `Code` -> `Generate`        | creates setters + getters                                                                                                              |
| `Shift`-`F1` / `View` -> `External Document` | opens in browser                                                                                                                       |

Code completion `Tab` to replace rest of name rather than Enter

#### Set Web Browser

Defaults to following the system default browser.

`IntelliJ` -> `Settings` -> `Tools` -> `Web Browsers and Preview`

#### Distraction Free Mode

Hides all bars, max code space

`View` -> `Appearance` -> `Enter Distraction Free Mode`

### Eclipse

`F3` on a class to go it it's definition

Next / Previous Tab - `Fn`-`Ctrl`-`Left` / `Fn`-`Ctrl`-`Right`

| Shortcut                                                     | Description                                      |
|--------------------------------------------------------------|--------------------------------------------------|
| `sysout` -> `Ctrl`-`Space`                                   | Fills in the common `System.out.println` in Java |
| Right-click -> `Source` -> `Generate Getters & Setters`      |                                                  |
| default package -> Right-click -> `Export` -> `Java` -> `JAR file` |                                                  |

Eclipse -> Preferences (Mac):

Window -> Preferences:
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

###### Ported from various private Knowledge Base pages 2013+
