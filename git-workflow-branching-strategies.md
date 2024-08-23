# Git Workflow Branching Strategies

<!-- INDEX_START -->

- [GitHub Flow - Simplest](#github-flow---simplest)
- [GitLab Flow](#gitlab-flow)
- [Gitflow - Most Complicated](#gitflow---most-complicated)
- [Great Tips](#great-tips)
- [Environment Branching Strategy](#environment-branching-strategy)
- [GitHub Flow with Jira ticket integration](#github-flow-with-jira-ticket-integration)
- [Why you shouldn't use long-lived feature branches](#why-you-shouldnt-use-long-lived-feature-branches)

<!-- INDEX_END -->

## GitHub Flow - Simplest

Best for personal projects.

<https://guides.github.com/introduction/flow/>

## GitLab Flow

<https://docs.gitlab.com/ee/topics/gitlab_flow.html>

## Gitflow - Most Complicated

Best for legacy versioned software maintaining minor and patches semver versioning.

<https://datasift.github.io/gitflow/IntroducingGitFlow.html>

<https://nvie.com/posts/a-successful-git-branching-model/>

## Great Tips

<https://docs.microsoft.com/en-us/azure/devops/repos/git/git-branching-guidance?view=azure-devops>

## Environment Branching Strategy

This is an unofficial strategy that I've seen used in the real world because it's simple and it works.

It's basically the [GitHub Flow](#github-flow---simplest) strategy
except you have a branch for each of your 3 environments - Dev, Staging and Production.

Not everybody likes environment branches, but they worked in production for over 2 years and they are easy to use.

At least they don't [only test in Production](https://github.com/HariSekhon/Diagrams-as-Code/blob/master/README.md#devs-test-in-production)!

Another internet facing client refused to use tagging because they didn't want to have to think up version or release numbers for their website releases.


Also, contrary to some naysayers it's quite easy to diff environment branches as everything should be in Git, so you can get a very quick and easy difference between your environments in a single `git diff` command. It's also easy to automate backporting hotfixes to lower environments:

- GitHub repo: [HariSekhon/Jenkins](https://github.com/HariSekhon/Jenkin)
  - [gitMerge.groovy](https://github.com/HariSekhon/Jenkins/blob/master/vars/gitMerge.groovy)
  - [gitMergePipeline.groovy](https://github.com/HariSekhon/Jenkins/blob/master/vars/gitMergePipeline.groovy)

```mermaid
%%{ init: {
        "logLevel": "debug",
        "theme": "dark",
        "gitGraph": {
            "mainBranchName": "dev"
        },
        "themeVariables": {
            "git0": "red",
            "git1": "blue ",
            "git2": "green",
            "gitInv0": "#FFFFFF",
            "gitBranchLabel0": "#FFFFFF",
            "commitLabelColor": "#FFFFFF"
        }
    }
}%%

gitGraph
    branch staging
    branch production

    checkout dev
    commit id: "commit 1"

    checkout staging
    commit id: "QA fix 1 "

    checkout production
    commit id: "hotfix commit"

    checkout dev
    commit id: "commit 2"

    checkout staging
    merge dev id: "fast-forward merge" tag: "CI/CD + QA Tests"

    checkout production
    merge staging id: "fast-forward merge " tag: "v2023.1 Release (CI/CD)"


    checkout dev
    commit id: "commit 3"

    checkout staging
    commit id: "QA fix 2 "

    #checkout production
    #commit id: "commit 3  "

    checkout dev
    commit id: "commit 4"

    checkout staging
    merge dev id: "fast-forward merge 2" tag: "CI/CD + QA Tests"

    checkout production
    merge staging id: "fast-forward merge 2 " tag: "v2023.2 Release (CI/CD)"


    checkout dev
    commit id: "commit 5"

    checkout staging
    commit id: "QA fix 3 "

    #checkout production
    #commit id: "commit 5  "

    checkout dev
    commit id: "commit 6"

    checkout staging
    merge dev id: "fast-forward merge 3" tag: "CI/CD + QA Tests"

    checkout production
    merge staging id: "fast-forward merge 3 " tag: "v2023.3 Release (CI/CD)"
```
Note: I did eventually move this client to tagged releases using `YYYY.NN` release format, just incrementing `NN` which is a no brainer ([githubNextRelease.groovy](https://github.com/HariSekhon/Jenkins/blob/master/vars/githubNextRelease.groovy)). It turns out the developers had eventually started using releases in Jira labelled as `YYYY.NN` to track which tickets were going into which production deployment, so when I pushed for this, it made sense to them finally as not being too great an inconvenience! It's also easy to automate by creating GitHub Releases in Jenkins ([githubCreateRelease.groovy](https://github.com/HariSekhon/Jenkins/blob/master/vars/githubCreateRelease.groovy)).


## GitHub Flow with Jira ticket integration

Prefix Git branches with Jira ticket numbers in Jira's `AA-NNN` format for GitHub Pull Requests to automatically appear in Jira tickets (see this [doc](https://support.atlassian.com/jira-cloud-administration/docs/integrate-with-github/)):

```mermaid
%% https://mermaid.js.org/syntax/gitgraph.html#gitgraph-specific-configuration-options
%% https://htmlcolorcodes.com/
%%{ init: {
        "logLevel": "debug",
        "theme": "dark",
        "themeVariables": {
            "git0": "#839192",
            "git1": "#2874A6",
            "gitInv0": "#FFFFFF",
            "gitBranchLabel0": "#FFFFFF",
            "commitLabelColor": "#FFFFFF"
        }
    }
}%%
gitGraph
    commit
    commit id: "branch"
    branch AA-NNN-my-feature-branch
    checkout AA-NNN-my-feature-branch
    commit id: "add code"
    commit id: "refine code"
    checkout main
    merge AA-NNN-my-feature-branch id: "merge PR" type: HIGHLIGHT tag: "2023.15 release"
    commit
    commit
```


## Why you shouldn't use long-lived feature branches

\* [Environment Branches](#environment-branching-strategy) may be one of the few exceptions but requires workflow discipline.

See Also: 100+ scripts for Git and the major Git repo providers like GitHub, GitLab, Bitbucket, Azure DevOps in my [DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools) repo.

```mermaid
%% https://mermaid.js.org/syntax/gitgraph.html#gitgraph-specific-configuration-options
%% https://htmlcolorcodes.com/
%%{ init: {
        "logLevel": "debug",
        "theme": "dark",
        "gitGraph": {
            "mainBranchName": "master"
        },
        "themeVariables": {
            "git0": "#839192",
            "git1": "#C0392B ",
            "git2": "#2E86C1",
            "gitInv0": "#FFFFFF",
            "gitBranchLabel0": "#FFFFFF",
            "commitLabelColor": "#FFFFFF"
        }
    }
}%%
gitGraph
    commit  id: "commit 1"
    commit id: "branch"
    branch long-lived-branch
    checkout long-lived-branch
    commit id: "50 clever commits"
    checkout master
    commit id: "commit 2"
    checkout long-lived-branch
    commit id: "too clever"
    checkout master
    commit id: "commit 3"
    checkout long-lived-branch
    commit id: "too long"
    checkout master
    commit id: "commit 4"
    checkout long-lived-branch
    commit id: "try to merge back"
    checkout master
    merge long-lived-branch id: "Merge Conflict!!" type: REVERSE
    checkout long-lived-branch
    commit id: "trying to fix"
    commit id: "still trying to fix"
    commit id: "struggling to fix"
    commit id: "ask Hari for help"
    branch fixes-branch-to-send-to-naughty-colleague
    checkout fixes-branch-to-send-to-naughty-colleague
    commit id: "fix 1"
    commit id: "fix 2"
    commit id: "fix 3"
    commit id: "could have been working on better things!"
    checkout long-lived-branch
    merge fixes-branch-to-send-to-naughty-colleague id: "merge fixes" type: HIGHLIGHT
    commit id: "more commits"
    commit id: "because this branch only had 105 commits already"
    checkout master
    merge long-lived-branch id: "Finallly Merged!" type: HIGHLIGHT
    commit id: "Please never do that again"
```
