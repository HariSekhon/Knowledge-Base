# AMI Scanning

Scan for known [CVEs](https://www.cve.org/about/overview) vulnerabilities from the online CVE database,
as well as misconfigurations and deviations from best practices.

See also the [Container Scanning](container-scanning.md) page.

<!-- INDEX_START -->

- [Open Source](#open-source)
  - [Trivy](#trivy)
  - [Grype](#grype)
  - [Checkov](#checkov)
- [Proprietary](#proprietary)
  - [AWS Inspector](#aws-inspector)
  - [Aqua Security](#aqua-security)
  - [Prowler](#prowler)
  - [Tenable.io](#tenableio)
  - [Anchore](#anchore)
  - [Snyk Infrastructure as Code](#snyk-infrastructure-as-code)
  - [CrowdStrike Falcon](#crowdstrike-falcon)
  - [CloudSploit](#cloudsploit)
  - [Microsoft Defender for Cloud](#microsoft-defender-for-cloud)
- [Less Known Solutions](#less-known-solutions)
  - [Wiz](#wiz)
  - [Qualys Cloud Platform](#qualys-cloud-platform)
  - [Prisma Cloud by Palo Alto Networks](#prisma-cloud-by-palo-alto-networks)
  - [Lacework](#lacework)
  - [Orca Security](#orca-security)
  - [Sysdig](#sysdig)
  - [Trend Micro Cloud One](#trend-micro-cloud-one)
  - [Rapid7 InsightVM](#rapid7-insightvm)
  - [Deep Security by Trend Micro](#deep-security-by-trend-micro)
  - [Dome9 by Check Point](#dome9-by-check-point)
- [Packer Build for AWS AMI](#packer-build-for-aws-ami)

<!-- INDEX_END -->

## Open Source

### Trivy

[:octocat: aquasecurity/trivy](https://github.com/aquasecurity/trivy)

<https://trivy.dev/latest/>

<https://www.aquasec.com/blog/trivy-now-scans-amazon-machine-images-amis/>

See [Trivy](trivy.md) doc.

### Grype

[:ocatocat: anchore/grype](https://github.com/anchore/grype)

Not as well suited as Trivy, needs to scan a running instance booted from an AMI
or a filesystem extract of an AMI.

### Checkov

<https://www.checkov.io/>

Checkov  by Bridgecrew is an open-source infrastructure-as-code scanning tool by Bridgecrew that also includes
capabilities for AMI scanning to catch misconfigurations and compliance issues.

## Proprietary

### AWS Inspector

<https://aws.amazon.com/inspector/>

Scans AMIs and EC2 instances for vulnerabilities and deviations from security best practices.

### Aqua Security

<https://www.aquasec.com/>

Full suite of propietary cloud-native security tools by the creators of [Trivy](#trivy) -
includes scanning for AMI vulnerabilities and compliance checks within AWS environments.

### Prowler

<https://www.prowler.cloud/>

Comprehensive security auditing, including AMI scanning, for AWS environments.

### Tenable.io

<https://www.tenable.com/products/tenable-io>

By the creators of the famous and widely used open source security scanner Nessus that has been around forever.

### Anchore

<https://anchore.com/>

Proprietary tools by the creators of [Grype](#grype) that includes deep container and AMI scanning capabilities to
detect vulnerabilities, enforce security policies, and ensure compliance in AWS.

### Snyk Infrastructure as Code

<https://snyk.io/product/infrastructure-as-code-security/>

Snyk provides security for infrastructure-as-code, including AMI scanning, to catch potential misconfigurations and
security vulnerabilities.

### CrowdStrike Falcon

<https://www.crowdstrike.com/products/cloud-security/>

CrowdStrike Falcon provides endpoint security with cloud scanning capabilities, including AMI vulnerability scanning and
continuous monitoring for AWS.

Installation script for AWS AMI build can be found in the [HariSekhon/Packer](https://github.com/HariSekhon/Packer) repo.

### CloudSploit

<https://cloudsploit.com/>

Continuous vulnerability scanning, including AMIs scanning, to detect potential misconfigurations and security risks.

### Microsoft Defender for Cloud

<https://azure.microsoft.com/en-us/services/defender-for-cloud/>

Security monitoring across cloud environments, including AMI vulnerability scanning and best practices for AWS.

## Less Known Solutions

### Wiz

<https://www.wiz.io/>

AMI scanning to detect security vulnerabilities and misconfigurations in AWS.

### Qualys Cloud Platform

<https://www.qualys.com/>

Provides continuous security scanning, including for AMIs, to detect vulnerabilities, compliance issues, and
misconfigurations.

### Prisma Cloud by Palo Alto Networks

<https://www.paloaltonetworks.com/prisma/cloud>

Continuous security monitoring for cloud environments, including AMI scanning, to detect vulnerabilities and enforce
compliance.

### Lacework

<https://www.lacework.com/>

Cloud security platform that includes AMI scanning, compliance, and best practices for AWS resources.

### Orca Security

<https://orca.security/>

AMI scanning for vulnerabilities, compliance and misconfigurations across AWS environments.

### Sysdig

<https://sysdig.com/>

Vulnerability scanning for AMIs and compliance checks for cloud enviroments.

### Trend Micro Cloud One

<https://www.trendmicro.com/cloudone>

Trend Micro Cloud One provides multi-cloud security, including AMI scanning to detect vulnerabilities,
manage compliance, and safeguard AWS instances.

### Rapid7 InsightVM

<https://www.rapid7.com/products/insightvm/>

InsightVM by Rapid7 provides cloud-native vulnerability management, including AMI scanning to identify security risks in
AWS environments.

### Deep Security by Trend Micro

<https://www.trendmicro.com/en_us/business/products/hybrid-cloud/deep-security.html>

Comprehensive protection for AWS environments, including AMI scanning to detect vulnerabilities and maintain compliance.

### Dome9 by Check Point

<https://www.checkpoint.com/products/cloudguard-dome9/>

Cloud security management with AMI scanning capabilities to help manage security and compliance for AWS resources.

## Packer Build for AWS AMI

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Packer-templates&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Packer-templates)

**Ported from various private Knowledge Base pages 2018+**
