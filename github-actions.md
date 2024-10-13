# GitHub Actions

TL;DR - use GitHub Actions for general CI/CD since you should be using [GitHub](github.md) anyway -
use [Jenkins](jenkins.md) for self-hosted or more powerful / flexible / extensive CI/CD.

<!-- INDEX_START -->

- [Key Points](#key-points)
  - [Limitations](#limitations)
- [GitHub Actions Best Practices](#github-actions-best-practices)
  - [Pin 3rd party GitHub Actions to Git Hashrefs, not tags](#pin-3rd-party-github-actions-to-git-hashrefs-not-tags)
  - [Avoid `${{ inputs }}` Shell Injection](#avoid--inputs--shell-injection)
  - [Validate all `${{ inputs }}`](#validate-all--inputs-)
  - [Enforce Shell Error Detection for entire Workflow](#enforce-shell-error-detection-for-entire-workflow)
  - [Always Quote all Variables in Shell](#always-quote-all-variables-in-shell)
  - [Serialize Workflows with Steps sensitive to Race Conditions](#serialize-workflows-with-steps-sensitive-to-race-conditions)
  - [Serialize all workflows that commit to the same Git repo](#serialize-all-workflows-that-commit-to-the-same-git-repo)
  - [Avoid Race Condition - Do Not Tag from Moving Targets eg. `master` or `latest`](#avoid-race-condition---do-not-tag-from-moving-targets-eg-master-or-latest)
  - [Do Not Write Legacy Technical Debt Code](#do-not-write-legacy-technical-debt-code)
    - [No More `save-state` or `set-output` commands](#no-more-save-state-or-set-output-commands)
  - [Deduplicate Code Using Environment Variables grouped in top-level `env` section](#deduplicate-code-using-environment-variables-grouped-in-top-level-env-section)
  - [Begin Workflow Jobs with an Environment Printing Step](#begin-workflow-jobs-with-an-environment-printing-step)
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

## GitHub Actions Best Practices

Look at real-world production workflows for inspiration:

eg. [HariSekhon/GitHub-Actions](https://github.com/HariSekhon/GitHub-Actions) -
specifically the
[main.yaml](https://github.com/HariSekhon/GitHub-Actions/blob/master/main.yaml) template
and the [.github/workflows/*.yaml](https://github.com/HariSekhon/GitHub-Actions/tree/master/.github/workflows).

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=GitHub-Actions&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/GitHub-Actions)

### Pin 3rd party GitHub Actions to Git Hashrefs, not tags

For security, pin 3rd party GitHub Actions to a `@<git_hashref>` rather than a git tag.

Otherwise a compromised 3rd party GitHub Actions repo can be retagged with any arbitrary code which to induce
malicious code injection into your repo under your permissions when next called.

### Avoid `${{ inputs }}` Shell Injection

Do NOT use `${{ inputs.BLAH }}` directly in shell steps.

This leads is a script injection vulnerability.

Always put `${{ inputs.BLAH }}` into an `env` field either at top level or step level depending on your preference.

```yaml
env:
  MY_VAR: "${{ inputs.my_var }}"
```

This will quote any shell escape sequences. This is like SQL parameterized queries to avoid SQL Injection.

In Shell step just use it as a normal enviroment variable.

```yaml
steps:
  - name: Use Input as a normal Environment Variable
    run: echo "$MY_VAR"
```

### Validate all `${{ inputs }}`

Validate all `${{ inputs }}` contain what you expect them to contain.

Eg. a directory only has alphanumeric characters and no `..` for traversal attacks.

**Do not validate the `${{ inputs }}` in shell steps as per above you will introduce a code injection attack that
precedes the evaluation of the shell step to validate it!**

Instead, validate the `env` quoted content of the resulting environment variable from the section above.

### Enforce Shell Error Detection for entire Workflow

Make any unhandled error code in shell steps fail, including in subshells or unset variables,
and trace the output for immediately easier debugging to see which shell command line failed.

Taken from [HariSekhon/GitHub-Actions](https://github.com/HariSekhon/GitHub-Actions) -
[main.yaml](https://github.com/HariSekhon/GitHub-Actions/blob/master/main.yaml) template and
[.github/workflows/*.yaml](https://github.com/HariSekhon/GitHub-Actions/tree/master/.github/workflows):

Add this near the top of your workflow:

```yaml
defaults:
  run:
    shell: bash -euxo pipefail {0}
```

### Always Quote all Variables in Shell

This is basic shell scripting best practice in case your shell commands or variables end up containing an unexpected
space or other character that will otherwise break shell interpretation and lead to unexpected results.

NO:

```shell
var=$(somecommand)
```

NO:

```shell
echo $var
```

Yes:

```shell
var="$(somecommand)"
```

```shell
echo "$var"
```

### Serialize Workflows with Steps sensitive to Race Conditions

Taken from [HariSekhon/GitHub-Actions](https://github.com/HariSekhon/GitHub-Actions) -
[main.yaml](https://github.com/HariSekhon/GitHub-Actions/blob/master/main.yaml) template and
[.github/workflows/*.yaml](https://github.com/HariSekhon/GitHub-Actions/tree/master/.github/workflows):

```yaml
concurrency:
  # XXX: don't set this to the same group in a reusable workflow and calling workflow, that will result in a deadlock
  group: ${{ github.workflow }}
  cancel-in-progress: false
```

### Serialize all workflows that commit to the same Git repo

Serialize otherwise you will end up with git commit race condition breaking the workflow on git push:

```yaml
concurrency:
  # TODO: could possibly improve this to only serialize for the given branch
  group: my-repo-git-changes
  cancel-in-progress: false
```

### Avoid Race Condition - Do Not Tag from Moving Targets eg. `master` or `latest`

These can change in between the time you trigger the call or the workflow gets to the step that uses them,
which can lead to very confusing results when you don't get the version of code or docker image that you expected.

Always work on a hashrf.

You can determine the Git commit hashref from a given tag like so:

```shell
GIT_SHORT_SHA="$(git rev-list -n 1 --abbrev-commit "$TAG")"
```

### Do Not Write Legacy Technical Debt Code

Do not write legacy or technical debt code that will need to be changed later.

Be diligent about future engineering time, whether its yours or your colleagues.

#### No More `save-state` or `set-output` commands

These old constructs will break at some point and screw some poor engineer who inherits your code.

NO:

```yaml
- name: Save state
run: echo "::save-state name={name}::{value}"

- name: Set output
run: echo "::set-output name={name}::{value}"
```

Yes:

```yaml
- name: Save state
run: echo "{name}={value}" >> "$GITHUB_STATE"

- name: Set output
run: echo "{name}={value}" >> "$GITHUB_OUTPUT"
```

Documentation:

<https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/>

### Deduplicate Code Using Environment Variables grouped in top-level `env` section

Abstract out variable things that might change like server addresses, URLs, Docker image repo paths in the top-level
`env` section before the `jobs` section.

This makes it easier to see the variable parts of the code and manage them,
rather than interspersing them throughout sub `env` fields under `jobs` and `steps`.

Unfortunately at time of writing `env` fields cannot be composed of other `env` variables like can be done in
[Jenkins](jenkins.md), which would lead to better deduplication of string components among different environment
variables.

You can also verify the environment variables at the start of the job in a single step using the
Environment step below.

### Begin Workflow Jobs with an Environment Printing Step

This aids in debugging as it costs nothing computationally or time wise but means that you can at any time inspect the
environment of the job and any variables you expect to be set, whether implicitly available in the system or set by
yourself at a top level `env` section as per the section above.

Taken from [HariSekhon/GitHub-Actions](https://github.com/HariSekhon/GitHub-Actions) -
[main.yaml](https://github.com/HariSekhon/GitHub-Actions/blob/master/main.yaml) template and
[.github/workflows/*.yaml](https://github.com/HariSekhon/GitHub-Actions/tree/master/.github/workflows)

```yaml
    steps:
      - name: Environment
        run: |
          echo "Environment Variables:"
          echo
          env | sort
```

Or if even better show if you're inside Docker and on which Linux distro and version to aid any future environment
debugging:

```yaml
    steps:
      - name: Environment
        run: |
          [ -e /.dockerenv ] && ls -l /.dockerenv
          echo
          cat /etc/*-release
          echo
          echo "Environment Variables:"
          echo
          env | sort
```

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
- Jenkins is more powerful and flexible at the expense of more administration due to being self-hosted. What the world
  really needs is a cloud hosted Jenkins.
  - Jenkins can compose environment variable from other variables like a regular programming language - GitHub Actions
    at time of writing can't do this.

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

```text
Executable `/opt/hostedtoolcache/Ruby/3.3.4/x64/bin/ruby` not found
```

This was caused by stale cache when the `ruby/setup-ruby@v1` action updated the minor version from `3.3.4` to `3.3.5`
leading to the above cached `ruby` binary path using `3.3.4` not being found.

Solution: Delete the Cache and then re-run.

Via UI:

```text
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
