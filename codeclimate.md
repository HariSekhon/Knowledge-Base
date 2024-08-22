# CodeClimate

<https://codeclimate.com/>

<!-- INDEX_START -->

- [CLI](#cli)

<!-- INDEX_END -->

## CLI

```shell
brew tap codeclimate/formulae
brew install codeclimate
```

Generate `.codeclimate.yml`

```shell
codeclimate init
```

Edit, then validate:

```shell
codeclimate validate-config
```

Spawns docker container to run engines, takes a few mins, gives a long text output:

```shell
codeclimate analyze
```

**Ported from private Knowledge Base page 2016+**
