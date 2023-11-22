# Git

Transcribed from private notes collected from `Date: 2012-01-31 13:39:23 +0000 (Tue, 31 Jan 2012)`

# Index

- [Branching Strategies](#branching-strategies)
- [Advanced Git Config](#advanced-git-config)
- [Git LFS](#git-lfs)
- [Tips & Tricks](#tips--tricks)
  - [Show files not being tracked due to .gitignore](#show-files-not-being-tracked-due-to-global---local-gitignore-files)
  - [Copy a file from another branch](#copy-a-file-from-another-branch)
  - [Multi-Origin Remotes](#multi-origin-remotes)

## Branching Strategies

### Great Tips

https://docs.microsoft.com/en-us/azure/devops/repos/git/git-branching-guidance?view=azure-devops

### GitHub Flow - Simplest

Best for personal projects

https://guides.github.com/introduction/flow/

### GitLab Flow

https://docs.gitlab.com/ee/topics/gitlab_flow.html

### Gitflow - Most Complicated

Best for legacy versioned software maintaining minor and patches semver versioning

https://datasift.github.io/gitflow/IntroducingGitFlow.html

https://nvie.com/posts/a-successful-git-branching-model/

# Advanced Git Config

https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/.gitconfig

https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/.gitignore

You can inherit all configs by just cloning the [repo](https://github.com/HariSekhon/DevOps-Bash-tools#readme) and `make link` to symlink them to your home directory:

```
git clone https://github.com/HariSekhon/DevOps-Bash-tools bash-tools
cd bash-tools
make link
```

# Git LFS

https://git-lfs.com/

Store big files on GitHub for free.

I use this to store old training materials like videos, PDFs, zip files etc so they are safe and I can then save space locally.

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
if you've copied it from or installed [DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools#readme) using a local repo `.gitignore`. See [files being ignored](#show-files-not-being-tracked-due-to-gitignore).
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

#### On another computer you must install Git LFS before you clone

Otherwise you'll get a checkout with 4K pointer files instead of the actual file contents because Git LFS smudges the checkout to
download the file blobs to replace in your checkout.

#### Why You Need Git LFS for Large Files

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

# Tips & Tricks

## Show files not being tracked due to global & local `.gitignore` files

```shell
git status --ignored
```

## Copy a file from another branch

```shell
git checkout "$branch" "$filename"
```

This puts it straight into the cache for commit, so you'll need to `git reset` if you don't want to commit it.

## Multi-Origin Remotes

Store your repo on multiple Git repo providers.

Useful for backups in case there is an outage to [GitHub](https://github.com) / [GitLab](https://gitlab.com) / [Bitbucket](https://bitbucket.org) / [Azure DevOps](https://dev.azure.com) - you can still pull / push to the other.

Add one or more remote repo URLs to the current git checkout:

See `bash-tools/git/git_remotes_set_multi_origin.sh` which automates this to all major Git hosting providers
```shell
git remote set-url --add origin $url2
git remote set-url --add origin $url3
```

See the remotes configured for origin:
```shell
$ git remote -v
origin  git@github.com:HariSekhon/DevOps-Bash-tools (fetch)
origin  git@github.com:HariSekhon/DevOps-Bash-tools (push)
origin  git@bitbucket.org:HariSekhon/DevOps-Bash-tools (push)
origin  git@ssh.dev.azure.com:v3/harisekhon/GitHub/DevOps-Bash-tools (push)
19:31:56 hari@agrippa: master ~/github/bash-tools >
```

A standard git push will then push to all URLs for upstream hosted repos:
```shell
git push
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
