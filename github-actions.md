# GitHub Actions

TL;DR - use GitHub Actions for general CI/CD since you should be using [GitHub](github.md) anyway -
use [Jenkins](jenkins.md) for self-hosted or more powerful / flexible / extensive CI/CD.

- fully hosted
- unlimited build minutes for public projects
- 2,000 free private build minutes for users / orgs
- 50,000 build minutes per month for cloud enterprise Orgs (essentially free - better than paying for [CircleCI](circleci.md)!)
  - optional self-hosted runners - [HariSekhon/Kubernetes-configs - github-actions](https://github.com/HariSekhon/Kubernetes-configs/blob/master/github-actions)
- Good Integrations:
  - `GITHUB_TOKEN` automatically available with tunable permissions
  - Code Scanning via Sarif file uploads to the Security Tabs of a repo (see
[HariSekhon/GitHub-Actions](https://github.com/HariSekhon/GitHub-Actions))
    - free for public repos
    - requires a Security seats license per commit user in last 90 days on top of the GitHub Enterprise user seat license
  - PR / issues actions / comments / auto-merges
- GitHub Marketplace - lots of 3rd parties already have importable actions

### Limitations

- no auto-cancellation of older builds
- no auto-retry like Jenkins `retry{}`
- can't compose environment variables from other environment variables (must use step action workaround, see [HariSekhon/GitHub-Actions main.yaml template](https://github.com/HariSekhon/GitHub-Actions/blob/master/main.yaml))
- can't use environment variables in GitHub Actions `with:` inputs to imported actions/workflows
- can't export environment variables to GitHub Actions / Reusable Workflows
- Secrets must be passed explicitly via `${ secrets.<name> }`

## GitHub Actions vs Jenkins

- GitHub Actions is fully-hosted so immediately available and bypasses most operational & governance issues where
[CloudBees](jenkins.md#cloudbees) is focused
- GitHub Actions is much cheaper - we already have 50,000 build minutes a month essentially for free, and $0.008 per
minute thereafter
- Legacy Enterprise licensing just doesn't make sense any more given company estates are increasingly cloud-based
these days
  - 2 vendors I was working with were trying to switch based to PAYG licensing model based on my feedback - cloud-native
    billing can work out to pennies on the dollar
- GitHub Actions also has self-hosted runners, so can operate it at the same cost as Jenkins free, just paying for
your own compute
  - many hosted CI/CD providers are offering this in the 2020s now I've noticed with the standardization on Docker and Kubernetes
- GitHub Actions has a much better API than Jenkins
- GitHub Actions has a much better CLI than Jenkins
- GitHub Actions has better/easier integrations
- GitHub Actions is more self-service for developers who are often already using it for their open source projects
- GitHub Actions is supporting open-source projects the most among hosted CI/CD providers by being completely free for
public projects, without usage limits, and Jenkins has no comparable hosted counterpart to date

I've had similar feedback from both technical player-managers, developers and DevOps colleagues.

I'd like to see [CloudBees](jenkins.md#cloudbees) build a 100% hosted Jenkins solution with the same billing cost per
minute as GitHub Actions, with a whole new clean Rest API and CLI. Self-hosted runners at no cost are pretty important
too, both to access internal tooling services as part of CI/CD pipelines as well as to control costs. Some of the other
vendors who have tried to limit self-hosted runners to more expensive plans have essentially shot themselves in the foot
because they've made themselves economically non-competitive.

###### Ported from private Knowledge Base page 2019+
