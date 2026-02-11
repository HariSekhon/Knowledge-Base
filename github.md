# GitHub

NOT PORTED YET

<!-- INDEX_START -->

- [GitHub Skills Training](#github-skills-training)
- [Access](#access)
  - [Personal Access Tokens](#personal-access-tokens)
  - [Configure SSH Keys](#configure-ssh-keys)
  - [GitHub SSH Key SSO Authorization](#github-ssh-key-sso-authorization)
- [Git Clone over HTTPS using API Token](#git-clone-over-https-using-api-token)
  - [Credential Helper](#credential-helper)
- [Pull Requests](#pull-requests)
- [CodeOwners](#codeowners)
  - [CodeOwners Gotcha - Secret Teams](#codeowners-gotcha---secret-teams)
- [GitHub Profile Page](#github-profile-page)
- [Use Permalink URL References for Documentation or Support Issues](#use-permalink-url-references-for-documentation-or-support-issues)
- [GitHub Releases](#github-releases)
- [Analyze GitHub Repos](#analyze-github-repos)
  - [OpenHub](#openhub)
  - [SonarCloud](#sonarcloud)
  - [RepoGraph](#repograph)
  - [OctoInsight](#octoinsight)
  - [GitHub Linguist](#github-linguist)
  - [Cloc - Count Lines of Code](#cloc---count-lines-of-code)
- [Memes](#memes)
  - [O'Reilly - Choosing Based on GitHub Stars](#oreilly---choosing-based-on-github-stars)
  - [Baby Yoda Gets GitHub Stars](#baby-yoda-gets-github-stars)
  - [GitHub vs Sleep](#github-vs-sleep)
  - [Ransacking Someone's GitHub](#ransacking-someones-github)
  - [Met Wife in GitHub Issues Thread](#met-wife-in-github-issues-thread)
  - [The Lone Wolf Developer](#the-lone-wolf-developer)
  - [The Hungry Developer](#the-hungry-developer)
  - [Rutting Season](#rutting-season)
  - [Approving Own Pull Requests](#approving-own-pull-requests)

<!-- INDEX_END -->

## GitHub Skills Training

<https://skills.github.com/>

## Access

### Personal Access Tokens

Generate your token here:

<https://github.com/settings/tokens>

### Configure SSH Keys

Generate an SSH key:

```shell
ssh-keygen
```

(see [SSH](ssh.md#generate-an-ssh-key) page for more options)

Then upload the public key here:

<https://github.com/settings/keys>

### GitHub SSH Key SSO Authorization

If you're using SSH keys to `git clone` in a company using GitHub SSO authentication then you will need
to authorize your SSH keys for each organization in order to be able to use them.

On this page listing your SSH keys:

<https://github.com/settings/keys>

On the right of each key, click the `Configure SSO` drop-down and then next to the organizations you're a member of
click `Authorize`.

<https://docs.github.com/en/enterprise-cloud@latest/authentication/authenticating-with-saml-single-sign-on/authorizing-an-ssh-key-for-use-with-saml-single-sign-on>

## Git Clone over HTTPS using API Token

Cloning with HTTPS then becomes:

```shell
git clone "https://GITHUB_TOKEN@github.com/$ORG/$REPO.git"
```

or better using a credential helper...

### Credential Helper

Taken from my [.gitconfig](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/.gitconfig):

```properties
[credential "https://github.com"]
    # without the "sleep 1" the Git command may miss catching the output and hang instead
    helper = "!f() { sleep 1; echo \"username=${GITHUB_USER}\"; echo \"password=${GH_TOKEN:-${GITHUB_TOKEN}}\"; }; f"

[credential "https://gist.github.com"]
    helper = "!f() { sleep 1; echo \"username=${GITHUB_USER}\"; echo \"password=${GH_TOKEN:-${GITHUB_TOKEN}}\"; }; f"
```

```shell
git clone "https://github.com/$ORG/$REPO.git"
```

If you get a 401 or 403 authentication or authorization error, you can check Git debug output by setting:

```shell
export GIT_CURL_VERBOSE=1
```

## Pull Requests

Use Pull Requests to track changes and get peer review and approval.

Keep PRs as small and atomic as possible -
people's eyes will glaze over on big PRs resulting in `lgtm` approvals out of fatigue,
missing bad code or bugs into the repo and defeating
the quality control of peer review.

The more lines in a PR, there more likely your colleagues will miss something.

![1000 line GitHub PR](images/reviewing_1000_line_github_pull_request.jpeg)

Hopefully your more thorough 'rainman' coding bro comes along and revokes the approval.

![Review 1 vs Reviewer 2](images/github_pull_request_reviewer_1_vs_2.jpg)

## CodeOwners

[HariSekhon/Templates - .github/CODEOWNERS](https://github.com/HariSekhon/Templates/blob/master/.github/CODEOWNERS)

Enforce Pull Request reviews to all or given paths in the repo to this list of users or teams.

Auto-notifies these code owners requesting reviews when pull requests changing their files are raised.

### CodeOwners Gotcha - Secret Teams

When listing GitHub teams in the `.github/CODEOWNERS` file, the team must not be set to Secret otherwise it won't be
respected, on top of it requiring Write access to the repo.

## GitHub Profile Page

Create a GitHub repo with the same name as your GitHub profile username and in it create a `README.md` file
which will be automatically displayed as your GitHub profile home page.

You can do anything you normally can in Markdown - links, formatting, using HTML and embedding 3rd party tools like:

| URL                                                                                              | Description                                                                                                                                                |
|--------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| <https://shields.io>                                                                             | Badges                                                                                                                                                     |
| <https://komarev.com/ghpvc/>                                                                     | Profile hits counter                                                                                                                                       |
| [:octocat: anuraghazra/github-readme-stats](https://github.com/anuraghazra/github-readme-stats)  | Profile Stats or GitHub repos to list more repos than that annoying [arbitrary 6 repo pin limitation](https://github.com/orgs/community/discussions/28350) |

See my GitHub Home Profile page:

<https://github.com/HariSekhon>

which comes from this repo:

[:octocat: HariSekhon/HariSekhon](https://github.com/HariSekhon/HariSekhon)

GitLab uses this too but it puts a `Read more` link instead of displaying the whole page like GitHub.

## Use Permalink URL References for Documentation or Support Issues

When referencing GitHub lines or HTML anchors in [Documentation](documentation.md) or support issues,
use a permalink URL instead of the default branch link, which can change and misdirect your line number or anchor
references.

A permalink uses the commit hashref so that it always goes to that fixed line or anchor in history.

Press `y` on a page while browsing `GitHub.com` to change the current branch URL to a permalink hashref commit URL.

## GitHub Releases

Use GitHub Releases for artifacts ranging from compiled binary downloads or installers to periodically regenerated
images such as graphs that you want to reference in your `README.md` but you don't want to pollute your git
repo history with.

Create a `graphs` release:

```shell
gh release create "graphs" \
                  --repo "$repo" \
                  --title "$tag" \
                  --notes "" \
                  --latest \
                  --prerelease 2>/dev/null || :
```

Upload a file such as a regenerated graph to your release - this lives outside of the Git code repo history:

```shell
gh release upload "graphs" "$file" --clobber --repo "$repo"
```

The file is then available at the URL:

```text
https://github.com/$repo/releases/download/graphs/$file
```

## Analyze GitHub Repos

### OpenHub

(formerly Black Duck Open Hub)

<https://openhub.net/>

### SonarCloud

Gives lines of code and ode quality metrics like maintainability, security vulnerabilities, and technical debt.

You can see badges for this across [my public GitHub](https://github.com/HariSekhon) repos.

### RepoGraph

<https://repograph.io/>

### OctoInsight

<https://octoinsight.io/>

### GitHub Linguist

```shell
gem install github-linguist
```

```shell
linguist /path/to/repo
```

### Cloc - Count Lines of Code

[:octocat: AlDanial/cloc](https://github.com/AlDanial/cloc/)

Counts lines of code vs comments vs blanks.

Install on Mac:

```shell
brew install cloc
```

Install on Debian / Ubuntu:

```shell
sudo apt install cloc
```

Run it against a directory of code to count the lines of code:

```text
cloc /path/to/git/checkout
```

```shell
cloc ~/github/bash-tools
```

```text
github.com/AlDanial/cloc v 2.02  T=3.16 s (1084.1 files/s, 260706.2 lines/s)
---------------------------------------------------------------------------------
Language                       files          blank        comment           code
---------------------------------------------------------------------------------
JSON                              33              5              0         528324
Bourne Shell                    1594          26338          38702          70205
YAML                             885           6568          29712          41929
HCL                              192           3965           4595          16567
Markdown                          70           3964            321          13016
Text                              56            323              0           5004
SQL                              233            862           5533           4182
Groovy                           140            924           4122           3933
Bourne Again Shell                97           1219           3904           2337
XML                               24              9              9           1490
make                              21            352            373           1320
INI                               12            148              0            804
Maven                              1             62             68            342
Python                             7            108            401            235
Perl                               5             67             74            230
m4                                 5             55              3            216
Go                                 1             12             20             97
Ruby                              13             16            247             81
Dockerfile                         1             66            181             78
Properties                         8             54            133             77
Java                               4             31             54             63
Scala                              4             27             69             42
Gradle                             2             13             60             39
Jinja Template                     1              2              0             33
JavaScript                         3             31            152             30
Expect                             2              5             15             22
Puppet                             3              7             61             20
ASP                                1              4              1             11
SVG                                6              0              0              6
C                                  1              3              6              3
zsh                                1              1             13              3
PHP                                1              3              6              2
DOS Batch                          1              2              5              1
Visual Basic Script                1              3              5              1
Pig Latin                          1              2             14              0
---------------------------------------------------------------------------------
SUM:                            3430          45251          88859         690743
---------------------------------------------------------------------------------
```

Script in [DevOps-Bash-tools](devops-bash-tools.md) to count lines across all public original GitHub repos:

```shell
github_public_lines_of_code.sh
```

## Memes

### O'Reilly - Choosing Based on GitHub Stars

![](images/orly_book_choosing_by_github_stars_you_only_live_once.webp)

### Baby Yoda Gets GitHub Stars

![Waking up to 2000 More Stars](images/baby_yoda_wake_up_one_morning_2000_stars.jpeg)

### GitHub vs Sleep

![GitHub vs Sleep](images/github_vs_sleep_me_at_1am.jpeg)

### Ransacking Someone's GitHub

![Ransacking Someone's GitHub](images/orly_ransacking_someones_github.png)

### Met Wife in GitHub Issues Thread

![Met Wife in GitHub Issues Thread](images/met_wife_in_github_issue_thread.jpeg)

### The Lone Wolf Developer

Aren't you lucky this isn't me...

![Lone Wolf Developer](images/orly_lone_wolf_developer.png)

### The Hungry Developer

![Hungry Developer](images/orly_hungry_developer_elephant.png)

### Rutting Season

![Rutting Season](images/orly_rutting_season_how_to_face_off_with_other_devs.png)

**Disclaimer**: seriously, don't get married, you can't control the forking today.

### Approving Own Pull Requests

Don't approve your own pull requests.

![Me Approving My Own Pull Requests](images/me_approving_my_own_pull_requests.jpeg)
