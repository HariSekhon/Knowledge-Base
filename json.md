# JSON

JavaScript Object Notation.

For JSON basics, read [Wikipedia](https://en.wikipedia.org/wiki/JSON).

Useful JSON tools:

<!-- INDEX_START -->

- [gron](#gron)
- [jq](#jq)
  - [jq tips](#jq-tips)
    - [jq default value](#jq-default-value)
    - [jq find field anywhere in struct](#jq-find-field-anywhere-in-struct)
- [jnv](#jnv)
- [Java Libraries](#java-libraries)
- [Conversion](#conversion)
  - [XML to JSON](#xml-to-json)
  - [JSON to YAML](#json-to-yaml)
  - [JSON to CSV](#json-to-csv)
- [Pretty Print / format JSON](#pretty-print--format-json)
- [JSON Linting](#json-linting)
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

### jq tips

#### jq default value

`jq` returns literal `null` string for fields that don't exist, this is annoying af in bash scripts where you will
often be testing for failing to find something using `[ -z "$output" ]`.

To avoid this and have jq return a default value, blank in this case, instead of a literal `null`:

```shell
jq -r '.non_existent_key // ""' < file.json
```

#### jq find field anywhere in struct

Find and output the `policy` field from anywhere in the JSON.
Most of the time you should understand the schema and specify it explicitly.

```shell
jq -r '.. | objects | select(has("policy")) | .policy'
```

- `..` recurses
- `objects` filters to only objects (ignores arrays & scalars)
- `select(has("policy"))` returns only objects with a `policy` field
- `.policy` selects that field out of those subset of objects

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

- [Jackson](https://github.com/FasterXML/jackson)
- [Gson](https://github.com/google/gson)

## Conversion

### XML to JSON

```shell
xml2json
```

### JSON to YAML

```shell
yq -P < "$file"
```

or from [DevOps-Bash-tools](devops-bash-tools.md):

```shell
json2yaml.sh "$file"
```

or

```shell
json2yaml.sh < "$file"
```

This will figure out which of the following you have installed and use the first one it finds in this order:

```shell
ruby -r yaml -r json -e 'puts YAML.dump(JSON.parse(STDIN.read))' < "$file"
```

```shell
python -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)' < "$file"
```

This script doesn't use these any more:

- `yq` - there were two different ones found in `$PATH` that could result in different results:
- Perl `JSON::XS`
  - sorted the keys, losing the original structure of the file where the variables were at the top for human
    readability
  - found when converting a json to yaml that it converted this:

```json
"ssh_pty": true
```

to this useless thing:

```json
ssh_pty: !!perl/scalar:JSON::PP::Boolean 1
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
