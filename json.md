# JSON

JavaScript Object Notation.

For JSON basics, read [Wikipedia](https://en.wikipedia.org/wiki/JSON).

Useful JSON tools:

<!-- INDEX_START -->

- [gron](#gron)
- [jq](#jq)
- [jnv](#jnv)
- [Java Libraries](#java-libraries)
- [Conversion](#conversion)
  - [XML to JSON](#xml-to-json)
  - [JSON to CSV](#json-to-csv)
- [Pretty Print / format JSON](#pretty-print--format-json)
- [JSON Format Validation](#json-format-validation)
  - [IDEs](#ides)

<!-- INDEX_END -->

## gron

<https://github.com/tomnomnom/gron>

Flattens JSON to be greppable.

```shell
gron "https://api.github.com/repos/tomnomnom/gron/commits?per_page=1" |
fgrep "commit.author"
```

unflatten back to expanded JSON:

```shell
gron "https://api.github.com/repos/tomnomnom/gron/commits?per_page=1" |
fgrep "commit.author" |
gron -u
```

## jq

JSON Query filters json inputs - file or stdin.

Pre-compiled C available for all platforms.

Widely used in my scripts in [DevOps-Bash-tools](devops-bash-tools.md) repo.

<https://jqlang.github.io/jq/tutorial/>

<https://jqlang.github.io/jq/manual/>

`jq` returns literal `null` string for fields that don't exist, this is annoying af in bash scripts where you will
often be testing for failing to find something using `[ -z "$output" ]`.

To avoid this and have jq return a default value, blank in this case, instead of a literal `null`:

```shell
jq -r '.non_existent_key // ""' < file.json
```

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

## Java Libraries

- Jackson
- Gson

## Conversion

### XML to JSON

```shell
xml2json
```

### JSON to CSV

```shell
json2csv
```

## Pretty Print / format JSON

Perl `JSON::XS` CPAN module (doesn't sort keys):

```shell
json_xs
```

Python 2.6+ (sorts keys):

```shell
python -m json.tool
```

## JSON Linting

From [DevOps-Bash-tools](devops-bash-tools.md), recursively find and lint all `*.json` files:

```shell
check_json.sh
```

From [DevOps-Python-tools](devops-python-tools.md), recursively find and lint all `*.json` files:

```shell
validate_json.py .
```

I run these automatically in all [my GitHub repos](https://github.com/HariSekhon) via [CI/CD](cicd.md).

### IDEs

- [Eclipse](editors.md#eclipse) JSONTools validation plugin (Help -> MarketPlace)
  - needs file extensions to be `.json` (not `.template` from [AWS](aws.md) CloudFormation)
- [IntelliJ](intellij.md) also has JSON error validation but it's not as easy to see underscores vs the big red cross
  Eclipse puts in the left column
