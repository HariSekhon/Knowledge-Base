# MkDocs

<https://www.mkdocs.org/getting-started/>

<https://www.mkdocs.org/user-guide/writing-your-docs/>

Markdown is expected in top-level `docs/` dir, with `docs/index.md` being the home page.

<!-- INDEX_START -->
  - [Install](#install)
  - [Template](#template)
  - [Build](#build)
  - [Preview Locally](#preview-locally)
  - [MkDocs Brittleness](#mkdocs-brittleness)
<!-- INDEX_END -->

### Install

```shell
pip install mkdocs
```

### Template

[HariSekhon/Templates - mkdocs.yml](https://github.com/HariSekhon/Templates/blob/master/mkdocs.yml)

### Build

- build the `site/` dir, containing the HTML, Javascript, `sitemap.xml` and `mkdocs/search_index.json`
- `site/` should be added to [.gitignore](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/.gitignore)

```shell
mkdocs build
```

### Preview Locally

Launch a local web server at http://127.0.0.1:8000:

```shell
mkdocs serve
```

On Mac, you can open this from the CLI:

```shell
open http://127.0.0.1:8000
```

### MkDocs Brittleness

Some things that render fine in Markdown break in MKDocs:

- bare URLs are links on GitHub READMEs but not in MKDocs generated pages
  - Enclose them in `<` and `>` to make sure they become links
- a stray backtick on a triple backticks code block, such as a quadruple backticks closing will break formatting in
  MKDocs but work fine in [IntelliJ](intellij.md) local rendering
