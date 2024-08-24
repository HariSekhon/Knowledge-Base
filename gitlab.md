# GitLab

<https://gitlab.com>

GitLab is the number 2 hosting provider for Git repos after [GitHub](github.md)

It has good feature parity with GitHub.com, although less 3rd party CI/CD integrations as everybody integrates to GitHub first .

<!-- INDEX_START -->

- [GitLab CLI](#gitlab-cli)
- [GitLab CLI and API auth](#gitlab-cli-and-api-auth)
- [GitLab CI/CD](#gitlab-cicd)
- [GitLab Official CI/CD Library](#gitlab-official-cicd-library)
- [GitLab Profile Page](#gitlab-profile-page)

<!-- INDEX_END -->

## GitLab CLI

[Install doc](https://gitlab.com/gitlab-org/cli/-/blob/main/README.md#installation)

On Mac using [Homebrew](brew.md):
```shell
brew install glab
```

```shell
glab --help
```

Various GitLab CLI scripts are in [HariSekhon/DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools) repo.

Script to download latest binary from GitLab to `/usr/local/bin` or `$HOME/bin`:

```shell
git clone https://github.com/HariSekhon/DevOps-Bash-tools bash-tools
cd bash-tools
```
```shell
install/install_gitlab_cli.sh
```

## GitLab CLI and API auth

For the `glab` CLI above and the `gitlab_api.sh` script in the
[DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools) repo, create a Personal Access Token here:

[GitLab -> Preferences -> Access Tokens](https://gitlab.com/-/user_settings/personal_access_tokens)

The add this to your shell / Bash profile:

```shell
export GITLAB_TOKEN=...
```

Gitlab CLI config can be found here:

```
 ~/.config/glab-cli/config.yml
```

## GitLab CI/CD

Create a `.gitlab-ci.yml` into the root directory of your git repo, then `git push` to GitLab.

Template to get you started:

[.gitlab-ci.yml](https://github.com/HariSekhon/Templates/blob/master/.gitlab-ci.yml)

## GitLab Official CI/CD Library

[GitLab CI Library](https://gitlab.com/gitlab-org/gitlab/-/tree/master/.gitlab/ci)

## GitLab Profile Page

See adjacent [GitHub Profile Page](github.md#github-profile-page) doc.

**Partial port from private Knowledge Base page 2012+**
