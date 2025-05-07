# Markdown

<!-- INDEX_START -->

- [GitHub `README.md`](#github-readmemd)
- [MKDocs](#mkdocs)
- [Obsidian](#obsidian)
- [GitBook](#gitbook)
- [Quarto](#quarto)
- [Markdown Best Practices](#markdown-best-practices)
  - [Lint your Markdown](#lint-your-markdown)
    - [Markdownlint Exceptions](#markdownlint-exceptions)
  - [URL Hyperlinking](#url-hyperlinking)
  - [Relative Link Paths](#relative-link-paths)
  - [Code Blocks vs Inline Code](#code-blocks-vs-inline-code)
  - [Split Code Block Commands and Outputs to Separate Blocks](#split-code-block-commands-and-outputs-to-separate-blocks)
  - [Syntax Highlighting](#syntax-highlighting)
  - [IntelliJ Code Block Execution](#intellij-code-block-execution)
- [Emojis](#emojis)
- [Badges & Icons](#badges--icons)
  - [Badges](#badges)
    - [Shields.io](#shieldsio)
      - [Shields.io Tips](#shieldsio-tips)
    - [GitHub Readme Stats](#github-readme-stats)
  - [Icons](#icons)
    - [Simple Icons](#simple-icons)
    - [More Icons](#more-icons)
    - [Removed Icons](#removed-icons)
      - [LinkedIn Icon](#linkedin-icon)
      - [Oracle Icon](#oracle-icon)
  - [Icon Colours](#icon-colours)
  - [Colours](#colours)
  - [Detecting Colours - ColorZilla](#detecting-colours---colorzilla)
- [Star History Graphs](#star-history-graphs)
  - [Star History](#star-history)
  - [Star Charts](#star-charts)
- [Link Team Support Numbers to WhatsApp Desktop](#link-team-support-numbers-to-whatsapp-desktop)
- [Online Markdown Preview Editors](#online-markdown-preview-editors)
- [Memes](#memes)
  - [Peacocking Your Code](#peacocking-your-code)

<!-- INDEX_END -->

## GitHub `README.md`

Document right in your Git repo by creating a `README.md` and have your Git repo hosting platform render it as your
repo's home page - put links in it to your other markdown `*.md` doc files in your repo.

[GitHub Markdown Syntax Documentation](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)

## MKDocs

[MKDocs](mkdocs.md) converts standard markdown files into a website.

## Obsidian

<https://obsidian.md/>

## GitBook

<https://www.gitbook.com/>

## Quarto

<https://quarto.org/>

Write in markdown with dynamic content in languages like Python.

Publish reproducible, production quality articles, presentations, dashboards, websites, blogs, and books in HTML, PDF,
MS Word, ePub etc.

Publish to Posit Connect, Confluence, or other publishing systems.

Can write using Pandoc markdown, including equations, citations, crossrefs, figure panels, callouts, advanced layout
etc.

## Markdown Best Practices

### Lint your Markdown

Use MDL:

<https://github.com/markdownlint/markdownlint>

Useful for auto-linting before committing as well as in CI/CD.

See
[GitHub Actions - Markdown reusable workflow](https://github.com/HariSekhon/GitHub-Actions/blob/master/.github/workflows/markdown.yaml).

#### Markdownlint Exceptions

If you run into a bug that you want to ignore,
you can do so by putting this comment just before the offending line or table:

```markdown
<!-- mdl-disable MDnnn -->
```

eg.

```markdown
<!-- mdl-disable MD056 -->
```

### URL Hyperlinking

It's important not to put a bare URL because they won't by hyperlinked in some systems like [MKDocs](mkdocs.md).

Use a text hyperlink:

```markdown
[Some Text](https://my.domain.com/path)
```

or if you want to show the URL wrap it in `<` and `>` to ensure it maintains compatibility to become a hyperlink:

```markdown
<https://my.domain.com/path>
```

### Relative Link Paths

Make links to files in the same repo, such as other markdown files or images, relative to the current markdown file
so that they don't break if you change an [MKDocs](mkdocs.md) domain or Git repo location.

This also allows for better local navigation to click through to edit files in IDEs like [IntelliJ](intellij.md).

### Code Blocks vs Inline Code

Use triple backticks on separate lines to create code blocks and put a language attribute immediately after the opening
backticks:

```shell
some_command -with -args 1
```

This is much more readable than an inline code of `some_command -with args 1` and then carry on with your day.

Code blocks get a Copy to Clipboard link making your life easier.

Inline code should only be for short references to command names or an arg eg.
use the `git` command or specify `--force-with-lease` option in git if you really insist on doing rebases and force
pushes.

(See also: [The Evils of Git Rebasing](https://medium.com/@harisekhon/the-evils-of-git-rebasing-beec34a607c7))

### Split Code Block Commands and Outputs to Separate Blocks

This way you can click the `Copy` symbol in IDEs like [IntelliJ](intellij.md) and paste to your terminal, otherwise it'll copy and paste the
sample output too.

### Syntax Highlighting

Put a language name immediately after the first triple backticks then you get syntax highlighting eg.

````markdown
```groovy
````

<!--

closing code block for markdown_generate_index.sh
to enable to code to exclude code block opening/closing pairs
from generating comment comments into headings

````

-->

Compare the readability of this:

```text
if (isCommandAvailable('gcloud')) {
    echo 'Using GCloud SDK to configure Docker'
    // configures docker config with a token
    sh "gcloud auth configure-docker '$GAR_REGISTRY'"
}
```

with this having syntax highlighting:

```groovy
if (isCommandAvailable('gcloud')) {
    echo 'Using GCloud SDK to configure Docker'
    // configures docker config with a token
    sh "gcloud auth configure-docker '$GAR_REGISTRY'"
}
```

(example from [HariSekhon/Jenkins](https://github.com/HariSekhon/Jenkins) repo)

### IntelliJ Code Block Execution

If you run [IntelliJ](intellij.md) there is also a green triangle arrow next to `shell` blocks to execute them with
only one click, code notebook style.

<!-- markdownlint-disable MD031 -->

````text
```shell
echo "execute this command"
```
````

<!-- markdownlint-enable -->

```shell
echo "execute this command"
```

## Emojis

Lists of emojis `:shortcodes:` that will be rendered on GitHub flavoured markdown:

<https://gist.github.com/rxaviers/7360908>

<https://github.com/ikatyang/emoji-cheat-sheet>

## Badges & Icons

### Badges

#### Shields.io

<https://shields.io>

Creates standard GitHub badges in this format:

![](https://img.shields.io/badge/Hari-Sekhon-blue?logo=github)

with custom writing, color and choice of [Simple Icon](#simple-icons)
or custom icon passed in as a base64 encoded string
(see the [LinkedIn Icon](#linkedin-icon) section below for how to do that).

##### Shields.io Tips

Since Shields.io breaks badge components on dashes (-) you need to escape dashes by doubling them up (--).

#### GitHub Readme Stats

[:octocat: anuraghazra/github-readme-stats](https://github.com/anuraghazra/github-readme-stats)

[Themes](https://github.com/anuraghazra/github-readme-stats/blob/master/themes/README.md)

### Icons

#### Simple Icons

Use [Simple Icons](https://simpleicons.org) for a great selection of icons.

These can be used with the `logo=` parameter in [Shields.io](https://shields.io) above.

#### More Icons

[:octocat: devicons/devicon](https://github.com/devicons/devicon)

[:octocat: marwin1991/profile-technology-icons](https://github.com/marwin1991/profile-technology-icons)

<https://marwin1991.github.io/profile-technology-icons/>

#### Removed Icons

However, for icons that are not available on the Simple Icons site, or those that
[got removed](https://github.com/simple-icons/simple-icons/issues/11372),
you can use the `shields_embed_logo.sh` script from the [DevOps-Bash-tools](devops-bash-tools.md) repo.

##### LinkedIn Icon

Download the icon:

```shell
wget -nc https://raw.githubusercontent.com/simple-icons/simple-icons/e8de041b64586c0c532f9ea5508fd8e29d850937/icons/linkedin.svg
```

```shell
shields_embed_logo.sh linkedin.svg
```

or directly from a URL containing the icon:

```shell
shields_embed_logo.sh https://raw.githubusercontent.com/simple-icons/simple-icons/e8de041b64586c0c532f9ea5508fd8e29d850937/icons/linkedin.svg
```

Either will result in an output like this:

```text
logo=data:image/svg%2bxml;base64,PHN2ZyByb2xlPSJpbWciIGlmaWxsPSIjZmZmZmZmIiB2aWV3Qm94PSIwIDAgMjQgMjQiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PHRpdGxlPkxpbmtlZEluPC90aXRsZT48cGF0aCBkPSJNMjAuNDQ3IDIwLjQ1MmgtMy41NTR2LTUuNTY5YzAtMS4zMjgtLjAyNy0zLjAzNy0xLjg1Mi0zLjAzNy0xLjg1MyAwLTIuMTM2IDEuNDQ1LTIuMTM2IDIuOTM5djUuNjY3SDkuMzUxVjloMy40MTR2MS41NjFoLjA0NmMuNDc3LS45IDEuNjM3LTEuODUgMy4zNy0xLjg1IDMuNjAxIDAgNC4yNjcgMi4zNyA0LjI2NyA1LjQ1NXY2LjI4NnpNNS4zMzcgNy40MzNjLTEuMTQ0IDAtMi4wNjMtLjkyNi0yLjA2My0yLjA2NSAwLTEuMTM4LjkyLTIuMDYzIDIuMDYzLTIuMDYzIDEuMTQgMCAyLjA2NC45MjUgMi4wNjQgMi4wNjMgMCAxLjEzOS0uOTI1IDIuMDY1LTIuMDY0IDIuMDY1em0xLjc4MiAxMy4wMTlIMy41NTVWOWgzLjU2NHYxMS40NTJ6TTIyLjIyNSAwSDEuNzcxQy43OTIgMCAwIC43NzQgMCAxLjcyOXYyMC41NDJDMCAyMy4yMjcuNzkyIDI0IDEuNzcxIDI0aDIwLjQ1MUMyMy4yIDI0IDI0IDIzLjIyNyAyNCAyMi4yNzFWMS43MjlDMjQgLjc3NCAyMy4yIDAgMjIuMjIyIDBoLjAwM3oiLz48L3N2Zz4K
```

Now the default LinkedIn logo comes out dim like this:

[![My LinkedIn](https://img.shields.io/badge/LinkedIn%20Profile-HariSekhon-blue?logo=data:image/svg%2bxml;base64,PHN2ZyByb2xlPSJpbWciIHZpZXdCb3g9IjAgMCAyNCAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+TGlua2VkSW48L3RpdGxlPjxwYXRoIGQ9Ik0yMC40NDcgMjAuNDUyaC0zLjU1NHYtNS41NjljMC0xLjMyOC0uMDI3LTMuMDM3LTEuODUyLTMuMDM3LTEuODUzIDAtMi4xMzYgMS40NDUtMi4xMzYgMi45Mzl2NS42NjdIOS4zNTFWOWgzLjQxNHYxLjU2MWguMDQ2Yy40NzctLjkgMS42MzctMS44NSAzLjM3LTEuODUgMy42MDEgMCA0LjI2NyAyLjM3IDQuMjY3IDUuNDU1djYuMjg2ek01LjMzNyA3LjQzM2MtMS4xNDQgMC0yLjA2My0uOTI2LTIuMDYzLTIuMDY1IDAtMS4xMzguOTItMi4wNjMgMi4wNjMtMi4wNjMgMS4xNCAwIDIuMDY0LjkyNSAyLjA2NCAyLjA2MyAwIDEuMTM5LS45MjUgMi4wNjUtMi4wNjQgMi4wNjV6bTEuNzgyIDEzLjAxOUgzLjU1NVY5aDMuNTY0djExLjQ1MnpNMjIuMjI1IDBIMS43NzFDLjc5MiAwIDAgLjc3NCAwIDEuNzI5djIwLjU0MkMwIDIzLjIyNy43OTIgMjQgMS43NzEgMjRoMjAuNDUxQzIzLjIgMjQgMjQgMjMuMjI3IDI0IDIyLjI3MVYxLjcyOUMyNCAuNzc0IDIzLjIgMCAyMi4yMjIgMGguMDAzeiIvPjwvc3ZnPgo=&logoColor=white)](https://www.linkedin.com/in/HariSekhon/)

So add the SVG attribute `fill="#ffffff"` to the SVG (it's just XML file) to add white filler.

```shell
sed 's|/>|fill="#ffffff" />|' linkedin.svg > linkedin_filled.svg
```

```shell
shields_embed_logo.sh linkedin_filled.svg
```

which results in a different base encoded data:

```shell
logo=data:image/svg%2bxml;base64,PHN2ZyByb2xlPSJpbWciIHZpZXdCb3g9IjAgMCAyNCAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+TGlua2VkSW48L3RpdGxlPjxwYXRoIGQ9Ik0yMC40NDcgMjAuNDUyaC0zLjU1NHYtNS41NjljMC0xLjMyOC0uMDI3LTMuMDM3LTEuODUyLTMuMDM3LTEuODUzIDAtMi4xMzYgMS40NDUtMi4xMzYgMi45Mzl2NS42NjdIOS4zNTFWOWgzLjQxNHYxLjU2MWguMDQ2Yy40NzctLjkgMS42MzctMS44NSAzLjM3LTEuODUgMy42MDEgMCA0LjI2NyAyLjM3IDQuMjY3IDUuNDU1djYuMjg2ek01LjMzNyA3LjQzM2MtMS4xNDQgMC0yLjA2My0uOTI2LTIuMDYzLTIuMDY1IDAtMS4xMzguOTItMi4wNjMgMi4wNjMtMi4wNjMgMS4xNCAwIDIuMDY0LjkyNSAyLjA2NCAyLjA2MyAwIDEuMTM5LS45MjUgMi4wNjUtMi4wNjQgMi4wNjV6bTEuNzgyIDEzLjAxOUgzLjU1NVY5aDMuNTY0djExLjQ1MnpNMjIuMjI1IDBIMS43NzFDLjc5MiAwIDAgLjc3NCAwIDEuNzI5djIwLjU0MkMwIDIzLjIyNy43OTIgMjQgMS43NzEgMjRoMjAuNDUxQzIzLjIgMjQgMjQgMjMuMjI3IDI0IDIyLjI3MVYxLjcyOUMyNCAuNzc0IDIzLjIgMCAyMi4yMjIgMGguMDAzeiIgLz48L3N2Zz4K
```

Paste that generated parameter to the end of the `shields.io` URL, prefix with a `?` if the first parameter or a `&`
if appended to existing parameters:

```markdown
[![My LinkedIn](https://img.shields.io/badge/LinkedIn%20Profile-HariSekhon-blue?logo=data:image/svg%2bxml;base64,PHN2ZyByb2xlPSJpbWciIGZpbGw9IiNmZmZmZmYiIHZpZXdCb3g9IjAgMCAyNCAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+TGlua2VkSW48L3RpdGxlPjxwYXRoIGQ9Ik0yMC40NDcgMjAuNDUyaC0zLjU1NHYtNS41NjljMC0xLjMyOC0uMDI3LTMuMDM3LTEuODUyLTMuMDM3LTEuODUzIDAtMi4xMzYgMS40NDUtMi4xMzYgMi45Mzl2NS42NjdIOS4zNTFWOWgzLjQxNHYxLjU2MWguMDQ2Yy40NzctLjkgMS42MzctMS44NSAzLjM3LTEuODUgMy42MDEgMCA0LjI2NyAyLjM3IDQuMjY3IDUuNDU1djYuMjg2ek01LjMzNyA3LjQzM2MtMS4xNDQgMC0yLjA2My0uOTI2LTIuMDYzLTIuMDY1IDAtMS4xMzguOTItMi4wNjMgMi4wNjMtMi4wNjMgMS4xNCAwIDIuMDY0LjkyNSAyLjA2NCAyLjA2MyAwIDEuMTM5LS45MjUgMi4wNjUtMi4wNjQgMi4wNjV6bTEuNzgyIDEzLjAxOUgzLjU1NVY5aDMuNTY0djExLjQ1MnpNMjIuMjI1IDBIMS43NzFDLjc5MiAwIDAgLjc3NCAwIDEuNzI5djIwLjU0MkMwIDIzLjIyNy43OTIgMjQgMS43NzEgMjRoMjAuNDUxQzIzLjIgMjQgMjQgMjMuMjI3IDI0IDIyLjI3MVYxLjcyOUMyNCAuNzc0IDIzLjIgMCAyMi4yMjIgMGguMDAzeiIvPjwvc3ZnPgo=)](https://www.linkedin.com/in/HariSekhon/)
```
Result:

![My LinkedIn](https://img.shields.io/badge/LinkedIn%20Profile-HariSekhon-blue?logo=data:image/svg%2bxml;base64,PHN2ZyByb2xlPSJpbWciIGZpbGw9IiNmZmZmZmYiIHZpZXdCb3g9IjAgMCAyNCAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+TGlua2VkSW48L3RpdGxlPjxwYXRoIGQ9Ik0yMC40NDcgMjAuNDUyaC0zLjU1NHYtNS41NjljMC0xLjMyOC0uMDI3LTMuMDM3LTEuODUyLTMuMDM3LTEuODUzIDAtMi4xMzYgMS40NDUtMi4xMzYgMi45Mzl2NS42NjdIOS4zNTFWOWgzLjQxNHYxLjU2MWguMDQ2Yy40NzctLjkgMS42MzctMS44NSAzLjM3LTEuODUgMy42MDEgMCA0LjI2NyAyLjM3IDQuMjY3IDUuNDU1djYuMjg2ek01LjMzNyA3LjQzM2MtMS4xNDQgMC0yLjA2My0uOTI2LTIuMDYzLTIuMDY1IDAtMS4xMzguOTItMi4wNjMgMi4wNjMtMi4wNjMgMS4xNCAwIDIuMDY0LjkyNSAyLjA2NCAyLjA2MyAwIDEuMTM5LS45MjUgMi4wNjUtMi4wNjQgMi4wNjV6bTEuNzgyIDEzLjAxOUgzLjU1NVY5aDMuNTY0djExLjQ1MnpNMjIuMjI1IDBIMS43NzFDLjc5MiAwIDAgLjc3NCAwIDEuNzI5djIwLjU0MkMwIDIzLjIyNy43OTIgMjQgMS43NzEgMjRoMjAuNDUxQzIzLjIgMjQgMjQgMjMuMjI3IDI0IDIyLjI3MVYxLjcyOUMyNCAuNzc0IDIzLjIgMCAyMi4yMjIgMGguMDAzeiIvPjwvc3ZnPgo=)

##### Oracle Icon

Download the icon:

```shell
wget -nc https://raw.githubusercontent.com/simple-icons/simple-icons/405ef6a8c744dcf041971acfea08e0242c027fac/icons/oracle.svg
```

Change icon to white:

```shell
sed 's|/>| fill="#ffffff" />|' oracle.svg > oracle_filled.svg
```

Generate the data to embed in the `shields.io` badge call:

```shell
shields_embed_logo.sh oracle_filled.svg
```

Output:

```text
logo=data:image/svg%2bxml;base64,PHN2ZyByb2xlPSJpbWciIHZpZXdCb3g9IjAgMCAyNCAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+T3JhY2xlPC90aXRsZT48cGF0aCBkPSJNMTYuNDEyIDQuNDEyaC04LjgyYTcuNTg4IDcuNTg4IDAgMCAwLS4wMDggMTUuMTc2aDguODI4YTcuNTg4IDcuNTg4IDAgMCAwIDAtMTUuMTc2em0tLjE5MyAxMi41MDJINy43ODZhNC45MTUgNC45MTUgMCAwIDEgMC05LjgyOGg4LjQzM2E0LjkxNCA0LjkxNCAwIDEgMSAwIDkuODI4eiIgZmlsbD0iI2ZmZmZmZiIgLz48L3N2Zz4K
```

Put in `shields.io` badge to replace the icon:

```markdown
[![Oracle](https://img.shields.io/badge/SQL-Oracle-F80000?logo=data:image/svg%2bxml;base64,PHN2ZyByb2xlPSJpbWciIHZpZXdCb3g9IjAgMCAyNCAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+T3JhY2xlPC90aXRsZT48cGF0aCBkPSJNMTYuNDEyIDQuNDEyaC04LjgyYTcuNTg4IDcuNTg4IDAgMCAwLS4wMDggMTUuMTc2aDguODI4YTcuNTg4IDcuNTg4IDAgMCAwIDAtMTUuMTc2em0tLjE5MyAxMi41MDJINy43ODZhNC45MTUgNC45MTUgMCAwIDEgMC05LjgyOGg4LjQzM2E0LjkxNCA0LjkxNCAwIDEgMSAwIDkuODI4eiIgZmlsbD0iI2ZmZmZmZiIgLz48L3N2Zz4K&logoColor=white)](https://oracle.com/)
```
Result:

[![Oracle](https://img.shields.io/badge/SQL-Oracle-F80000?logo=data:image/svg%2bxml;base64,PHN2ZyByb2xlPSJpbWciIHZpZXdCb3g9IjAgMCAyNCAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+T3JhY2xlPC90aXRsZT48cGF0aCBkPSJNMTYuNDEyIDQuNDEyaC04LjgyYTcuNTg4IDcuNTg4IDAgMCAwLS4wMDggMTUuMTc2aDguODI4YTcuNTg4IDcuNTg4IDAgMCAwIDAtMTUuMTc2em0tLjE5MyAxMi41MDJINy43ODZhNC45MTUgNC45MTUgMCAwIDEgMC05LjgyOGg4LjQzM2E0LjkxNCA0LjkxNCAwIDEgMSAwIDkuODI4eiIgZmlsbD0iI2ZmZmZmZiIgLz48L3N2Zz4K&logoColor=white)](https://oracle.com/)

### Icon Colours

Usually you can get the hex colour of an icon or brand from the [SimpleIcons.org](https://simpleicons.org/) website.

Click the hex colour code to copy it to clipboard.

However, sometimes the colour they have is not the colour that matches the website logo, such as is the case with Miro:

<https://simpleicons.org/?q=miro>

which shows this dark `#050038` colour which would result in:

[![Miro](https://img.shields.io/badge/Miro-dashboard-050038.svg?logo=miro)](https://miro.com/app/dashboard/)

instead of the yellow colour that one usually associates with Miro:

[![Miro](https://img.shields.io/badge/Miro-dashboard-FEDD33.svg?logo=miro)](https://miro.com/app/dashboard/)

In this case you can detect the colour off the website or logo yourself...

### Colours

See the [Visualization](visualization.md) doc's [Colours](visualization.md#colours) section.

### Detecting Colours - ColorZilla

You can pick the colour of an image or logo off a web page using [ColorZilla](https://www.colorzilla.com/)
to use it in a [Shields.io](https://shields.io) badge.

Install the [Chrome extension](https://chrome.google.com/webstore/detail/bhlhnicpbhignbdhedgjhgdocnmhomnp) or Firefox
extension and then just click the extension icon, picker and choose an icon or image or area from the web page.

For example, I used this to find out the exact yellow colour of the [Miro.com](https://miro.com) logo as `FEDD33`.

This would be hard to determine by guessing the colour, and if you just picked the generic `yellow` colour it would come
out as this:

[![Miro](https://img.shields.io/badge/Miro-dashboard-yellow.svg?logo=miro)](https://miro.com/app/dashboard/)

Whereas with the hex colour detection of the exact hex code of `FEDD33` it comes out as this, which is a very diffferent
yellow:

[![Miro](https://img.shields.io/badge/Miro-dashboard-FEDD33.svg?logo=miro)](https://miro.com/app/dashboard/)

## Star History Graphs

Generate nice graphs of how your repo's star counts increased over time.

### Star History

<https://star-history.com/>

<https://star-history.com/blog/how-to-use-github-star-history>

May look more like a steeper rise and therefore more impressive than Starcharts.cc below.

[![Star History Chart](https://api.star-history.com/svg?repos=HariSekhon/Knowledge-Base&type=Date)](https://star-history.com/#HariSekhon/Knowledge-Base&Date)

in Dark mode using HTML:

<a href="https://star-history.com/#HariSekhon/Knowledge-Base&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=HariSekhon/Knowledge-Base&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=HariSekhon/Knowledge-Base&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=HariSekhon/Knowledge-Base&type=Date" />
 </picture>
</a>

Use `Align timeline` and multiple repos to compare their stars at the same relative ages:

[![Star History Chart](https://api.star-history.com/svg?repos=HariSekhon/Jenkins,HariSekhon/GitHub-Actions&type=Timeline)](https://star-history.com/#HariSekhon/Jenkins&HariSekhon/GitHub-Actions&Timeline)

### Star Charts

<https://starchart.cc/>

[![Stargazers over time](https://starchart.cc/HariSekhon/Knowledge-Base.svg)](https://starchart.cc/HariSekhon/Knowledge-Base)

## Link Team Support Numbers to WhatsApp Desktop

Support mobile phone numbers should be created as WhatsApp links to allow one-click opening of chats in
[WhatsApp Desktop](https://www.whatsapp.com/download)
for convenience:

```markdown
[+44 776 999 1234](https://wa.me/447769991234)
```

This is not my real number. Recruiters please do not call it.

Also, if you have my real number, please do not call it.

Always message me on [LinkedIn](https://www.linkedin.com/in/HariSekhon) instead after reading my profile's summary
bullet point criteria - it'll give you nearly everything you need to know about my availability and preferences.

## Online Markdown Preview Editors

In no particular order since I don't use these, I use the [IntelliJ](intellij.md) markdown preview.

<https://dillinger.io/>

<https://stackedit.io/>

## Memes

### Peacocking Your Code

![Peacocking Your Code](images/orly_peacocking_your_code.jpeg)
