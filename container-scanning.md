# Container Scanning

Scan for known CVEs from online databases.

## Open Source

### Trivy

https://github.com/aquasecurity/trivy

### Grype

https://github.com/anchore/grype

### Clair

https://github.com/coreos/clair

Open source static analysis image vulnerability scanner by CoreOS

Not as good quality, easy to use or reliable in my experience:

https://github.com/quay/clair/issues/1756

## Proprietary

### Aqua Security

https://www.aquasec.com/products/aqua-container-security-platform/

Container security - wraps docker socket to control + kill container launches

### Twistlock

https://www.twistlock.com/

### Tenable.io

Scanner for docker images (company behind Nessus) - one client's tech hub had this. Scans happened 10-40 mins behind
  async because it's slow

https://docs.tenable.com/vulnerability-management/Content/ContainerSecurity/CSScanner.htm

### CheckMarx

https://checkmarx.com/resource/documents/en/34965-19110-container-scans.html

## Container Scanning on Jenkins

![](https://raw.githubusercontent.com/HariSekhon/Diagrams-as-Code/master/images/jenkins_kubernetes_cicd.svg)
