# IntelliJ IDEA

https://www.jetbrains.com/idea/

IntelliJ on Mac notes.

Shortcuts differ between Windows and Mac, and even between versions.

### IntelliJ IDEA vs PyCharm

If you're only doing Python then you may want to just get [PyCharm](https://www.jetbrains.com/pycharm/).

If you're a serious experienced programmer or 'DevOps' you're probably a polyglot programmer who edits other files.

In that case stick to full IntelliJ with plugins (see [Plugins](#plugins) section further down).

Plugins supported in PyCharm are usually also compatible with Intellij IDEA too as they're based on the same IDE framework by IntelliJ.

## Install

<!-- [Download link](https://www.jetbrains.com/idea/download/download-thanks.html?platform=macM1&code=IIC) -->
[Download link](https://www.jetbrains.com/idea/download/download-thanks.html)

```shell
brew install intellij-idea-ce
```

## The Ultimate Shortcut

`Cmd`-`Shift`-`A`

This will allow you to type to search and find any action and hit enter to open it, such as a settings page, but it also shows the actual configured keyboard shortcut for things like commenting out a line.

This is useful because the internet is often wrong on the shortcuts depending on whether your're on Windows / Mac or different versions.

This is the authoritative shortcut of what your local keyboard shortcuts really are.

## Plugins

Useful plugins:

Core:

- [Shell Script](https://plugins.jetbrains.com/plugin/13122-shell-script) - shell support
- [Bash Support](https://plugins.jetbrains.com/plugin/4230-bashsupport)
- [Python](https://plugins.jetbrains.com/plugin/7322-python-community-edition) (contains better support for Jython than PyCharm - cross-language navigation, completion and refactoring)
- [Scala](https://plugins.jetbrains.com/plugin/1347-scala)
- [Kotlin](https://plugins.jetbrains.com/plugin/6954-kotlin)
- [NodeJS](https://plugins.jetbrains.com/plugin/6098-node-js)
- [Docker](https://plugins.jetbrains.com/plugin/7724-docker)
- [Terraform and HCL](https://plugins.jetbrains.com/plugin/7808-terraform-and-hcl)
- [Azure Toolkit for IntelliJ](https://plugins.jetbrains.com/plugin/8053-azure-toolkit-for-intellij)
- [.ignore](https://plugins.jetbrains.com/plugin/7495--ignore) - supports various `.ignore` files for different technologies
- [SonarLint](https://plugins.jetbrains.com/plugin/7973-sonarlint)
- [Code Glance](https://plugins.jetbrains.com/plugin/7275-codeglance/) - adds a minimap of the file
- [Grep Console](https://plugins.jetbrains.com/plugin/7125-grep-console)
- [BrowseWordAtCaret](https://plugins.jetbrains.com/plugin/201-browsewordatcaret)
- [Editor Config](https://plugins.jetbrains.com/plugin/7294-editorconfig/)
- [GitLink](https://plugins.jetbrains.com/plugin/8183-gitlink/) - shortcut to open files on GitHub and other hosted repo providers
- [Git Toolbox](https://plugins.jetbrains.com/plugin/7499-gittoolbox/) - automatic fetches, show status vs upsteam origin
- [Synk Security](https://plugins.jetbrains.com/plugin/10972-snyk-security)
- [CSV Editor](https://plugins.jetbrains.com/plugin/10037-csv-editor)
- [Database Navigator](https://plugins.jetbrains.com/plugin/1800-database-navigator)
- [Markdown Navigator Enhanced](https://plugins.jetbrains.com/plugin/7896-markdown-navigator-enhanced/)
- [WakaTime](https://plugins.jetbrains.com/plugin/7425-wakatime) - stats on your usage
- [Code Time](https://plugins.jetbrains.com/plugin/10687-code-time/) - stats on your usage

Optional:

- [IDEA Features Trainer](https://plugins.jetbrains.com/plugin/8554-ide-features-trainer) - teaches you the IDE
- [Key Promoter X](https://plugins.jetbrains.com/plugin/9792-key-promoter-x) - teaches you keyboard shortcut when you click with the mouse
- [TabNine](https://plugins.jetbrains.com/plugin/12798-tabnine-ai-code-completion--chat-in-java-js-ts-python--more) - AI code suggestions
- [Env files support](https://plugins.jetbrains.com/plugin/9525--env-files-support)
- [String Manipulation](https://plugins.jetbrains.com/plugin/2162-string-manipulation)
- [Yet another emoji support](https://plugins.jetbrains.com/plugin/12512-yet-another-emoji-support)
- [Material Theme UI](https://plugins.jetbrains.com/plugin/8006-material-theme-ui)
- [Atom Material Icons](https://plugins.jetbrains.com/plugin/10044-atom-material-icons) - nicer file icons
- [Rainbow Brackets](https://plugins.jetbrains.com/plugin/10080-rainbow-brackets)
- [Return Highlighter](https://plugins.jetbrains.com/plugin/13303-return-highlighter)
- [Teamcity](https://plugins.jetbrains.com/plugin/1820-teamcity)
- [Mongo](https://plugins.jetbrains.com/plugin/7141-mongo-plugin)
- Python:
  - [PyLint](https://plugins.jetbrains.com/plugin/11084-pylint/)
  - [Mypy](https://plugins.jetbrains.com/plugin/11086-mypy/)
  - [Live Coding in Python](https://plugins.jetbrains.com/plugin/9742-live-coding-in-python/)
  - [Python Enhancements](https://plugins.jetbrains.com/plugin/10194-python-enhancements/)
- JavaScript:
  - [ESLint](https://plugins.jetbrains.com/plugin/7494-eslint)
  - [Prettier](https://plugins.jetbrains.com/plugin/10456-prettier)
- Java
  - [Maven Helper](https://plugins.jetbrains.com/plugin/7179-maven-helper)
  - [JRebel](https://plugins.jetbrains.com/plugin/4441-jrebel-and-xrebel) - auto-reload code changes
- [SpotBugs](https://plugins.jetbrains.com/plugin/14014-spotbugs)

You can use this command ([doc](https://www.jetbrains.com/help/idea/install-plugins-from-the-command-line.html#macos)) to install plugins quickly from the command line:

```shell
idea installPlugins "$plugin_name_or_id"
```

You must exit IntelliJ before running this as only one `idea` can be running at a time.

Install the above plugins from the CLI:

```shell
idea installPlugins \
  com.jetbrains.sh \
  BashSupport \
  PythonCore \
  org.intellij.scala \
  org.jetbrains.kotlin \
  NodeJS \
  Docker \
  org.intellij.plugins.hcl \
  com.microsoft.tooling.msservices.intellij.azure \
  mobi.hsz.idea.gitignore \
  org.editorconfig.editorconfigjetbrains \
  uk.co.ben-gibson.remote.repository.mapper \
  zielu.gittoolbox \
  io.snyk.snyk-intellij-plugin \
  com.vladsch.idea.multimarkdown \
  net.vektah.codeglance \
  GrepConsole \
  BrowseWordAtCaret \
  net.seesharpsoft.intellij.plugins.csv \
  DBN \
  com.wakatime.intellij.plugin \
  com.softwareco.intellij.plugin \
  org.sonarlint.idea   # use with SonarQube / SonarCloud
```

For IntelliJ Ultimate swap `PythonCore` for `Pythonid`.

Optional:

```shell
idea installPlugins \
  training \
  "Key Promoter X" \
  com.tabnine.TabNine \
  ru.adelf.idea.dotenv \
  "String Manipulation" \
  com.chrisrm.idea.MaterialThemeUI \
  com.github.shiraji.yaemoji \
  izhangzhihao.rainbow.brackets \
  com.github.lppedd.idea-return-highlighter \
  org.jetbrains.plugins.spotbugs
  #"Jetbrains TeamCity Plugin"  # just use Jenkins - see the Jenkins page for easy Kubernetes automated deployment
  #"Mongo Plugin"  # who uses Mongo any more?
```

Python specific:

```shell
  com.leinardi.pycharm.pylint \
  com.leinardi.pycharm.mypy \
  io.github.donkirkby.livepycharm \
  com.pythondce
```

JavaScript specific:

```shell
idea installPlugins \
  com.wix.eslint \
  intellij.prettierJS
```

Java specific:

```shell
idea installPlugins \
  MavenRunHelper \
  JRebelPlugin
```

### More Plugins

Some more plugins you might find interesting:

- [Codota AI Autocomplete for Java and JavaScript](https://plugins.jetbrains.com/plugin/7638-codota-ai-autocomplete-for-java-and-javascript)
  - `idea installPlugins com.codota.csp.intellij`
- [Better Highlights](https://plugins.jetbrains.com/plugin/12895-better-highlights)
  - `idea install com.clutcher.comments_highlighter`
- [Code with Me](https://plugins.jetbrains.com/plugin/14896-code-with-me) - pair programming
- [LiveEdit](https://plugins.jetbrains.com/plugin/7007-live-edit)
- [AWS ToolKit](https://plugins.jetbrains.com/plugin/11349-aws-toolkit)
