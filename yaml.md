# YAML - Yet Another Markup Language

YAML is used for configuration by many technologies as it's easier and cleaner to read and write than JSON / XML.

<!-- INDEX_START -->

- [References](#references)
- [Key Points](#key-points)
- [YAML Linting](#yaml-linting)
- [Advanced YAML](#advanced-yaml)
  - [Anchors and References](#anchors-and-references)
  - [Override / Extend - Anchors and References](#override--extend---anchors-and-references)

<!-- INDEX_END -->

## References

<https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html>

<https://spacelift.io/blog/yaml>

<https://www.educative.io/blog/advanced-yaml-syntax-cheatsheet>

<http://yaml.org/refcard.html>

## Key Points

Yaml better than JSON, adds:

- comments
- extensible data types
- relational anchors
- strings without quotation marks
- mapping types preserving key order

- must quote these constructs:
  - colon followed by space or EOL
  - string literal `"True"` (otherwise assumes boolean)
  - string literal `"1.2"` (otherwise assumes float)

```yaml
- list_item1
- list_item2:
  key1: val1
  key2: val2

        |
        line1
        line2
        line3

        >
        single
        long
        line
```

## YAML Linting

Always lint your YAML to catch otherwise hard to spot whitespace errors such as inconsistent indentation or tabs vs spaces.

I use [YAMLLint](https://github.com/adrienverge/yamllint) which is automatically installed by [DevOps-Bash-tools](devops-bash-tools.md)
and you can run the `check_yaml.sh` script in that repo to recurse the current or given directory and check all the YAML files.

I run this automatically in all [my GitHub repos](https://github.com/HariSekhon) via [CI/CD](ci-cd.md).

## Advanced YAML

### Anchors and References

Use `&` prefix anchor to mark a section and `*` to reference to it later in the same YAML to reduce duplication.

### Override / Extend - Anchors and References

Prefix the `*<name>` reference with `<<:` to allow you to add more fields underneath it. Same name fields are overridden.
