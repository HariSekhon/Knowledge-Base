# Git

## Index

<!-- INDEX_START -->

- [Workflow Branching Strategies](#workflow-branching-strategies)
- [Advanced Git Config](#advanced-git-config)
- [GitHub SSH Key SSO Authorization](#github-ssh-key-sso-authorization)
- [Git HTTPS Authentication](#git-https-authentication)
- [CLIs](#clis)
- [GitHub Badges](#github-badges)
- [Basic Tips](#basic-tips)
- [Advanced Tips & Tricks](#advanced-tips--tricks)
  - [Git Clone using a specific SSH Key](#git-clone-using-a-specific-ssh-key)
  - [Show files not being tracked due to global & local `.gitignore` files](#show-files-not-being-tracked-due-to-global--local-gitignore-files)
  - [Find line in `.gitignore` which is causing a given file to be ignored](#find-line-in-gitignore-which-is-causing-a-given-file-to-be-ignored)
  - [Trigger CI/CD using empty commit](#trigger-cicd-using-empty-commit)
  - [Copy a file from another branch](#copy-a-file-from-another-branch)
  - [Ammend Last Commit](#ammend-last-commit)
  - [Git Reflog](#git-reflog)
  - [Pull from Upstream Origin in a local Fork](#pull-from-upstream-origin-in-a-local-fork)
  - [Multi-Origin Remotes](#multi-origin-remotes)
    - [Advanced - push to different branch on remote](#advanced---push-to-different-branch-on-remote)
  - [Set Git Commit Author using Environment Variables (for CI/CD workflows)](#set-git-commit-author-using-environment-variables-for-cicd-workflows)
  - [Fix Author / Email in Git Pull Request or History](#fix-author--email-in-git-pull-request-or-history)
  - [Erase Leaked Credential in Pull Request](#erase-leaked-credential-in-pull-request)
  - [Convert GitHub.com links to Raw GitHub URL links](#convert-githubcom-links-to-raw-github-url-links)
  - [Git Filter-Repo](#git-filter-repo)
  - [Git Filter-Repo Analyze](#git-filter-repo-analyze)
  - [Git Filter-Repo Replace Text in Commit History](#git-filter-repo-replace-text-in-commit-history)
  - [Git Filter-Repo Remove File(s) from Commit History](#git-filter-repo-remove-files-from-commit-history)
  - [Erase Leaked Credential in Git History](#erase-leaked-credential-in-git-history)
  - [Merge a branch from another repo into the current repo](#merge-a-branch-from-another-repo-into-the-current-repo)
  - [Reset and Re-download Git Submodule](#reset-and-re-download-git-submodule)
  - [Get the Default Branch](#get-the-default-branch)
  - [Get Current Branch](#get-current-branch)
  - [Find which upstream `<remote>/<branch>` the current branch is set to track](#find-which-upstream-remotebranch-the-current-branch-is-set-to-track)
  - [List files changed on current branch vs default branch](#list-files-changed-on-current-branch-vs-default-branch)
  - [List files added on current branch vs default branch](#list-files-added-on-current-branch-vs-default-branch)
  - [Push New Branch and Set Upstream in One Command](#push-new-branch-and-set-upstream-in-one-command)
  - [Push New Branch and Raise Pull Request in One Command](#push-new-branch-and-raise-pull-request-in-one-command)
    - [On GitHub](#on-github)
    - [On GitLab](#on-gitlab)
- [Git LFS](#git-lfs)
  - [Why You Need Git LFS for Large Files](#why-you-need-git-lfs-for-large-files)
  - [Git LFS on other hosting providers](#git-lfs-on-other-hosting-providers)

<!-- INDEX_END -->

## Workflow Branching Strategies

This is a big topic which warrants its own page:

[Git Workflow Branching Strategies](git-workflow-branching-strategies.md)

## Advanced Git Config

[HariSekhon/DevOps-Bash-tools - .gitconfig](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/.gitconfig)

[HariSekhon/DevOps-Bash-tools - .gitignore](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/.gitignore)

You can inherit all configs by just cloning the [repo](https://github.com/HariSekhon/DevOps-Bash-tools#readme) and `make link` to symlink them to your home directory:

```shell
git clone https://github.com/HariSekhon/DevOps-Bash-tools bash-tools
```

```shell
cd bash-tools
make link
```

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=DevOps-Bash-tools&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/DevOps-Bash-tools)

## GitHub SSH Key SSO Authorization

See [GitHub page - SSH Key SSO Authorization](github.md#github-ssh-key-sso-authorization)

## Git HTTPS Authentication

Using HTTPS for `git clone` / `pull` / `push` are more likely to bypass egress content filters on wifi portals for those of you
who travel a lot such as remote workers and digital nomads.

Credential helper config for this can be added to an individual git repo or at the global level
which is shown in the advanced [.gitconfig](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/.gitconfig) introduced above.

There is a script to add it to your local repo in the [DevOps-Bash-tools](devops-bash-tools.md):

```shell
git_remotes_set_https_creds_helpers.sh
```

After that you need either `$GH_TOKEN` or `$GITHUB_TOKEN` (in that order of precedence) in your environment variables.

Create your GitHub Personal Access Token (PAT) here:

<https://github.com/settings/tokens>

Or you can install
[Git Credentials Manager](https://docs.github.com/en/get-started/getting-started-with-git/caching-your-github-credentials-in-git#git-credential-manager)
which will prompt for your credentials and cache them the first time you `git pull` over HTTPS.

## CLIs

Standard Git CLI is already provided by XCode on Mac but you can also install it from Homebrew to get a different version:

```shell
brew install git
```

GitHub CLI:

```shell
brew install gh
```

You will need to export `$GH_TOKEN` for the GitHub CLI. Create your token [here](https://github.com/settings/tokens).

GitHub specific git commands to make things like cloning GitHub repos shorter:

```shell
brew install hub
```

GitLab CLI:

```shell
gem install --user-install gitlab
```

Bitbucket CLI:

```shell
pip install --user bitbucket-cli
```

## GitHub Badges

<https://github.com/commonality/architecture-decision-records/wiki/GitHub-repository-status-badges>

## Basic Tips

- Commit frequently:
  - make small, atomic commits for easier tracking and diffs
- Push frequently to your remote origin as a backup:
  - in case you have a local disaster
- Write clear commit messages:
  - summarize what changed and more importantly why
  - some companies prefix Jira ticket numbers to their commits or Pull Requests
    - Jira can be configured to automatically link a field in each ticket to such PRs
- Use Comments to explain any clever tricks in code:
  - it's better than `git blame` which may get covered up on subsequent edits
- Use branches:
  - isolate new features, bug fixes, or experiments
  - see [Git Workflow Branching Strategies](git-workflow-branching-strategies.md)
  - TL;DR just use simple [GitHub flow](https://docs.github.com/en/get-started/using-github/github-flow) to get started, you can change it later
- Keep branches short-lived:
  - merge back to the main branch quickly to avoid large hard to review Pull Requests or merge conflicts
  - see [Why You Shouldn't Use Long Lived Branches](git-workflow-branching-strategies.md#why-you-shouldnt-use-long-lived-feature-branches)
- Pull and merge to your branch frequently:
  - this minimizes merge conflicts
  - resolve merge conflicts early
    - they will get bigger over time if you don't merge and resolve conflicts reguarly
- Don't commit large files:
  - it'll slow down your repo cloning and local checkout size
  - use [.gitignore](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/.gitignore)
    to exclude unnecessary files like large or binary files
  - large files are better handled in external blob storage
  - if you really need large files in Git, see [Git LFS](#git-lfs) further down
- Don't Rebase - read [The Evils of Git Rebasing](git-workflow-branching-strategies.md#the-evils-of-rebasing)
  - it's not the default for good reason, it causes more problems
- Use tags for releases:
  - mark important commits like version, stable releases
  - before and after big refactors
- Use Pull Requests for better tracking
- Use Branch protections to:
  - ensure your important trunk branches like `master` / `main` or
    [environment branches](git-workflow-branching-strategies.md#environment-branching-strategy)
    don't get accidentally deleted
  - enforce code peer review approvals on Pull Requests before merging for quality control
  - this is to sanity check design and approach rather than linting for minor typos and errors which CI/CD should catch
    instead
- Use [CI/CD](ci-cd.md) for extensive linting and testing:
  - set this up asap to trigger on both trunk and especially Pull Requests
    - this can block introducing rubbish code & style
  - you are inheriting technical debt daily until you set this up and will end up with ever more code to fix up
    the longer you delay adding this

## Advanced Tips & Tricks

### Git Clone using a specific SSH Key

Git SSH Clone with a specific private key:

```shell
GIT_SSH_COMMAND="ssh -i teamcity_github_ssh_key" git clone git@github.com:ORG/REPO
```

### Show files not being tracked due to global & local `.gitignore` files

```shell
git status --ignored
```

### Find line in `.gitignore` which is causing a given file to be ignored

If you have a large [.gitignore](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/.gitignore)
and want to find which line is causing a file to be ignored, do this:

```shell
git check-ignore -v -- .github/scripts/
```

output:

```text
/Users/h.sekhon/.gitignore:3711:[Ss]cripts      .github/scripts/
```

### Trigger CI/CD using empty commit

Use for cases where PR checks are failing on PR metadata
and you just need a fresh run triggered but don't need to change your branch contents.

This has the advantage of avoiding dismissing your already hard earnt GitHub Pull Request approvals and re-bugging your
colleagues to re-approve some trivial unnecessary change.

```shell
git commit --allow-empty -m 'Empty commit to trigger CI'
```

### Copy a file from another branch

```shell
git checkout "$branch" "$filename"
```

This puts it straight into the cache for commit, so you'll need to `git reset` if you don't want to commit it.

### Ammend Last Commit

It you commit and then notice a small change you needed to make to the commit

```shell
git commit --amend --no-edit
```

### Git Reflog

Shows the tips of branches that changed in the local repo.
Useful to be able to go back in time to points of pulls.
This will be less commits to wade through than `git log`.

```shell
git reflog
```

Can use these reference points in other git commands like `git checkout` or
`git reset` (use the latter with care it unwinds commits).

`HEAD@{2}` means "where HEAD used to be two moves ago".

`master@{one.week.ago}` means "where master used to point to one week ago in this local repository".

### Pull from Upstream Origin in a local Fork

To make it easier to stay up to date with an upstream source repo when you're in a clone of its fork, add it:

```shell
git remote add upstream "$url_to_original_repo"
```

You can then pull from the upstream to your local fork branch:

```shell
git pull upstream main
```

Remember not to make any commits to your fork's main trunk branch.

It needs to stay cleanly aligned with the upstream and only be used to merge upstream updates into your personal feature branch in your fork.

That personal feature branch will contain your changes to raise pull requests back to the main trunk branch of the upstream repo.

### Multi-Origin Remotes

Store your repo on multiple Git repo providers.

Useful for backups in case there is an outage to [GitHub](https://github.com) / [GitLab](https://gitlab.com) / [Bitbucket](https://bitbucket.org) / [Azure DevOps](https://dev.azure.com) - you can still pull / push to the other.

Add one or more remote repo URLs to the current git checkout:

See [bash-tools/git/git_remotes_set_multi_origin.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/git/git_remotes_set_multi_origin.sh) which automates this to all major Git hosting providers

```shell
git remote set-url --add origin $url2
git remote set-url --add origin $url3
```

See the remotes configured for origin:

```shell
$ git remote -v
origin  git@github.com:HariSekhon/DevOps-Bash-tools (fetch)
origin  git@github.com:HariSekhon/DevOps-Bash-tools (push)
origin  git@gitlab.com:HariSekhon/DevOps-Bash-tools (push)
origin  git@bitbucket.org:HariSekhon/DevOps-Bash-tools (push)
origin  git@ssh.dev.azure.com:v3/harisekhon/GitHub/DevOps-Bash-tools (push)
```

A standard git push will then push to all URLs for upstream hosted repos:

```shell
$ git push
To https://github.com/HariSekhon/DevOps-Bash-tools
   b51469d1..67f690a4  master -> master
To https://bitbucket.org/HariSekhon/DevOps-Bash-tools
   b51469d1..67f690a4  master -> master
To https://dev.azure.com/harisekhon/GitHub/_git/DevOps-Bash-tools
   b51469d1..67f690a4  master -> master
To https://gitlab.com/HariSekhon/DevOps-Bash-tools
   b51469d1..67f690a4  master -> master
```

This even works with push deletes so watch out (although you'd have time while it iterates through to `Ctrl`-`C` it:

```shell
$ git push origin gantt --delete
To https://github.com/HariSekhon/DevOps-Bash-tools
 - [deleted]         gantt
To https://bitbucket.org/HariSekhon/DevOps-Bash-tools
 - [deleted]         gantt
To https://dev.azure.com/harisekhon/GitHub/_git/DevOps-Bash-tools
 - [deleted]         gantt
To https://gitlab.com/HariSekhon/DevOps-Bash-tools
 - [deleted]         gantt
```

Pull from all remotes:

```shell
git pull --all
```

Fetch all branches from all remotes but does not merge changes in, similar to `git fetch` but for all branches:

```shell
git remote update
```

#### Advanced - push to different branch on remote

Configures the remote to push local master branch to dev branch upstream

```shell
git config remote.<name>.push master:dev
```

### Set Git Commit Author using Environment Variables (for CI/CD workflows)

Using Git environment variables is a less hardcoded way of setting the Git Commit Author for `git commit` steps in
[CI/CD](ci-cd.md) workflows:

Git requires all four of these environment variables otherwise `git commit` errors out with `Author identity unknown` or
`Committer identity unknown` since technically the committer could be different to the code author.

`GIT_AUTHOR_NAME` and `GIT_AUTHOR_EMAIL` -  the identity of the person who made the changes

`GIT_COMMITTER_NAME` and `GIT_COMMITTER_EMAIL` - the identity of the person who committed the changes

Since setting all four environment variables is for Author vs Committer is a hassle, especially given the Committer is
usually the same as the author, it's probably easier to set the only two `GIT_AUTHOR_*`
environment variables and then put this in your CI/CD to unify them using the one set of config:

```shell
git config user.name "$GIT_AUTHOR_NAME"
git config user.email "$GIT_AUTHOR_EMAIL"
```

This allows you to abstract out the Git Author & Committer identity to the top of your CI/CD workflow using
enironment variable for easier maintenance but variablize the code.

### Fix Author / Email in Git Pull Request or History

If you've accidentally committed using your personal email at work or worse, your work email in your public github
projects, I've written a script to make this easy by wrapping `git filter-branch`.

A force push would be required which will replace all later hash refs after the first change and cause conflicts
with existing checkouts which if merged could re-introduce the bit you don't want. You must coordinate with your peers
to replace their clones in that case if they're already pulled.

```shell
git clone https://github.com/HariSekhon/DevOps-Bash-tools bash-tools
bash-tools/git/git_filter_branch_fix_author.sh --help  # for details
```

### Erase Leaked Credential in Pull Request

GitHub has added automation for [support ticket](https://support.github.com/tickets) requests to delete a pull request containing a credential.

If you reset the branch contents and force push without the credential then you may not need to even delete the PR
as it'll replace the diff.

**First remove the credential from the file(s).**

Find the common divergence point for your branch:

```shell
base_branch="master"  # or main
your_branch="$(git branch --show-current)"
base_commit="$(git merge-base "$base_branch" "$yourbranch")"

git diff --name-only "$base_branch".."$your_branch" >> filelist.txt
```

Roll back the branch to the fork point:

```shell
git reset "$base_commit"
```

Re-add all the files you add/updated in this branch:

```shell
git add $(cat filelist.txt)
```

Re-commit all the changed files:

```shell
git commit -m "squashed all branch changes into one commit to wipe out the credential that shouldn't have been in there")
```

Then force push to overwrite the Pull Request contents to wipe out the leaked credential:

```shell
git push --force
```

(if you get an error you need to temporarily disable the force push branch protection)

### Convert GitHub.com links to Raw GitHub URL links

Raw content path for PNG images.

Sometimes GitHub doesn't give you the raw link for a PNG file that it does for an SVG file, eg. compare these two pages:

SVG has a raw link button:

<https://github.com/HariSekhon/Diagrams-as-Code/blob/master/images/kubernetes_traefik_ingress_gke.svg>

but PNG doesn't:

<https://github.com/HariSekhon/Diagrams-as-Code/blob/master/images/kubernetes_kong_api_gateway_eks.png>

Convert the standard GitHub page link to a raw link:

```shell
github_link="https://github.com/HariSekhon/Diagrams-as-Code/blob/master/images/kubernetes_kong_api_gateway_eks.png"
```

```shell
echo "$github_link" |
sed 's|https://github.com/|https://raw.githubusercontent.com/|; s|/blob/|/|'
```

output:

```text
https://raw.githubusercontent.com/HariSekhon/Diagrams-as-Code/master/images/kubernetes_kong_api_gateway_eks.png
```

### Git Filter-Repo

<https://github.com/newren/git-filter-repo>

3rd party Git command add-on that's useful for replacing a token, author name/email, or excluding files and is recommended over the lower-level `git filter-branch`.

### Git Filter-Repo Analyze

Creates a bunch of text files with interesting stats on the contents of the repo to figure out what to replace:

```shell
git filter-repo --analyze

less .git/filter-repo/analysis/*
```

### Git Filter-Repo Replace Text in Commit History

Useful to remove tokens accidentally committed.

It's too late if the commits with the token have been pushed as the upstream repo could have been cloned after push so
you can't get it back. If nobody has cloned you can force push to wipe it from the upstream history but you can't
guarantee that the repo wasn't pulled/cloned and that the token isn't compromised so it should be rotated and
invalidated for safety.

See [git_filter_repo_replace_text.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/git/git_filter_repo_replace_text.sh)

### Git Filter-Repo Remove File(s) from Commit History

Remove all the paths specified in the text file:

```shell
git filter-repo --invert-paths --paths-from-file paths_to_remove.txt  # --force
```

(`git filter-repo --help` for details on the path file format)

See [git_files_in_history.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/git/git_filter_repo_replace_text.sh)
to see what files are in the git history that you might want to remove.

### Erase Leaked Credential in Git History

Can also be used to remove reference to client names in public projects.

First clone [DevOps-Bash-tools](devops-bash-tools.md), then run the script in there:

```shell
bash-tools/git/git_filter_repo_replace_text.sh --help  # for details
```

### Merge a branch from another repo into the current repo

```shell
git fetch "$git_repo_url_or_checkout_directory" +"$remote_branch":"$locally_mirrored_branch"
```

Merge it into the current branch, eg. `main`

```shell
git merge --allow-unrelated-histories "$locally_mirrored_branch"
```

Then see the [Git Filter-Repo Remove File(s) from Commit History](#git-filter-repo-remove-files-from-commit-history)
section to remove files from the history of the other repo that you don't want polluting and bloating your new repo.

### Reset and Re-download Git Submodule

To resolve submodule update merge conflicts:

1. Delete the submodule directory
2. Delete the `.git/modules` cache of the submodule

```shell
rm -fr ".git/modules/$name"
```

3. Re-initialize the submodule

```shell
git submodule update --init --recursive
```

### Get the Default Branch

```shell
git symbolic-ref refs/remotes/origin/HEAD | sed 's|.*/||'
```

### Get Current Branch

```shell
git rev-parse --abbrev-ref HEAD
```

In newer versions of Git version 2.22 (Q2 2019+):

```shell
git branch --show-current
```

### Find which upstream `<remote>/<branch>` the current branch is set to track

```shell
git for-each-ref --format='%(upstream:short)' "$(git symbolic-ref -q HEAD)"
```

### List files changed on current branch vs default branch

First find the trunk default branch to compare to the current branch:

```shell
default_branch="$(git symbolic-ref refs/remotes/origin/HEAD | sed 's|.*/||')"
```

Then find the changed files since branching from the trunk default branch:

```shell
git diff --name-only "$default_branch"..
```

or

```shell
git log --name-only --pretty="" "origin/$default_branch".. | sort -u
```

If you forget to the set the `default_branch` by running the first command you'll get this error:

```text
fatal: ..: '..' is outside repository at '/Users/hari/github/bash-tools'
```

### List files added on current branch vs default branch

```shell
default_branch="$(git symbolic-ref refs/remotes/origin/HEAD | sed 's|.*/||')"
```

```shell
git log --diff-filter=A --name-only --pretty="" "origin/$default_branch".. | sort -u
```

### Push New Branch and Set Upstream in One Command

```shell
git push --set-upstream origin "$(git rev-parse --abbrev-ref HEAD)"
```

### Push New Branch and Raise Pull Request in One Command

Using [DevOps-Bash-tools](devops-bash-tools.md) repo scripts:

#### On GitHub

Push and open the PR in your web browser to click complete:

```shell
github_push_pr_preview.sh
```

Push and create the PR immediately (see `--help` description for options including immediately merge):

```shell
github_push_pr.sh
```

#### On GitLab

Push and open the PR in your web browser to click complete:

```shell
gitlab_push_pr_preview.sh
```

Push and create the PR immediately (see `--help` description for options including immediately merge):

```shell
gitlab_push_pr.sh
```

If sourcing [DevOps-Bash-tools](devops-bash-tools.md) `.bashrc` then you can simply type:

```shell
pushu  # to push and preview the PR
```

or

```shell
pushup  # to push and raise the PR
```

## Git LFS

<https://git-lfs.com/>

Store big files in GitHub repos (1GB limit for free accounts).

I used this to store old training materials like videos, PDFs, zip files etc. so they are safe and I can then save space locally.

GitHub will block files over 100MB from being `git push` otherwise.

Install Git LFS extension on Mac:

```shell
brew install git-lfs
```

Install the Git LFS config into your `$HOME/.gitconfig`:

```shell
git lfs install
```

In your repo add the big file types to be tracked in your local repo (configures `.gitattributes`):

```shell
git lfs track '*.mp4'
```

Commit the `.gitattributes` changes:

```shell
git add .gitattributes
git commit -m "add mp4 file type to be tracked by Git LFS in .gitattributes"
```

Override global extensive [.gitignore](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/.gitignore)
if you've copied it from or installed [DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools#readme) using a local repo `.gitignore`.

See [files being ignored](#show-files-not-being-tracked-due-to-global--local-gitignore-files).

```shell
echo '!*.mp4' >> .gitignore
git commit -m "allowed .mp4 files to be git committed in .gitignore"
```

```shell
git add *.mp4
```

```shell
git commit -m "added mp4 videos"
```

Automatically uploads the files to GitHub or whatever is configured as your upstream Git server using LFS storage:

```shell
git push
```

See LFS details:

```shell
git lfs env
```

On another computer you must install Git LFS before you clone.

Otherwise you'll get a checkout with 4K pointer files instead of the actual file contents because Git LFS smudges the checkout to
download the file blobs to replace in your checkout.

### Why You Need Git LFS for Large Files

You'll get errors like this trying to push large files to GitHub:

```shell
$ git push -u origin master
Enumerating objects: 52, done.
Counting objects: 100% (52/52), done.
Delta compression using up to 4 threads
Compressing objects: 100% (52/52), done.
Writing objects: 100% (52/52), 584.76 MiB | 2.05 MiB/s, done.
Total 52 (delta 0), reused 0 (delta 0)
remote: warning: File COURSE.pdf is 69.89 MB; this is larger than GitHub's recommended maximum file size of 50.00 MB
remote: warning: File COURSE2.pdf is 64.61 MB; this is larger than GitHub's recommended maximum file size of 50.00 MB
remote: error: Trace: 98e304dad85b91bcb5f726886ddce1b51a5b450523fc93f44ea51e64b444b69c
remote: error: See https://gh.io/lfs for more information.
remote: error: File COURSE.mp4 is 100.27 MB; this exceeds GitHub's file size limit of 100.00 MB
remote: error: GH001: Large files detected. You may want to try Git Large File Storage - https://git-lfs.github.com.
To github.com:HariSekhon/training-old.git
 ! [remote rejected] master -> master (pre-receive hook declined)
error: failed to push some refs to 'git@github.com:HariSekhon/training-old.git'
```

### Git LFS on other hosting providers

GitLab works fine for both push and clone.

Azure DevOps seems to work for push but doesn't show the file contents in the web UI preview and cloning resulted in a checkout error after clone and neither `git restore --source=HEAD :/` nor `git reset HEAD --hard` worked to get Git LFS to smudge and download the large files.

Unfortunately GitHub limits large files to only 1GB for free accounts, so only use it for files over 100MB. GitHub will disable your LFS after you go over the thresholds for storage or bandwidth usage for the month.

Bitbucket is useless because the [free tier](https://bitbucket.org/harisekhon/workspace/settings/plans) only gives 1GB storage (use GitHub instead):

```shell
$ git push bitbucket
Uploading LFS objects:   0% (0/51), 0 B | 0 B/s, done.
batch response:
********************************************************************************
[ERROR] Your LFS push failed because you're out of file storage
[ERROR] Change your plan to get more file storage:
[ERROR] https://bitbucket.org/account/user/harisekhon/plans
********************************************************************************

error: failed to push some refs to 'git@bitbucket.org:HariSekhon/training-old.git'
```

Bitbucket also requires disabling locking:

```shell
git config lfs.https://ssh.dev.azure.com/v3/<user>/<project>/<repo>.git/info/lfs.locksverify false
```

[Multi-origin](#multi-origin-remotes) pushes fail and require individual remote pushes:

```shell
$ git push
...
remote: GitLab: LFS objects are missing. Ensure LFS is properly set up or try a manual "git lfs push --all".
To gitlab.com:HariSekhon/training-old.git
 ! [remote rejected] master -> master (pre-receive hook declined)
error: failed to push some refs to 'git@gitlab.com:HariSekhon/training-old.git'
...

$ git push gitlab
```

**Partial port from private Knowledge Base page 2012+**
