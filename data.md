# Data

<!-- INDEX_START -->

- [Big Data](#big-data)
- [Data Validation](#data-validation)
- [Data Generation](#data-generation)
- [Data Integration](#data-integration)
  - [Mulesoft](#mulesoft)
  - [Spring Integration](#spring-integration)
- [Data Visualization](#data-visualization)
- [Diagrams](#diagrams)
  - [Top 9 Systems Integrations](#top-9-systems-integrations)
  - [Encoding vs Encryption vs Tokenization](#encoding-vs-encryption-vs-tokenization)

<!-- INDEX_END -->

## Big Data

See [big-data.md](big-data.md)

## Data Validation

Start by validating data formats for correctness.

Scripts for this can be found in both the [DevOps-Python-tools](devops-python-tools.md)
and [DevOps-Bash-tools](devops-bash-tools.md) repos.

Then proceed to more advanced content validation.

## Data Generation

'Faker' libraries are available in many languages inspired by the original
[Perl library](https://metacpan.org/dist/Data-Faker).

Perl version: <https://metacpan.org/dist/Data-Faker>

Java version: :octocat: [DiUS/java-faker](https://github.com/DiUS/java-faker)

Python version :octocat: [joke2k/faker](https://github.com/joke2k/faker) -
comes with a `faker` command convenient for shell scripts:

Generate 10 fake addresses:

```shell
faker -r 10 address
```

## Data Integration

- [DBT](https://www.getdbt.com) - open-source data pipeline workflow tool
- [Informatica](informatica.md) - proprietary legacy now available via SaaS, with self-hosted agents on VMs or
  [Kubernetes](kubernetes.md)
- [Airbyte](https://airbyte.com/product/airbyte-open-source) - open source
  self-hosted or SaaS proprietary with 300+ connectors
  - :octocat: [airbytehq/airbyte](https://github.com/airbytehq/airbyte)
- [Meltano](https://meltano.com/) - open-source CLI based ELT
  - :octocat: [meltano/meltano](https://github.com/meltano/meltano)
- [Apache Camel](camel.md) - open source with 100+ connectors
- Spring Integration - XML config, only use for Spring heavy shops
- Mulesoft - XML config, only use for proprietary connectors

### Mulesoft

- lightweight enterprise service bus + integration framework
- proprietary connectors
- Anypoint Studio (Eclipse-based IDE)
- Anypoint Enterprise Security - security features, transactions

### Spring Integration

TODO

## Data Visualization

See the [Diagrams](diagrams.md) and [Visualization](visualization.md) docs.

## Diagrams

### Top 9 Systems Integrations

![](images/top_9_systems_integrations.gif)

### Encoding vs Encryption vs Tokenization

![Encoding vs Encryption vs Tokenization](images/encoding_vs_encryption_vs_tokenization.gif)

**Ported from private Knowledge Base pages 2016+**
