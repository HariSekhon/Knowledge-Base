# YAML - Yet Another Markup Language

YAML is used for configuration by many technologies as it's easier and cleaner to read and write than JSON / XML.

Worth a read:

<https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html>

<https://spacelift.io/blog/yaml>

<https://www.educative.io/blog/advanced-yaml-syntax-cheatsheet>

<!-- INDEX_START -->
- [YAML Linting](#yaml-linting)
- [Advanced YAML](#advanced-yaml)
  - [Anchors and References](#anchors-and-references)
  - [Override / Extend - Anchors and References](#override--extend---anchors-and-references)
<!-- INDEX_END -->

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
