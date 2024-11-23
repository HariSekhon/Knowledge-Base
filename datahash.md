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

- 1 VPC
- EKS Cluster
  - ALB Ingress
  - Metrics server (Helm install)
  - Autoscaler installed (Helm install)
  - AWS LB Controller
  - Fluentbit for AWS
- ECR
- S3 buckets
- DynamoDB - several tables
- ElastiCache
- Kinesis - 2 streams:
  - `events-stream`
  - `offline-events-stream`
- SQS queue
- SNS topic
- Glue
- Athena
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
- CloudWatch Metric Alarm
- Security Groups eg. ElastiCache
- IAM policies for all of the above eg.
  - EC2 for EKS, OIDC, IRSA, ECR, Lambda to DynamoDB
  - ELB, AWS LB Controller, WAFv2, WAF regional, Shield

## Architecture

TODO: diagram needed - get from vendor website or self-make one.
