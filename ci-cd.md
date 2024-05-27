# CI/CD - Continuous Integration / Continuous Delivery

Continually tests, builds your code packages and deploys them.

#### TL;DR use GitHub Actions for fully hosted and Jenkins for self-hosted or more power.

GitHub Actions self-hosted runners are also a reasonable option.

CI/CD pipeline configurations for the below technologies can be found throughout my public
[GitHub repos](https://github.com/HariSekhon?tab=repositories&q=&type=&language=&sort=stargazers)
as they were used to actually build my many open source projects.

API code for many of the following technologies can also be found in my
[DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools) repo.

## Self-Hosted CI/CD

- [Jenkins](https://www.jenkins.io/) - the gold standard open source CI/CD - powerful, extensible, simple to complex to suit any need
  - see docs: [Jenkins](jenkins.md) and [Jenkins-on-Kubernetes](jenkins-on-kubernetes.md)
  - [HariSekhon/Jenkins](https://github.com/HariSekhon/Jenkins) - advanced `Jenkinsfile` master template and Groovy Shared Library of functions and pipelines
  - [HariSekhon/DevOps-Bash-tools `jenkins/`](https://github.com/HariSekhon/DevOps-Bash-tools#cicd---continuous-integration--continuous-deployment) -
    many Jenkins admin scripts using the Jenkins API and CLI tool
- [TeamCity](https://www.jetbrains.com/teamcity/) - proprietary by JetBrains (makers of IntelliJ, expert coders and UX), decent, good UI, but hard sell vs free Jenkins
  - [HariSekhon/TeamCity-CI](https://github.com/HariSekhon/TeamCity-CI)
- [Concourse](https://concourse-ci.org/) - simple, lean, open source CI/CD tool, `fly` CLI is easier to use than Jenkins CLI for easy triggering and testing
  - [HariSekhon/Templates - .concourse.yml](https://github.com/HariSekhon/Templates/blob/master/.concourse.yml)
  - [HariSekhon/DevOps-Bash-tools `cicd/`](https://github.com/HariSekhon/DevOps-Bash-tools#cicd---continuous-integration--continuous-deployment) -
    Concourse one-shot bootstrap in Docker - starts, opens UI, loads `cicd/.concourse.yml` in local repo and runs build
- [GoCD](https://www.gocd.org/index.html) - open source by ThoughtWorks, half-way between Concourse simplicity and Jenkins extensibility
  - [HariSekhon/Templates - .gocd.yml](https://github.com/HariSekhon/Templates/blob/master/.gocd.yml)
  - [HariSekhon/DevOps-Bash-tools `cicd/`](https://github.com/HariSekhon/DevOps-Bash-tools#cicd---continuous-integration--continuous-deployment) -
    GoCD one-shot bootstrap in Docker - starts, opens UI, loads `cicd/.gocd.yml` in local repo and runs build

## Hosted CI/CD by Git repo providers

Already available on the major Git repo providers.

All are yaml-based configuration CI/CD with no installation or administration required.

Optional self-hosted runners are available to install on your own hardware or [Kubernetes](kubernetes.md),
to have more control of your execution environment or offload build minutes costs if used heavily.

- [GitHub Actions](https://github.com/features/actions) - the 800lb gorilla of CI/CD
  - easily the best choice overall for hosted CI/CD
  - unlimited free minutes for public projects
  - 50,000 build minutes included in any GitHub Enterprise Cloud plan makes this a CircleCI killer on cost alone
  - Massive community support and extensibility via [GitHub Actions Marketplace](https://github.com/marketplace?type=actions)
  - 3rd party actions by many prominent tech vendors
  - 1st class support - every tech vendor targets GitHub Actions as their primary CI/CD client as they're following both the tech and the market
  - [GitHub Enterprise Server](https://docs.github.com/en/enterprise-server@3.9/admin/overview/about-github-enterprise-server) for on-premise (government, banks etc.)
  - self-hosted [runners](https://github.com/HariSekhon/Kubernetes-configs/tree/master/github-actions) can be run on Kubernetes for Cloud hosted version
  - now owned by Microsoft
  - [HariSekhon/GitHub-Actions](https://github.com/HariSekhon/GitHub-Actions) - library of parameterized reusable workflows and master templates for workflows and actions
  - [HariSekhon/DevOps-Bash-tools `github/`](https://github.com/HariSekhon/DevOps-Bash-tools#cicd---continuous-integration--continuous-deployment) -
    many GitHub Actions admin scripts using the GitHub API and CLI tool
- [GitLab CI](https://docs.gitlab.com/ee/ci/) - the second-best repo provider and CI/CD
  - uses a single yaml, not as flexible as GitHub Actions
  - good API and documentation - similar endpoints and parity of functionality with GitHub
  - lacks GitHub Actions marketplace
  - self-hosted [runners](https://docs.gitlab.com/runner/) can be run on Kubernetes
  - 400 free build minutes a month
    - has relegated this to a legacy CI/CD for open source
  - do not use unless you're going Enterprise and are forced to use it
  - [GitLab server](https://about.gitlab.com/install/) for on-premise (government, banks etc.)
  - [HariSekhon/Templates - .gitlab-ci.yml](https://github.com/HariSekhon/Templates/blob/master/.gitlab-ci.yml)
  - [HariSekhon/DevOps-Bash-tools `gitlab/`](https://github.com/HariSekhon/DevOps-Bash-tools#cicd---continuous-integration--continuous-deployment) -
    several GitLab admin scripts using the GitLab API
- [Azure DevOps Pipelines](https://azure.microsoft.com/en-gb/products/devops/pipelines) - Microsoft's offering to accompany their Git repo hosting
  - uses a single yaml, not as flexible as GitHub Actions
  - worse UI than GitHub and GitLab
  - worse functionality
  - fewer integrations than GitHub
  - awful API
  - [Azure DevOps Server](https://azure.microsoft.com/en-us/products/devops/server) for on-premise is a rebranding of the legacy Team Foundation Server (TFS)
  - [HariSekhon/Templates - azure-pipelines.yml](https://github.com/HariSekhon/Templates/blob/master/azure-pipelines.yml)
  - [HariSekhon/Templates - azure-pipeline-template.yml](https://github.com/HariSekhon/Templates/blob/master/azure-pipeline-template.yml)
  - do not use Azure DevOps unless your company absolutely forces you to
  - [HariSekhon/DevOps-Bash-tools `azure_devops/`](https://github.com/HariSekhon/DevOps-Bash-tools#cicd---continuous-integration--continuous-deployment) -
    several Azure DevOps admin scripts using the Azure DevOps API
- [Bitbucket Pipelines](https://bitbucket.org/product/features/pipelines) -
the weakest repo provider and weakest CI/CD system
  - not as many features
  - not a great API
  - 50 free build minutes a month
    - when they dropped the free build minutes this rendered this useless for open source folks
    - unless you like getting constant emails of build failures due to no build minutes
  - [Bitbucket Data Center](https://confluence.atlassian.com/bitbucketserver/bitbucket-data-center-documentation-776639749.html) is the on-premise installable version
  - this product is one of Atlassian's rare fails to compete in the software market as they have many more widely used products like Jira, Confluence, Fisheye etc.
  - [HariSekhon/Templates - bitbucket-pipelines.yml](https://github.com/HariSekhon/Templates/blob/master/bitbucket-pipelines.yml)
  - [HariSekhon/DevOps-Bash-tools `bitbucket/`](https://github.com/HariSekhon/DevOps-Bash-tools#git---github-gitlab-bitbucket-azure-devops) -
    several BitBucket admin scripts using the Bitbucket API
  - Legacy. Do not use.

## Hosted CI/CD - Cloud

- [AWS CodeBuild](https://aws.amazon.com/codebuild/)
  - cheap pay-as-you-go integrated with your existing AWS bill, convenient for no additional accounts, approvals or purchase orders
  - too basic in functionality - poor man's CI/CD
  - good security integration with other AWS services due to all being under AWS IAM
  - most companies use GitHub Actions instead for good reason - if you're in the cloud anyway, GitHub has better features, security and integrations
  - [HariSekhon/Templates- AWS CodeBuild buildspec.yaml](https://github.com/HariSekhon/Templates/blob/master/buildspec.yml)
- [GCP CloudBuild](https://cloud.google.com/build?hl=en)
  - formerly called Container Builder which should give you a hint as to its intended purpose
  - similar advantages and drawbacks to AWS CodeBuild
  - basic functionality
  - cheap with integrated pay-as-you-go billing inside your existing Google Cloud account, no extra purchase orders and approvals needed in your enterprise
  - good security integration with other GCP services due to all being under GCP IAM
  - [Kaniko](https://github.com/GoogleContainerTools/kaniko) integration but in my experience your mileage may vary
  - [HariSekhon/Templates - cloudbuild.yaml](https://github.com/HariSekhon/Templates/blob/master/cloudbuild.yaml) and [cloudbuild-golang.yaml](https://github.com/HariSekhon/Templates/blob/master/cloudbuild-golang.yaml)
- Azure DevOps Pipelines - legacy, see above section

## Hosted CI/CD - 3rd Party (all are legacy)

- [CircleCI](https://circleci.com/) - mature long-standing frontrunner among hosted CI/CD systems
  - free tier with 6000 build minutes a month and 30 parallel builds
  - self-hosted [runners](https://github.com/HariSekhon/Kubernetes-configs/tree/master/circleci) can be run on Kubernetes
  - legacy enterprise licensing model requires up front yearly usage estimation
  - very expensive compared to GitHub Actions
  - [HariSekhon/Templates - .circleci/config](https://github.com/HariSekhon/Templates/blob/master/circleci-config.yml)
  - [HariSekhon/DevOps-Bash-tools `circleci/`](https://github.com/HariSekhon/DevOps-Bash-tools#cicd---continuous-integration--continuous-deployment) -
    several CircleCI admin scripts using the CircleCI API
- [Travis CI](https://www.travis-ci.com/) - one of the first best hosted CI/CD systems
  - used to be free for open source on travis-ci.org which has been shut down
    - legacy now as a result
    - [HariSekhon/Templates - .travis-ci.yml](https://github.com/HariSekhon/Templates/blob/master/.travis.yml)
    - Real world usage example -
[HariSekhon/DevOps-Bash-tools .travis-ci.yml](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/travis/.travis.yml)
- [BuildKite](https://buildkite.com/) - Cloud control panel with self-hosted agents
  - quite good API
  - [HariSekhon/DevOps-Bash-tools `buildkite/`](https://github.com/HariSekhon/DevOps-Bash-tools#cicd---continuous-integration--continuous-deployment) -
    many BuildKite admin scripts using the above API
- [AppVeyor](https://www.appveyor.com/) - has Windows builds if you're into that sort of legacy thing
  - [HariSekhon/Templates .appveyor.yml](https://github.com/HariSekhon/Templates/blob/master/.appveyor.yml)
  - [HariSekhon/DevOps-Bash-tools `appveyor/`](https://github.com/HariSekhon/DevOps-Bash-tools/tree/master/appveyor) -
    a few scripts for AppVeyor API and self-hosted agents
- [Cirrus CI](https://cirrus-ci.org/) - nothing special, another yaml CI/CD
  - [HariSekhon/Templates .cirrus.yml](https://github.com/HariSekhon/Templates/blob/master/.cirrus.yml)
- [Codefresh](https://codefresh.io/)
  - don't like the UI
  - had many issues with this platform
  - better at blogging about CI/CD
  - [HariSekhon/Templates codefresh.yml](https://github.com/HariSekhon/Templates/blob/master/codefresh.yml)
- [DroneIO](https://www.drone.io/) - Python/Scala (beta), Groovy (new) - unlimited for public project builds but soft limit 30 mins
  - see adjacent doc: [drone.io.md](drone.io.md)
  - [HariSekhon/Templates - drone.yml](https://github.com/HariSekhon/Templates/blob/master/.drone.yml)
  - [HariSekhon/DevOps-Bash-tools drone/](https://github.com/HariSekhon/DevOps-Bash-tools/tree/master/drone) -
    a couple scripts for Drone.io's API and self-hosted runners
- [Semaphore CI](https://semaphoreci.com/) - nothing special, has its own Python environment quirks
  - [HariSekhon/Templates - semaphore.yml](https://github.com/HariSekhon/Templates/blob/master/semaphore.yml)
- [CodeShip](https://www.cloudbees.com/products/codeship) - docker support, pricey. Dead
  - Acquired by CloudBees, no longer free
    - not sure why they bothered when [CloudBees](jenkins.md#cloudbees) are Jenkins experts. Hosted Jenkins is what people really want. That or GitHub Actions whose yaml is simpler than Jenkinsfiles
- Shippable - 1 parallel build. [Acquired](https://jfrog.com/blog/weve-acquired-shippable-to-complete-devops-pipeline-automation-from-code-to-production/) by JFrog. Decommissioned / Dead.
- NimbleCI - only 300 build minutes per month. Decommissioned / Dead.

## See Also

[Code Quality](code-quality.md)

###### Ported from private Knowledge Base page 2014+
