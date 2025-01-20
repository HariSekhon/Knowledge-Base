# IntelliJ IDEA

<https://www.jetbrains.com/idea/>

The best IDE ever for coding in my opinion.

Feature rich and easy to use - the opposite end of [vim](vim.md)!

<!-- INDEX_START -->

- [IntelliJ IDEA vs PyCharm](#intellij-idea-vs-pycharm)
- [Install](#install)
- [Settings Sync](#settings-sync)
- [Set Web Browser](#set-web-browser)
- [Distraction Free Mode](#distraction-free-mode)
- [Shortcuts](#shortcuts)
  - [The Ultimate Shortcut](#the-ultimate-shortcut)
  - [Keyboard Shortcuts](#keyboard-shortcuts)
- [Plugins](#plugins)
  - [Scripted Plugin Install](#scripted-plugin-install)
  - [Manual Plugin Installation](#manual-plugin-installation)
  - [Docker, Kubernetes and Terraform](#docker-kubernetes-and-terraform)
  - [Languages](#languages)
  - [Git & Core Editing Features](#git--core-editing-features)
  - [File Formats](#file-formats)
  - [Diagrams-as-Code](#diagrams-as-code)
  - [Usage Stats](#usage-stats)
  - [Cloud](#cloud)
  - [CI/CD](#cicd)
  - [Optional - Nice to Haves](#optional---nice-to-haves)
  - [Python](#python)
  - [JavaScript](#javascript)
  - [Java / Groovy / Scala / Kotlin & JVM Tools](#java--groovy--scala--kotlin--jvm-tools)
  - [Misc Languages](#misc-languages)
  - [Debugging](#debugging)
  - [AI Plugins](#ai-plugins)
  - [Pair Programming](#pair-programming)
  - [More Plugins](#more-plugins)
- [Troubleshooting](#troubleshooting)
  - [IntelliJ fails to open on Mac](#intellij-fails-to-open-on-mac)
  - [Markdown Images with Relative Paths Not Displaying in Preview](#markdown-images-with-relative-paths-not-displaying-in-preview)
  - [External Tool - unexpected EOF while looking for matching `''](#external-tool---unexpected-eof-while-looking-for-matching-)
- [See Also](#see-also)
- [Meme](#meme)
  - [Light Theme IDE](#light-theme-ide)

<!-- INDEX_END -->

## IntelliJ IDEA vs PyCharm

If you're only doing Python then you may want to just get [PyCharm](https://www.jetbrains.com/pycharm/).

If you're a serious experienced programmer or 'DevOps' you're probably a polyglot programmer who edits other files.

In that case stick to full IntelliJ with plugins (see [Plugins](#plugins) section further down).

Plugins supported in PyCharm are usually also compatible with IntelliJ IDEA too as they're based on the same IDE
framework by IntelliJ.

For a more complete list of IntelliJ IDEA language-specific IDEs see the [Editors](editors.md#intellij-idea) page.

## Install

<!-- [Download link](https://www.jetbrains.com/idea/download/download-thanks.html?platform=macM1&code=IIC) -->
[Download link](https://www.jetbrains.com/idea/download/download-thanks.html)

```shell
brew install intellij-idea-ce
```

## Settings Sync

Make sure to sync settings to JetBrains.

`Settings` -> `Settings Sync` -> `Enable Settings Sync`

Choose JetBrains (log in with GitHub account or other social login).

## Set Web Browser

Defaults to following the system default browser.

`IntelliJ` -> `Settings` -> `Tools` -> `Web Browsers and Preview`

## Distraction Free Mode

Hides all bars, max code space:

`View` -> `Appearance` -> `Enter Distraction Free Mode`

## Shortcuts

### The Ultimate Shortcut

`Cmd`-`Shift`-`A`

This will allow you to type to search and find any action and hit enter to open it, such as a settings page, but it also shows the actual configured keyboard shortcut for things like commenting out a line.

This is useful because the internet is often wrong on the shortcuts depending on whether your're on Windows / Mac or different versions.

This is the authoritative shortcut of what your local keyboard shortcuts really are.

### Keyboard Shortcuts

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

Code completion `Tab` to replace rest of name rather than Enter.

Shortcuts differ between Windows and Mac, and even between versions.

## Plugins

You can use this command ([doc](https://www.jetbrains.com/help/idea/install-plugins-from-the-command-line.html#macos)) to install plugins quickly from the command line:

```shell
idea installPlugins "$plugin_name_or_id"
```

You must exit IntelliJ before running this as only one `idea` program can be running at a time.

### Scripted Plugin Install

These can be installed all in one shot using the script `install_intellij_plugins.sh` in the [DevOps-Bash-tools](devops-bash-tools.md) repo:

```shell
install_intellij_plugins.sh
```

You can add / comment / uncomment which plugins to install in the adjacent `setup/intellij-plugins.txt` config file in that same repo.

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=DevOps-Bash-tools&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/DevOps-Bash-tools)

### Manual Plugin Installation

Can download plugin zips + install from disk where direct internet/proxy access is blocked (eg. banks).

Zips must align to IntelliJ version.

### Docker, Kubernetes and Terraform

- [Docker](https://plugins.jetbrains.com/plugin/7724-docker)
- [Terraform and HCL](https://plugins.jetbrains.com/plugin/7808-terraform-and-hcl)
- [Kubernetes](https://plugins.jetbrains.com/plugin/10485-kubernetes) - only available in Ultimate Edition :-(

```shell
idea installPlugins \
  Docker \
  org.intellij.plugins.hcl
  #com.intellij.kubernetes  # only available in Ultimate Edition :-(
```

### Languages

- [Shell Script](https://plugins.jetbrains.com/plugin/13122-shell-script) - shell support
- [Bash Support](https://plugins.jetbrains.com/plugin/4230-bashsupport)
- [Perl](https://plugins.jetbrains.com/plugin/7796-perl)
- Python - see [Python section](#python) further down
- Java/Groovy/Scala/Kotlin/Maven/SBT/Gradle - see [JVM section](#java--groovy--scala--kotlin--jvm-tools) further down
- [Go Linter](https://plugins.jetbrains.com/plugin/12496-go-linter)
- [Ruby](https://plugins.jetbrains.com/plugin/1293-ruby) - only compatible with paid-for Ultimate edition :-(
- [Ruby Scripting](https://plugins.jetbrains.com/plugin/12549-intellij-scripting-ruby) (3rd party alternative)

```shell
idea installPlugins \
  com.jetbrains.sh \
  BashSupport \
  com.perl5 \
  com.ypwang.plugin.go-linter \
  org.jetbrains.intellij.scripting-ruby
```

### Git & Core Editing Features

- [Code Glance](https://plugins.jetbrains.com/plugin/7275-codeglance/) - adds a minimap of the file
- [Grep Console](https://plugins.jetbrains.com/plugin/7125-grep-console)
- [Better Highlights](https://plugins.jetbrains.com/plugin/12895-better-highlights)
- [BrowseWordAtCaret](https://plugins.jetbrains.com/plugin/201-browsewordatcaret)
- [Editor Config](https://plugins.jetbrains.com/plugin/7294-editorconfig/)
- [GitLink](https://plugins.jetbrains.com/plugin/8183-gitlink/) - shortcut to open files on GitHub and other hosted repo providers
- [Git Toolbox](https://plugins.jetbrains.com/plugin/7499-gittoolbox/) - automatic fetches, show status vs upsteam origin
- [CamelCase](https://plugins.jetbrains.com/plugin/7160-camelcase)
- [RegexpTester](https://plugins.jetbrains.com/plugin/2917-regexp-tester)
- [Database Navigator](https://plugins.jetbrains.com/plugin/1800-database-navigator)
- [Zero Width Characters locator](https://plugins.jetbrains.com/plugin/7448-zero-width-characters-locator) - find characters that could break your code
- [String Manipulation](https://plugins.jetbrains.com/plugin/2162-string-manipulation)
- [Rainbow Brackets](https://plugins.jetbrains.com/plugin/10080-rainbow-brackets)
- [Indent Rainbow](https://plugins.jetbrains.com/plugin/13308-indent-rainbow)
- [Return Highlighter](https://plugins.jetbrains.com/plugin/13303-return-highlighter)

```shell
idea installPlugins \
  mobi.hsz.idea.gitignore \
  org.editorconfig.editorconfigjetbrains \
  uk.co.ben-gibson.remote.repository.mapper \
  zielu.gittoolbox \
  net.vektah.codeglance \
  GrepConsole \
  com.clutcher.comments_highlighter \
  BrowseWordAtCaret \
  de.netnexus.camelcaseplugin \
  org.intellij.RegexpTester \
  DBN \
  com.ultrahob.zerolength.plugin \
  "String Manipulation" \
  izhangzhihao.rainbow.brackets \
  indent-rainbow.indent-rainbow \
  com.github.lppedd.idea-return-highlighter
```

### File Formats

- [.ignore](https://plugins.jetbrains.com/plugin/7495--ignore) - supports various `.ignore` files for different technologies
- [CSV Editor](https://plugins.jetbrains.com/plugin/10037-csv-editor)
- [JSON Parser](https://plugins.jetbrains.com/plugin/10650-json-parser) - validate & format JSON strings
- [Markdown Navigator Enhanced](https://plugins.jetbrains.com/plugin/7896-markdown-navigator-enhanced/)
- [Env files support](https://plugins.jetbrains.com/plugin/9525--env-files-support)
- [Rainbow CSV](https://plugins.jetbrains.com/plugin/12896-rainbow-csv)

```shell
idea installPlugins \
  net.seesharpsoft.intellij.plugins.csv \
  com.godwin.json.parser \
  com.vladsch.idea.multimarkdown \
  ru.adelf.idea.dotenv \
  com.andrey4623.rainbowcsv
```

### Diagrams-as-Code

- [D2lang](https://plugins.jetbrains.com/plugin/20630-d2)
- [Mermaid](https://plugins.jetbrains.com/plugin/20146-mermaid)

```shell
idea installPlugins \
  com.dvd.intellij.d2 \
  com.intellij.mermaid
```

### Usage Stats

- [WakaTime](https://plugins.jetbrains.com/plugin/7425-wakatime) - stats on your usage
- [Code Time](https://plugins.jetbrains.com/plugin/10687-code-time/) - stats on your usage
- [Statistic](https://plugins.jetbrains.com/plugin/4509-statistic) - shows project stats, files, line count etc.

```shell
idea installPlugins \
  com.wakatime.intellij.plugin \
  com.softwareco.intellij.plugin \
  Statistic
```

### Cloud

- [AWS ToolKit](https://plugins.jetbrains.com/plugin/11349-aws-toolkit) - Amazon CodeWhisperer integration
- [Azure Toolkit for IntelliJ](https://plugins.jetbrains.com/plugin/8053-azure-toolkit-for-intellij)
- [Google Cloud Code](https://plugins.jetbrains.com/plugin/8079-gemini-code-assist-cloud-code)

```shell
idea installPlugins \
  aws.toolkit \
  com.microsoft.tooling.msservices.intellij.azure \
  com.google.gct.core
```

### CI/CD

- [Jenkins Pipeline Linter](https://plugins.jetbrains.com/plugin/15699-jenkins-pipeline-linter)
- [Jenkins Control](https://plugins.jetbrains.com/plugin/6110-jenkins-control)
- [Groovy](https://plugins.jetbrains.com/plugin/1524-groovy) - for your [Groovy Shared Library](https://github.com/HariSekhon/Jenkins) functions
- [Teamcity](https://plugins.jetbrains.com/plugin/1820-teamcity) - just use Jenkins instead - see the [Jenkins-on-Kubernetes](jenkins-on-kubernetes.md) page for easy Kubernetes automated deployment
- [SonarLint](https://plugins.jetbrains.com/plugin/7973-sonarlint)
- [Synk Security](https://plugins.jetbrains.com/plugin/10972-snyk-security)

```shell
idea installPlugins \
  com.github.mikesafonov.jenkins-linter-idea-plugin \
  'Jenkins Control Plugin' \
  org.intellij.groovy \
  "Jetbrains TeamCity Plugin" \
  io.snyk.snyk-intellij-plugin \
  org.sonarlint.idea  # use with SonarQube / SonarCloud
```

### Optional - Nice to Haves

- [IDEA Features Trainer](https://plugins.jetbrains.com/plugin/8554-ide-features-trainer) - teaches you the IDE
- [Key Promoter X](https://plugins.jetbrains.com/plugin/9792-key-promoter-x) - teaches you keyboard shortcut when you click with the mouse
- [Material Theme UI](https://plugins.jetbrains.com/plugin/8006-material-theme-ui)
- [Extra Icons](https://plugins.jetbrains.com/plugin/11058-extra-icons) - adds icons for different file types
- [Atom Material Icons](https://plugins.jetbrains.com/plugin/10044-atom-material-icons) - nicer file icons
- [Yet another emoji support](https://plugins.jetbrains.com/plugin/12512-yet-another-emoji-support)
- [Mongo](https://plugins.jetbrains.com/plugin/7141-mongo-plugin)
- [Pieces](https://plugins.jetbrains.com/plugin/17328-pieces--save-search-share--reuse-code-snippets) - code snippets - you should be using libraries but unfortunately some languages have boilerplate for which library do not solve the repetition between programs. See also [HariSekhon/Templates](https://github.com/HariSekhon/Templates)

```shell
idea installPlugins \
  training \
  "Key Promoter X" \
  com.chrisrm.idea.MaterialThemeUI \
  lermitage.intellij.extra.icons \
  com.mallowigi \
  com.github.shiraji.yaemoji
  #"Mongo Plugin"  # who uses Mongo any more?
```

### Python

- [Python](https://plugins.jetbrains.com/plugin/7322-python-community-edition) (contains better support for Jython than PyCharm - cross-language navigation, completion and refactoring)
- [Requirements](https://plugins.jetbrains.com/plugin/10837-requirements)
- [PyLint](https://plugins.jetbrains.com/plugin/11084-pylint/)
- [Mypy](https://plugins.jetbrains.com/plugin/11086-mypy/)
- [Live Coding in Python](https://plugins.jetbrains.com/plugin/9742-live-coding-in-python/)
- [Python Enhancements](https://plugins.jetbrains.com/plugin/10194-python-enhancements/)
- [Python Security](https://plugins.jetbrains.com/plugin/13609-python-security)
- [Python Annotations](https://plugins.jetbrains.com/plugin/12035-python-annotations)

```shell
idea installPlugins \
  PythonCore \
  ru.meanmail.plugin.requirements \
  com.leinardi.pycharm.pylint \
  com.leinardi.pycharm.mypy \
  io.github.donkirkby.livepycharm \
  com.pythondce \
  org.tonybaloney.security.pycharm-security \
  ru.meanmail.plugin.pyannotations
```

For IntelliJ Ultimate swap `PythonCore` for `Pythonid`.

### JavaScript

- [NodeJS](https://plugins.jetbrains.com/plugin/6098-node-js)
- [ESLint](https://plugins.jetbrains.com/plugin/7494-eslint)
- [Prettier](https://plugins.jetbrains.com/plugin/10456-prettier)
- [Quokka](https://plugins.jetbrains.com/plugin/9667-quokka) - rapid prototyping playground

```shell
idea installPlugins \
  NodeJS \
  com.wix.eslint \
  intellij.prettierJS
  quokka.js \
```

### Java / Groovy / Scala / Kotlin & JVM Tools

- [Groovy](https://plugins.jetbrains.com/plugin/1524-groovy)
- [Scala](https://plugins.jetbrains.com/plugin/1347-scala)
- [Kotlin](https://plugins.jetbrains.com/plugin/6954-kotlin)
- [Maven Helper](https://plugins.jetbrains.com/plugin/7179-maven-helper)
- [SBT](https://plugins.jetbrains.com/plugin/5007-sbt)
- [Gradle](https://plugins.jetbrains.com/plugin/13112-gradle)
- [Gradle/Maven Navigation](https://plugins.jetbrains.com/plugin/9857-gradle-maven-navigation)
- [JBang](https://plugins.jetbrains.com/plugin/18257-jbang)
- [Sprint Boot Assistant](https://plugins.jetbrains.com/plugin/17747-spring-boot-assistant)
- [Lombok](https://plugins.jetbrains.com/plugin/6317-lombok) - automates generating getters/setters etc.
  - [Project Lombok](https://projectlombok.org/)
- [JRebel](https://plugins.jetbrains.com/plugin/4441-jrebel-and-xrebel) - auto-reload code changes
- [XRebel](https://plugins.jetbrains.com/plugin/4441-jrebel-and-xrebel/) - performance profiling

```shell
idea installPlugins \
  org.intellij.scala \
  org.jetbrains.kotlin \
  MavenRunHelper \
  SBT \
  com.intellij.gradle \
  tv.twelvetone.gradle.plugin.navigation \
  dev.jbang.intellij.JBangPlugin \
  dev.flikas.idea.spring.boot.assistant.plugin \
  Lombook Plugin \
  JRebelPlugin
```

### Misc Languages

- [Graph Database](https://plugins.jetbrains.com/plugin/20417-graph-database) - for Neo4J Cypher
- [Pig](https://plugins.jetbrains.com/plugin/7203-pig) - for Apache Pig Latin

```shell
idea installPlugins \
  com.albertoventurini.jetbrains.graphdbplugin \
  org.apache.pig.plugin.idea
```

### Debugging

- [SpotBugs](https://plugins.jetbrains.com/plugin/14014-spotbugs)
- [LiveEdit](https://plugins.jetbrains.com/plugin/7007-live-edit) - shows changes instantly for JavaScript, HTML, can enable for NodeJS etc.
- [Lightrun](https://plugins.jetbrains.com/plugin/16477-lightrun) - for live running code debugging using [Lightrun](https://lightrun.com/)
- [Rookout](https://plugins.jetbrains.com/plugin/12637-rookout)

```shell
idea installPlugins \
  org.jetbrains.plugins.spotbugs \
  com.intellij.plugins.html.instantEditing \
  com.lightrun.idea.plugin.saas.LightrunPlugin \
  com.rookout.intellij-plugin
```

### AI Plugins

- [JetBrains AI Assistant](https://plugins.jetbrains.com/plugin/22282-jetbrains-ai-assistant)
- [AWS ToolKit](https://plugins.jetbrains.com/plugin/11349-aws-toolkit) - Amazon CodeWhisperer integration
- [TabNine](https://plugins.jetbrains.com/plugin/12798-tabnine-ai-code-completion--chat-in-java-js-ts-python--more) - AI code suggestions
- [Codota AI Autocomplete for Java and JavaScript](https://plugins.jetbrains.com/plugin/7638-codota-ai-autocomplete-for-java-and-javascript)
  - `idea installPlugins com.codota.csp.intellij`
- [GitHub CoPilot](https://plugins.jetbrains.com/plugin/17718-github-copilot)
- [AI Coding Assistant](https://plugins.jetbrains.com/plugin/20724-ai-coding-assistant)
- [Codiumate](https://plugins.jetbrains.com/plugin/21206-codiumate--code-test-and-review-with-confidence--by-codiumai) - CodiumAI integration

```shell
idea installPlugins \
  com.tabnine.TabNine
```

### Pair Programming

- [Code with Me](https://plugins.jetbrains.com/plugin/14896-code-with-me) - pair programming
- [Duckly Pair Programming](https://plugins.jetbrains.com/plugin/14919-duckly-pair-programming-tool)

### More Plugins

- [Better Highlights](https://plugins.jetbrains.com/plugin/12895-better-highlights)
  - `idea install com.clutcher.comments_highlighter`
- [MultiRun](https://plugins.jetbrains.com/plugin/7248-multirun)
- [Randomness](https://plugins.jetbrains.com/plugin/9836-randomness)
- [CodeMetrics](https://plugins.jetbrains.com/plugin/12159-codemetrics)
- [MetricsReloaded](https://plugins.jetbrains.com/plugin/93-metricsreloaded)
- [CPU Usage Indicator](https://plugins.jetbrains.com/plugin/8580-cpu-usage-indicator) - use [Stats](mac.md#stats-bar) on Mac instead

## Troubleshooting

### IntelliJ fails to open on Mac

Clicking the IntelliJ icon does not open it, and running it from the command line:

```shell
command idea
```

logs but doesn't open.

Even using the `open` command trick reveals [this common error on Mac](mac.md#various-applications-fail-to-open).

```shell
$ open -a "IntelliJ IDEA CE"
The application /Applications/IntelliJ IDEA CE.app cannot be opened for an unexpected reason, error=Error Domain=NSOSStatusErrorDomain Code=-600 "procNotFound: no eligible process with specified descriptor" UserInfo={_LSLine=4141, _LSFunction=_LSOpenStuffCallLocal}
```

### Markdown Images with Relative Paths Not Displaying in Preview

This is caused by opening markdown files (eg. `README.md`) in the same IntelliJ that is already opened in another project.

IntelliJ interprets the relative paths to be from the root of the repo instead of from the path of the opened markdown
file.

**Solution**: open the project directory in a separate IntelliJ window and then open the markdown file in that instance
window of IntelliJ.

### External Tool - unexpected EOF while looking for matching `''

When configuring External Tools to run scripts (recommended with hotkeys), you may encounter this error
running the external tool configuration if using single quotes.

```text
[: -c: line 1: unexpected EOF while looking for matching `''
```

This is caused by an Args configuration like this (eg. for a Program: `bash`):

```text
-c '[ -f .envrc ] && . .envrc; markdown_replace_index.sh $FilePath$'
```

which works on the command line but not in IntelliJ.

**Solution**: replace the single quotes with double quotes:

```text
-c "[ -f .envrc ] && . .envrc; markdown_replace_index.sh $FilePath$"
```

## See Also

Expression Evaluation

Productivity Guide (tracks how often you use each shortcut)

## Meme

### Light Theme IDE

Any of you who advocate for light theme IDE are not to be trusted in my opinion... 😉😂

![Light Theme IDE](images/light_theme_ide.jpeg)

**Ported from various private Knowledge Base pages 2013+**
