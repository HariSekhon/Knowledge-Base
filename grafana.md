# Grafana

NOT PORTED YET

<!-- INDEX_START -->

- [Install](#install)
  - [On Mac](#on-mac)
- [CLI](#cli)
- [API](#api)
- [Grafana Alerts](#grafana-alerts)
- [Grafana AWS Cloudwatch Dashboards](#grafana-aws-cloudwatch-dashboards)

<!-- INDEX_END -->

## Install

### On Mac

```shell
brew install grafana
```

## CLI

Comes with the `grafana` package above.

Very limited functionality. API below is much better.

```shell
grafana cli --help
```

## API

From [DevOps-Bash-tools](devops-bash-tools.md) repo:

```shell
grafana_api.sh --help
```

The `--help` shows various examples you can use straight away.

## Grafana Alerts

Grafana alerts occasionally missed alerts,
if the pod went down it lost alerts as they were are persisted,
so switched to using [Prometheus Alert Manager](prometheus.md#alert-manager).

## Grafana AWS Cloudwatch Dashboards

[monitoringartist/grafana-aws-cloudwatch-dashboards](https://github.com/monitoringartist/grafana-aws-cloudwatch-dashboards)

40+ Grafana dashboards for AWS CloudWatch metrics: EC2, Lambda, S3, ELB, EMR, EBS, SNS, SES, SQS, RDS, EFS, ElastiCache, Billing, API Gateway, VPN, Step Functions, Route 53, CodeBuild, ...
