# GitHub Actions

TL;DR - use GitHub Actions for general CI/CD since you should be using [GitHub](github.md) anyway -
use [Jenkins](jenkins.md) for self-hosted or more powerful / flexible / extensive CI/CD.

<!-- INDEX_START -->

- [Key Points](#key-points)
  - [Limitations](#limitations)
- [GitHub Actions vs Jenkins](#github-actions-vs-jenkins)
- [Diagrams](#diagrams)
  - [GitHub Actions CI/CD to auto-(re)generate diagrams from code changes (Python)](#github-actions-cicd-to-auto-regenerate-diagrams-from-code-changes-python)
  - [GitHub Actions CI/CD to auto-(re)generate diagrams from code changes (D2lang)](#github-actions-cicd-to-auto-regenerate-diagrams-from-code-changes-d2lang)
- [Troubleshooting](#troubleshooting)
  - [Executable `/opt/hostedtoolcache/...` not found](#executable-opthostedtoolcache-not-found)

<!-- INDEX_END -->

## Key Points

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

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=GitHub-Actions&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/GitHub-Actions)

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

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Jenkins&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Jenkins)

## Diagrams

From the [HariSekhon/Diagrams-as-Code](https://github.com/HariSekhon/Diagrams-as-Code) repo:

### GitHub Actions CI/CD to auto-(re)generate diagrams from code changes (Python)

[github_actions_cicd.py](https://github.com/HariSekhon/Diagrams-as-Code/blob/master/github_actions_cicd.py):

![GitHub Actions CI/CD](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/github_actions_cicd.png)

### GitHub Actions CI/CD to auto-(re)generate diagrams from code changes (D2lang)

Open [Diagrams-as-Code README.md](https://github.com/HariSekhon/Diagrams-as-Code/blob/master/README.md#this-repos-creation--github-actions-cicd-to-auto-regenerate-diagrams-from-code-changes) to enlarge:

[github_actions_cicd.d2](https://github.com/HariSekhon/Diagrams-as-Code/blob/master/github_actions_cicd.d2):

![GitHub Actions CI/CD](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/github_actions_cicd.svg)

## Troubleshooting

### Executable `/opt/hostedtoolcache/...` not found

```none
Executable `/opt/hostedtoolcache/Ruby/3.3.4/x64/bin/ruby` not found
```

This was caused by stale cache when the `ruby/setup-ruby@v1` action updated the minor version from `3.3.4` to `3.3.5`
leading to the above cached `ruby` binary path using `3.3.4` not being found.

Solution: Delete the Cache and then re-run.

Via UI:

```none
https://github.com/<OWNER>/<REPO>/actions/caches
```

or

Via GitHub CLI in the git checkout:

```shell
gh cache list
```

```shell
gh cache delete "$cache_id"  # from above command
```

**Ported from private Knowledge Base page 2019+**
