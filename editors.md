# Editors & IDEs

## Editors

- [ViM](https://www.vim.org/) - `vi` improved
  - available everywhere and you will know the basics of old `vi` for all server administration. Basic skill for all
    unix / linux sysadmins
  - tonnes of plugins, highly extensible and widely used
  - see my advanced [.vimrc](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/configs/.vimrc) for all
    sorts of trips & tricks, hotkey linting and building, plugins etc.
- Emacs - the other classic unix editor
- Nano - simple editor, used by people scare of `vi`
- Pico - simple editor from which Nano was forked

## IDEs

- [IntelliJ](https://www.jetbrains.com/idea/) - the modern popular IDE - proprietary but has a free version
- [Eclipse](https://www.eclipse.org/) - open source IDE. Most prefer IntelliJ as it's slicker

## Editor Config

- `.editorconfig` - standard config file that many editors will read, including GitHub for displaying the `README.
  md` in the repo home page
  - see my [.editorconfig](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/configs/.editorconfig)

## Misc IDE Notes

### Eclipse

F3 on a class to go it it's definition

Next / Previous Tab - Fn-Ctrl-Left / Fn-Ctrl-Right

- type "sysout" -> Ctrl-Space -> System.out.println
- right click -> Source -> Generate Getters & Setters

default package -> right-click -> export -> Java -> JAR file

Eclipse -> Preferences (Mac)

Window -> Preferences:
  - Maven
    - untick - `Do not automatically update dependencies from remote repositories`
    - tick   - `Download repository index updates on startup`

Eclipse JSONTools validation plugin (Help -> MarketPlace), but needs files to be .json (not .template from CloudFormation)

IntelliJ also has JSON error validation but it's not as good as it's hard to see underscores not the big red cross eclipse puts in the left column

#### Eclipse Plugins

- CheckStyle
- Cucumber
- PMD
- Findbugs
- CodeTemplates
- Mylyn


###### Ported from various private Knowledge Base pages 2013+
