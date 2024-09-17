# Cloud

<!-- INDEX_START -->

- [Major Public Cloud Providers](#major-public-cloud-providers)
- [AWS vs GCP](#aws-vs-gcp)

<!-- INDEX_END -->

## Major Public Cloud Providers

- [AWS](aws.md)
- [GCloud](gcloud.md)
- [Azure](azure.md)
- [Digital Ocean](digital-ocean.md)

## AWS vs GCP

A common staying:

> Google’s Beta is like AWS’s GA

- Google is strongly consistent eg. GCS consistent lists and gets, KMS global consistent, Cloud Spanner
  - AWS has a lot of eventually consistent services, which pushes complexity to the developer
- GCE can configure any CPU / RAM ratio and has few simpler instance types: micro, standard, highmem, highcpu
- GCP resource names are shorter or named yourself, not <tonnesOfChars>.cloudfront.net
- GCP console global view
  - AWS zone/region view
- GCP doesn’t requires 2FA every day like AWS
- GCS S3 API doesn't require S3 Proxy like Azure
- GCP live migrates VMs
  - AWS maintenance requires a reboot
- GCE Pre-emptible instances 80% discount for 30 sec warning
  - AWS Spot Instances with 2 min warning - GCE can spin up instances quicker though as a result
- GCE Committed Use Discounts buy CPU / RAM / disk 1 to 3 years can be used on any instance in region, unlike AWS Reserved Instances which are tied to family
  - automatically applied to anything you run, and above that Sustained Use Discounts are applied automatically
- GCP networks are global with no cost for inter-region traffic
  - AWS requires NAT Gateway (or deprecated Nat Instance) for inter-region VPC traffic

<!-- -->

- AWS Billing better reports + estimated usage
  - GCP only alerts on actual usage, must set 25%, 50% alerts etc. New Billing Forecasts feature may solve this forecast alerting

<!-- -->

- GCP developer focused moving towards ops
  - builds innovative tools that you couldn't be able to build/deploy yourself
  - global focus - easier to handle latency & failures
- AWS ops focused moving towards development
  - steals open source tools and automates their management
  - regional focus - simplifies data soverignty

<!-- -->

- AWS Secrets Manager
  - GCP has Cloud KMS and HSM, or can use EnvKey

<!-- -->

- GCE default I/O is faster than AWS which requires using provisioned IOPS EBS which cost almost double
- GCE block storage 10TB max vs AWS 1TB max
- GCE block storage can be mounted read-only to many other instances
- AWS more instance types
- AWS more regions + availability zones
- GCE live migration of instances for zero downtime when doing host hardware maintenance, but may need to downtime an entire site??
- GCE auto restart option, auto-respawns in < 3 mins
- AWS more services
- AWS more OS images
- AWS has spot instances
- AWS has reserved instances
- AWS developer/business support is cheaper than GCE (49/100 dollars vs 150/400 dollars)
- AWS LDAP or custom users without email, Google require GMail account
- AWS uses Xen, GCE uses KVM
- GCE snapshots are global not region+copy
- GCE better inter-region speeds (300 vs 40MB/s)
- Google has better global dark fiber network
