# MkDocs

https://www.mkdocs.org/getting-started/

https://www.mkdocs.org/user-guide/writing-your-docs/

Markdown is expected in top-level `docs/` dir, with `docs/index.md` being the home page.

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
