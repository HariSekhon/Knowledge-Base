# MkDocs

<https://www.mkdocs.org/getting-started/>

<https://www.mkdocs.org/user-guide/writing-your-docs/>

Markdown is expected in top-level `docs/` dir, with `docs/index.md` being the home page.

<!-- INDEX_START -->

- [Install](#install)
- [Template](#template)
- [Build](#build)
- [Preview Locally](#preview-locally)
- [Plugins](#plugins)
  - [D2 Embedded Diagrams](#d2-embedded-diagrams)
- [MkDocs Gotchas](#mkdocs-gotchas)
  - [Bare URLs Are Not Clickable](#bare-urls-are-not-clickable)
  - [Quadruple Backticks don't work in MKDocs](#quadruple-backticks-dont-work-in-mkdocs)

<!-- INDEX_END -->

## Install

```shell
pip install mkdocs
```

## Template

[HariSekhon/Templates - mkdocs.yml](https://github.com/HariSekhon/Templates/blob/master/mkdocs.yml)

## Build

- build the `site/` dir, containing the HTML, Javascript, `sitemap.xml` and `mkdocs/search_index.json`
- `site/` should be added to [.gitignore](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/.gitignore)

```shell
mkdocs build
```

## Preview Locally

Launch a local web server at <http://127.0.0.1:8000>:

```shell
mkdocs serve
```

On Mac, you can open this from the CLI:

```shell
open http://127.0.0.1:8000
```

## Plugins

### D2 Embedded Diagrams

[:octocat: landmaj/mkdocs-d2-plugin](https://github.com/landmaj/mkdocs-d2-plugin)

## MkDocs Gotchas

Some things that render fine in Markdown break in MKDocs:

### Bare URLs Are Not Clickable

Bare URLs are links on GitHub `README.md` but not in MKDocs generated pages

Enclose them in `<` and `>` to make sure they become links.

### Quadruple Backticks don't work in MKDocs

A stray backtick on a triple backticks code block,
or an intentional quadruple backticks used to enclose a code sample containing
triple backticks (such as seen in the [Markdown](markdown.md) doc page) will work in GitHub Markdown
and [IntelliJ](intellij.md) local rendering
but break formatting in MKDocs.
