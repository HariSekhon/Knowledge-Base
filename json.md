# JSON

JavaScript Object Notation.

<https://en.wikipedia.org/wiki/JSON>

## jq

JSON Query filters json inputs - file or stdin.

Widely used in my scripts in [DevOps-Bash-tools](devops-bash-tools.md) repo.

<https://jqlang.github.io/jq/tutorial/>

<https://jqlang.github.io/jq/manual/>

## jnv

<https://github.com/ynqa/jnv>

Interactive JSON viewer.

Useful to quickly create `jq` queries by drilling down interactively.

```shell
cat data.json | jnv
```

or

```shell
jnv data.json
```

`Tab` completion.

`Ctrl`-`q` - copy `jq` query to clipboard to paste to code.

`Ctrl`-`o` - copy the JSON to clipboard.

[More Keyboard shortcuts](https://github.com/ynqa/jnv?tab=readme-ov-file#keymap).
