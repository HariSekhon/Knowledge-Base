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

You can use this command ([doc](https://www.jetbrains.com/help/idea/install-plugins-from-the-command-line.html#macos)) to install plugins quickly from the command line:

```shell
idea installPlugins "$plugin_name_or_id"
```

You must exit IntelliJ before running this as only one `idea` program can be running at a time.

### Useful Plugins

#### Docker, Kubernetes and Terraform

- [Docker](https://plugins.jetbrains.com/plugin/7724-docker)
- [Terraform and HCL](https://plugins.jetbrains.com/plugin/7808-terraform-and-hcl)
- [Kubernetes](https://plugins.jetbrains.com/plugin/10485-kubernetes) - only available in Ultimate Edition :-(

```shell
idea installPlugins \
  Docker \
  org.intellij.plugins.hcl
  #com.intellij.kubernetes  # only available in Ultimate Edition :-(
```

#### Languages

- [Shell Script](https://plugins.jetbrains.com/plugin/13122-shell-script) - shell support
- [Bash Support](https://plugins.jetbrains.com/plugin/4230-bashsupport)
- [Perl](https://plugins.jetbrains.com/plugin/7796-perl)
- Python - see [Python section](#python) further down
- Java/Groovy/Scala/Kotlin/Maven/SBT/Gradle - see [JVM section](#java--groovy--scala--kotlin--jvm-tools) further down
- [Go Linter](https://plugins.jetbrains.com/plugin/12496-go-linter)

```shell
idea installPlugins \
  com.jetbrains.sh \
  BashSupport \
  com.perl5 \
  com.ypwang.plugin.go-linter
```

#### Core Editing, Git & File Formats

- [.ignore](https://plugins.jetbrains.com/plugin/7495--ignore) - supports various `.ignore` files for different technologies
- [Code Glance](https://plugins.jetbrains.com/plugin/7275-codeglance/) - adds a minimap of the file
- [Grep Console](https://plugins.jetbrains.com/plugin/7125-grep-console)
- [BrowseWordAtCaret](https://plugins.jetbrains.com/plugin/201-browsewordatcaret)
- [Editor Config](https://plugins.jetbrains.com/plugin/7294-editorconfig/)
- [GitLink](https://plugins.jetbrains.com/plugin/8183-gitlink/) - shortcut to open files on GitHub and other hosted repo providers
- [Git Toolbox](https://plugins.jetbrains.com/plugin/7499-gittoolbox/) - automatic fetches, show status vs upsteam origin
- [CSV Editor](https://plugins.jetbrains.com/plugin/10037-csv-editor)
- [JSON Parser](https://plugins.jetbrains.com/plugin/10650-json-parser) - validate & format JSON strings
- [CamelCase](https://plugins.jetbrains.com/plugin/7160-camelcase)
- [RegexpTester](https://plugins.jetbrains.com/plugin/2917-regexp-tester)
- [Database Navigator](https://plugins.jetbrains.com/plugin/1800-database-navigator)
- [Markdown Navigator Enhanced](https://plugins.jetbrains.com/plugin/7896-markdown-navigator-enhanced/)
- [Zero Width Characters locator](https://plugins.jetbrains.com/plugin/7448-zero-width-characters-locator) - find characters that could break your code
- [Env files support](https://plugins.jetbrains.com/plugin/9525--env-files-support)
- [String Manipulation](https://plugins.jetbrains.com/plugin/2162-string-manipulation)
- [Rainbow Brackets](https://plugins.jetbrains.com/plugin/10080-rainbow-brackets)
- [Rainbow CSV](https://plugins.jetbrains.com/plugin/12896-rainbow-csv)
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
  BrowseWordAtCaret \
  net.seesharpsoft.intellij.plugins.csv \
  com.godwin.json.parser \
  de.netnexus.camelcaseplugin \
  org.intellij.RegexpTester \
  DBN \
  com.vladsch.idea.multimarkdown \
  com.ultrahob.zerolength.plugin \
  ru.adelf.idea.dotenv \
  "String Manipulation" \
  izhangzhihao.rainbow.brackets \
  com.andrey4623.rainbowcsv \
  indent-rainbow.indent-rainbow \
  com.github.lppedd.idea-return-highlighter
```

#### Usage Stats

- [WakaTime](https://plugins.jetbrains.com/plugin/7425-wakatime) - stats on your usage
- [Code Time](https://plugins.jetbrains.com/plugin/10687-code-time/) - stats on your usage
- [Statistic](https://plugins.jetbrains.com/plugin/4509-statistic) - shows project stats, files, line count etc.

```shell
idea installPlugins \
  com.wakatime.intellij.plugin \
  com.softwareco.intellij.plugin \
  Statistic \
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

#### CI/CD

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

#### Optional - Nice to Haves

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

#### Python

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

#### JavaScript

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

#### Java / Groovy / Scala / Kotlin & JVM Tools

- [Groovy](https://plugins.jetbrains.com/plugin/1524-groovy)
- [Scala](https://plugins.jetbrains.com/plugin/1347-scala)
- [Kotlin](https://plugins.jetbrains.com/plugin/6954-kotlin)
- [Maven Helper](https://plugins.jetbrains.com/plugin/7179-maven-helper)
- [SBT](https://plugins.jetbrains.com/plugin/5007-sbt)
- [Gradle](https://plugins.jetbrains.com/plugin/13112-gradle)
- [Gradle/Maven Navigation](https://plugins.jetbrains.com/plugin/9857-gradle-maven-navigation)
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
  dev.flikas.idea.spring.boot.assistant.plugin \
  Lombook Plugin \
  JRebelPlugin
```

#### Debugging

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

#### AI Plugins

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

#### Pair Programming

- [Code with Me](https://plugins.jetbrains.com/plugin/14896-code-with-me) - pair programming
- [Duckly Pair Programming](https://plugins.jetbrains.com/plugin/14919-duckly-pair-programming-tool)

#### More Plugins

- [Better Highlights](https://plugins.jetbrains.com/plugin/12895-better-highlights)
  - `idea install com.clutcher.comments_highlighter`
- [MultiRun](https://plugins.jetbrains.com/plugin/7248-multirun)
- [Randomness](https://plugins.jetbrains.com/plugin/9836-randomness)
- [CodeMetrics](https://plugins.jetbrains.com/plugin/12159-codemetrics)
- [MetricsReloaded](https://plugins.jetbrains.com/plugin/93-metricsreloaded)
- [CPU Usage Indicator](https://plugins.jetbrains.com/plugin/8580-cpu-usage-indicator) - use [Stats](mac.md#stats-bar) on Mac instead
