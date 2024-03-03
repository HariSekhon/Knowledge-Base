# CI/CD - Continuous Integration / Continuous Delivery

Continually tests, builds your code packages and deploys them.

## Self-Hosted CI/CD

- [Jenkins](https://www.jenkins.io/) - the gold standard open source CI/CD - powerful, extensible, simple to complex to suit your needs
- [TeamCity](https://www.jetbrains.com/teamcity/) - proprietary by JetBrains (makers of IntelliJ, expert coders and UX), decent, good UI, but hard sell vs free Jenkins
- [Concourse](https://concourse-ci.org/) - simple, lean, open source CI/CD tool, `fly` CLI is easier to use than Jenkins CLI for easy triggering and testing
- [GoCD](https://www.gocd.org/index.html) - open source by ThoughtWorks, half-way between Concourse simplicity and Jenkins extensibility

## Host CI/CD by Git repo providers

Already available on the major Git repo providers.

All are yaml-based configuration CI/CD with no installation or administration required.

Optional self-hosted runners are available to install on your own hardware or [Kubernetes](kubernetes.md),
to have more control of your execution environment or offload build minutes costs if used heavily.

- [GitHub Actions](https://github.com/features/actions) - the new 800lb gorilla of CI/CD
  - easily the best choice overall for hosted CI/CD
  - unlimited free minutes for public projects
  - 50,000 build minutes included in any GitHub Enterprise Cloud plan makes this a CircleCI killer on cost alone
  - Massive community support and extensibility via GitHub Actions Marketplace
  - 3rd party actions by many prominent tech vendors
  - now owned by Microsoft
- [Azure DevOps Pipelines](https://azure.microsoft.com/en-gb/products/devops/pipelines) - Microsoft's offering to accompany their Git repo hosting
  - uses a single yaml, not as flexible as GitHub Actions
  - poor API
  - do not use this unless your company forces you to
- [GitLab CI](https://docs.gitlab.com/ee/ci/) - the second best repo provider drops to 3rd place for CI/CD
  - uses a single yaml, not as flexible as GitHub Actions
  - good API and documentation
  - lacks GitHub Actions marketplace
  - 400 free build minutes a month
    - has dropped this to 3rd place and relegated this to a legacy CI/CD for open source folks
    - do not use unless you're going Enterprise and are forced to use it
- [Bitbucket Pipelines](https://bitbucket.org/product/features/pipelines) -
the weakest repo provider and weakest CI/CD system
  - not as many features
  - not a great API
  - 50 free build minutes a month
    - when they droped the free build minutes this rendered this useless for open source folks
    - unless you like getting constant emails of build failures due to no build minutes
  - Legacy. Do not use.

## Hosted CI/CD - 3rd Party and legacy

- [CircleCI](https://circleci.com/) - mature long standing frontrunner among hosted CI/CD systems
  - free tier with 6000 build minutes a month and 30 parallel builds
- [Travis CI](https://www.travis-ci.com/) - one of the first best hosted CI/CD systems
  - used to be free for open source on travis-ci.org which has been shut down
    - legacy now as a result
    - Template - [.travis-ci.yml](https://github.com/HariSekhon/Templates/blob/master/.travis.yml)
    - Real world usage example -
[DevOps-Bash-tools .travis-ci.yml](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/travis/.travis.yml)
- [AppVeyor](https://www.appveyor.com/) - has Windows builds if you're into that sort of legacy thing
- [DroneIO](https://www.drone.io/) - Python/Scala (beta), Groovy (new) - unlimited for public project builds but soft limit 30 mins
  - see [drone.io.md](drone.io.md)
- [CodeShip](https://www.cloudbees.com/products/codeship) - docker support, pricey. Dead
  - Acquired by CloudBees, no longer free
    - not sure why they bothered when [CloudBees](jenkins.md#cloudbees) are Jenkins experts. Hosted Jenkins is what people really want. That or GitHub Actions whose yaml is simpler than Jenkinsfiles
- Shippable - 1 parallel build. [Acquired](https://jfrog.com/blog/weve-acquired-shippable-to-complete-devops-pipeline-automation-from-code-to-production/) by JFrog. Dead.
- NimbleCI - only 300 build minutes per month :-(. Dead.

## See Also

[Code Quality](codequality.md)

###### Ported from private Knowledge Base page 2014+
