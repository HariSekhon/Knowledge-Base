# Artifact Registries

- [Artifactory](https://jfrog.com/artifactory/) -
JFrog Artifactory is one of the two classic artifact registries
  - mature, full featured
  - traditionally self-hosted
  - [Artifactory Cloud](https://jfrog.com/artifactory/cloud-automation/) - fully managed hosted version available now
  - self-hosted also deploys on [Kubernetes](kubernetes.md) now too - for ready-made config see
[HariSekhon/Kubernetes-configs - artifactory](https://github.com/HariSekhon/Kubernetes-configs/tree/master/artifactory)
  - see [Artifactory doc](artifactory.md) in this repo for more info
- [Nexus](https://www.sonatype.com/products/sonatype-nexus-repository) - Sonatype Nexus is the other classic artifact registry
  - traditionally self-hosted
  - has cloud offerings but not as SaaS as Artifactory
- [AWS CodeArtifact](https://aws.amazon.com/codeartifact/) - basic but useful if you are already using AWS
  - cheap
  - doesn't require an extra quote, approval and purpose order processing
  - see this knowledge base's [AWS](aws.md) page
- [GCP Artifact Registry](https://cloud.google.com/artifact-registry) - similar to AWS Artifact Registry but from a richer heritage
  - replaces the most widely used cloud registry [Google Container Registry]() which was used by the goliath [Kubernetes](kubernetes.md) project
  - see this knowledge base's [GCP](gcp.md) page
- [Azure DevOps Artifacts](https://azure.microsoft.com/en-gb/products/devops/artifacts) -
convenient for those already using Azure DevOps for repo hosting as it's integrated into the same UI, rather than a separate service like with AWS and GCP
- JFrog BinTray - was a free for open source cloud multi-repo Docker Registry, Maven, Deb, RPM, NPM, Vagrant boxes, Generic. Has been [shut down](https://jfrog.com/blog/into-the-sunset-bintray-jcenter-gocenter-and-chartcenter/) in 2021

###### Ported from private Knowledge Base page 2014+
