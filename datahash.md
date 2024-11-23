# Datahash

<https://www.datahash.com/>

Deployed on AWS by Terraform.

<!-- INDEX_START -->

- [Terraform Overview](#terraform-overview)
  - [Providers](#providers)
  - [Modules](#modules)
  - [Components](#components)
  - [IAM policies](#iam-policies)
- [Architecture](#architecture)

<!-- INDEX_END -->

## Terraform Overview

### Providers

- AWS
- HTTP
- Kubernetes
- Helm

### Modules

- EKS
- Lambda
- Kinesis
- CloudWatch Alarm

### Components

- EKS Cluster
  - ALB Ingress
  - Metrics server (Helm install)
  - Autoscaler installed (Helm install)
- DynamoDB - several tables
- Fluentbit for AWS
- ElastiCache
- Security Groups eg. ElastiCache
- Kinesis - 2 streams:
  - `events-stream`
  - `offline-events-stream`
- SQS
- Lambda functions:
  - used as connectors for:
    - Facebook
    - LinkedIn
    - Snapchat
    - TikTok
    - Twitter
    - Google Ads
    - Google Enhanced Conversions
    - Signal
  - storing sources and destinations in DynamoDB from SQS queue
  - depends on IAM policies

### IAM policies

- EKS, ECR, IRSA, autoscaler, OIDC
- Kinesis
- DynamoDB
- Lambda to DynamoDB
- S3 buckets
- Glue
- Athena
- 1 VPC
- SQS
- EC2
- SNS topic
- CloudWatch Metric Alarm
- ELB, AWS LB Controller, WAFv2, WAF regional, Shield

## Architecture

TODO: diagram needed - get from vendor website or self-make one.
